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

# verifie que le -Name envoie vers un fichier qui existe, et supprime les dossiers de destination s'ils existent
$nomArchive = (Get-Item $Name).BaseName
$dossierArchive = (Get-Item $Name).DirectoryName
if (-Not (Test-Path -Path "$Name")) {
    Write-Warning "Le fichier $Name n'existe pas."
    throw
}
if (Test-Path -Path "$dossierArchive/$nomArchive") {
    Write-Warning "Le dossier $nomArchive existe deja > Suppression"
    Remove-Item -Path "$dossierArchive/$nomArchive" -Recurse -Force
}
if (Test-Path -Path "$dossierArchive/PackageTmp") {
    Write-Warning "Le dossier PackageTmp existe deja > Suppression"
    Remove-Item -Path "$dossierArchive/PackageTmp" -Recurse -Force
}

# creation du nom d'un dossier temporaire (ffffff sont les milisecondes)
$tempUnzip = "$dossierArchive\temp-$(get-date -f yyyyMMdd-fffffff)"

# verifie si 7zip est installé
$7zInfo = Get-Package -Name 7-Zip* -ErrorAction SilentlyContinue

# si non, lance l'install depuis le site
# (https://gist.github.com/SomeCallMeTom/6dd42be6b81fd0c898fa9554b227e4b4)
if (!$7zInfo) {
    Write-Warning "Installation de 7-Zip..."
    $dlurl = 'https://7-zip.org/' + (Invoke-WebRequest -UseBasicParsing -Uri 'https://7-zip.org/' | Select-Object -ExpandProperty Links | Where-Object {($_.outerHTML -match 'Download')-and ($_.href -like "a/*") -and ($_.href -like "*-x64.exe")} | Select-Object -First 1 | Select-Object -ExpandProperty href)
    $installerPath = Join-Path $env:TEMP (Split-Path $dlurl -Leaf)
    Invoke-WebRequest $dlurl -OutFile $installerPath
    Start-Process -FilePath $installerPath -Args "/S" -Verb RunAs -Wait
    Remove-Item $installerPath
    $7zInfo = Get-Package -Name 7-Zip*
}

# pour info, extraction avec .NET (ne marche pas ici car path > 256 caracteres) :
# [Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem")
# [System.IO.Compression.ZipFile]::ExtractToDirectory($Name, $tempUnzip)

# decompresse avec 7zip
$7zInstallLocation = $7zInfo.Metadata.Values[3]
$7zPath = "${7zInstallLocation}7z.exe"
Set-Alias 7Zip $7zPath
7zip x $Name -o"$tempUnzip" -bsp1

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
    Write-Warning "Plusieurs dossiers PackageTmp trouvés > déplacés et renommés en $nomArchive-X"
    Remove-Item $tempUnzip -Recurse -Force
}
elseif ($objetPackageTmp.count -eq 1) {
    foreach ( $dossier in $objetPackageTmp ) {
        Move-Item -Path $dossier.FullName -Destination $dossierArchive
        Rename-Item -Path $dossierArchive\PackageTmp -NewName "$dossierArchive\$nomArchive"
    }
    Write-Warning "Dossier PackageTmp trouvé > déplacé et renommé en $nomArchive"
    Remove-Item $tempUnzip -Recurse -Force
}
else {
    Write-Warning "Aucun dossier PackageTmp trouvé > archive extraite dans $nomArchive"
    Rename-Item -Path $tempUnzip -NewName $nomArchive
}
}