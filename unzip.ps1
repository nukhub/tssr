# liste les archives, situées dans le même dossier que le script

$archives = Get-ChildItem -File -Path * -Include *.zip,*.7z,*.rar,*.tar,*.gz,*.tar.gz

# rempli la table avec les infos nom de l'archive et chemin, et en donne la liste

$table = [ordered]@{}
[int]$num = 1

foreach ( $archive in $archives ) {
    $table.Add($archive.Name, $archive.FullName)
    Write-Host $num ":" $archive.Name "-" $archive.LastWriteTime
    $num++
}

# demande à l'utilisateur de choisir l'archive

[int]$choix0 = 0
[int]$choix = 0

Write-Host ""
$choix0 = Read-Host -Prompt "archive à traiter (1,2,3..) ?"
$choix = $choix0 - 1 # obligé de retirer 1 car le 1er objet de la hashtable est 0

$lezip = $table[$choix]

# extraction 7zip

$tempUnzip = ".\temp-$(get-date -f yyyyMMdd-fffffff)" # créé un dossier temporaire (ffffff sont les milisecondes)
$7zipPath = "$env:ProgramFiles\7-Zip\7z.exe"
Set-Alias 7Zip $7ZipPath

7zip x $lezip -o"$tempUnzip" -bsp1

# liste les dossiers PackageTmp

$objetPackageTmp = Get-ChildItem $tempUnzip -Recurse -Directory | Where-Object { $_.Name -eq 'PackageTmp' }

# s'ils y'en a, les deplace, les renomme, et supprime le dossier temporaire, sinon, renomme juste le dossier temporaire

if ($objetPackageTmp -ne $null) {
    foreach ( $dossier in $objetPackageTmp ) {
        Move-Item -Path $dossier.FullName -Destination .\
        Rename-Item -Path .\PackageTmp -NewName "Unzip_$(get-date -f yyyy-MM-dd_fffffff)"
    }
    Remove-Item $tempUnzip -Recurse -Force
}
else {

    Rename-Item -Path $tempUnzip -NewName "Unzip_$(get-date -f yyyy-MM-dd_fffffff)"
}

Write-Host
Write-Host "--> Archive : $lezip"
Write-Host "--> Dossier : Unzip_$(get-date -f yyyy-MM-dd)_(random)"
Write-Host
pause