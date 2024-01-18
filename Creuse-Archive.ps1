<#
.DESCRIPTION
    Fonction qui creuse dans une archive pour en extraire le dossier PackageTmp.
    Requiert 7zip pour fonctionner (https://www.7-zip.org/download.html).

    Exemples :
    Creuse-Archive -Name GEXSi.zip
    Creuse-Archive -Name .\GEXSi.zip
    Creuse-Archive -Name 'C:\Users\ivan\scripts\GEXSi.zip'
#>

function Creuse-Archive {    
    [CmdletBinding()]
    param (
    [Parameter(Mandatory = $true)]
    [string]$Name
    )

$nomArchive = (Get-Item $Name).BaseName
$dossierArchive = (Get-Item $Name).DirectoryName

# verifie que le -Name envoie vers un fichier qui existe, et verifie que les dossiers de destination n'existent pas

if (-Not (Test-Path -Path "$Name")) {
    Write-Warning "Le fichier $Name n'existe pas."
    throw
}

if (Test-Path -Path "$dossierArchive/$nomArchive") {
    Write-Warning "Le dossier $nomArchive existe deja."
    throw
}

if (Test-Path -Path "$dossierArchive/PackageTmp") {
    Write-Warning "Le dossier PackageTmp existe deja."
    throw
}

# creation d'un dossier temporaire (ffffff sont les milisecondes)

$tempUnzip = "$dossierArchive\temp-$(get-date -f yyyyMMdd-fffffff)"

# verifie si 7zip est installé, puis extrait l'archive

$7zInfo = Get-Package -Name 7-Zip*

if ($7zInfo) {
    $7zInstallLocation = $7zInfo.Metadata.Values[3]
    $7zPath = "${7zInstallLocation}7z.exe"
    Set-Alias 7Zip $7zPath
    7zip x $Name -o"$tempUnzip" -bsp1 
}
# s'il y a des dossiers avec des chemins d'accés plus long que 250 caractères, ca ne marche pas, il faut absolument 7zip, donc je vire cette partie :
# else {
#     Write-Warning "7-Zip n'est pas installé, extraction par defaut en cours..."
#     [Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem")
#     [System.IO.Compression.ZipFile]::ExtractToDirectory($choixArchive[0], $tempUnzip)
# }
else {
    Write-Warning "Ce script requiert l'installation de 7-Zip (https://www.7-zip.org/download.html)."
    throw
}

# liste les dossiers PackageTmp

$objetPackageTmp = Get-ChildItem $tempUnzip -Recurse -Directory | Where-Object { $_.Name -eq 'PackageTmp' }

# s'il y'en a, les deplaces, les renommes, et supprime le dossier temporaire, sinon, renomme juste le dossier temporaire

[int]$counter = 1

if ($objetPackageTmp.count -ge 2) {
    foreach ( $dossier in $objetPackageTmp ) {
        Move-Item -Path $dossier.FullName -Destination $dossierArchive
        Rename-Item -Path $dossierArchive\PackageTmp -NewName "$dossierArchive\$nomArchive-$counter"
        $counter++
    }
    Write-Warning "Plusieurs dossiers PackageTmp trouvés > déplacés et renommés en $nomArchive-X/"
    Remove-Item $tempUnzip -Recurse -Force
}
elseif ($objetPackageTmp.count -eq 1) {
    foreach ( $dossier in $objetPackageTmp ) {
        Move-Item -Path $dossier.FullName -Destination $dossierArchive
        Rename-Item -Path $dossierArchive\PackageTmp -NewName "$dossierArchive\$nomArchive"
    }
    Write-Warning "Dossier PackageTmp trouvé > déplacé et renommé en $nomArchive/"
    Remove-Item $tempUnzip -Recurse -Force
}
else {
    Write-Warning "Aucun dossier PackageTmp trouvé > archive extraite dans $nomArchive/"
    Rename-Item -Path $tempUnzip -NewName $nomArchive
}

}