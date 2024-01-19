$fichierFonction = '.\Creuse-Archive.ps1'

# verifie si le fichier existe bien
if (-Not (Test-Path -Path "$fichierFonction" -ErrorAction SilentlyContinue)) {
    Write-Warning "Le fichier $fichierFonction n'existe pas."
    throw
}

# appele la fonction
Import-Module $fichierFonction

# test
Creuse-Archive -Name '.\GexSi_Metier.zip'