# liste les archives, situées dans le même dossier que le script

$allArchives = Get-ChildItem -File -Path * -Include *.zip,*.7z,*.rar,*.tar,*.gz,*.tar.gz

if (-not $allArchives) {
    Write-Warning "Aucune archive trouvées (*.zip,*.7z,*.rar,*.tar,*.gz,*.tar.gz)"
    Pause
    throw
}

# rempli la table avec les infos nom de l'archive et chemin, et en donne la liste

$tableArchives = [ordered]@{}
[int]$compteur = 0

foreach ( $item in $allArchives ) {
    $tableArchives.Add($compteur, @($item.Name,$item.FullName,$item.BaseName))
    Write-Host $compteur ":" $item.Name "-" $item.LastWriteTime
    $compteur++
}

# demande à l'utilisateur de choisir l'archive

Write-Host
[int]$choix = $(Write-Host "[???] Archive à traiter (0,1,2,3...) ? " -ForegroundColor Yellow -NoNewline; Read-Host) # astuce pour ecrire le read-host en couleur

$choixArchive = $tableArchives[$choix]
$nomArchive = $choixArchive[2]

# verifie que le dossier de destination n'existe pas

if (Test-Path -Path $nomArchive) {
    Write-Warning "Le dossier $nomArchive existe deja."
    Pause
    throw    
}

# creation d'un dossier temporaire (ffffff sont les milisecondes)

$tempUnzip = ".\temp-$(get-date -f yyyyMMdd-fffffff)"

# verifie si 7zip est installé, puis extrait l'archive

$7zInfo = Get-Package -Name 7-Zip*

if ($7zInfo) {
    $7zInstallLocation = $7zInfo.Metadata.Values[3]
    $7zPath = "${7zInstallLocation}7z.exe"
    Set-Alias 7Zip $7zPath
    7zip x $choixArchive[1] -o"$tempUnzip" -bsp1 
}
# s'il y a des dossiers avec des chemins d'accés plus long que 250 caractères, ca ne marche pas, il faut absolument 7zip, donc je vire cette partie :
# else {
#     Write-Warning "7-Zip n'est pas installé, extraction par defaut en cours..."
#     [Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem")
#     [System.IO.Compression.ZipFile]::ExtractToDirectory($choixArchive[0], $tempUnzip)
# }
else {
    Write-Warning "Ce script requiert l'installation de 7-Zip (https://www.7-zip.org/download.html)."
    Pause
    throw
}

Write-Host

# liste les dossiers PackageTmp

$objetPackageTmp = Get-ChildItem $tempUnzip -Recurse -Directory | Where-Object { $_.Name -eq 'PackageTmp' }

# s'il y'en a, les deplaces, les renommes, et supprime le dossier temporaire, sinon, renomme juste le dossier temporaire

[int]$counter = 1

if ($objetPackageTmp.count -ge 2) {
    foreach ( $dossier in $objetPackageTmp ) {
        Move-Item -Path $dossier.FullName -Destination .\
        Rename-Item -Path .\PackageTmp -NewName ".\$nomArchive-$counter"
        $counter++
    }
    Write-Warning "Plusieurs dossiers PackageTmp trouvés : déplacés et renommés en $nomArchive-X/"
    Remove-Item $tempUnzip -Recurse -Force
}
elseif ($objetPackageTmp.count -eq 1) {
    foreach ( $dossier in $objetPackageTmp ) {
        Move-Item -Path $dossier.FullName -Destination .\
        Rename-Item -Path .\PackageTmp -NewName ".\$nomArchive"
    }
    Write-Warning "Dossier PackageTmp trouvé : déplacé et renommé en $nomArchive/"
    Remove-Item $tempUnzip -Recurse -Force
}
else {
    Write-Warning "Aucun dossier PackageTmp trouvé : archive extraite dans $nomArchive/"
    Rename-Item -Path $tempUnzip -NewName $nomArchive
}

Write-Host
pause