# desinstallation :
# Uninstall-Module 7Zip4PowerShell -AllVersions -Force -Verbose
# 
# utilisation :
# Get-Command -Module 7Zip4Powershell
# 
# CommandType     Name                                               Version    Source
# -----------     ----                                               -------    ------
# Cmdlet          Compress-7Zip                                      2.4.0      7Zip4Powershell
# Cmdlet          Expand-7Zip                                        2.4.0      7Zip4Powershell
# Cmdlet          Get-7Zip                                           2.4.0      7Zip4Powershell
# Cmdlet          Get-7ZipInformation                                2.4.0      7Zip4Powershell

$7zModule = Get-InstalledModule 7Zip4Powershell
$infoPSGallery = Get-PSRepository -Name PSGallery

if (!$7zModule) {                                                   # verifie s'il est deja installé
    if ($infoPSGallery.InstallationPolicy -eq 'Untrusted') {        # verifie si la PSGallery a les droits
        Write-Warning "Autorisation PSGallery..."
        Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
        Write-Warning "Installation du module 7Zip4Powershell..."
        Install-Module -Name 7Zip4Powershell
        Write-Warning "Revocation PSGallery..."
        Set-PSRepository -Name "PSGallery" -InstallationPolicy Untrusted
        pause
    }
    else {
        Write-Warning "Installation du module 7Zip4Powershell..."
        Install-Module -Name 7Zip4Powershell
        pause
    }
}
else {
    Write-Warning "Module 7Zip4Powershell deja installe."
    Get-Command -Module 7Zip4Powershell
}

Write
