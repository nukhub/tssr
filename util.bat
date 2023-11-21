@echo off
setlocal enabledelayedexpansion
:: (necessaire, voir https://stackoverflow.com/questions/41323488/batch-replacing-with-percent-symbol)
title script ivan

set pathdefaut=%path%
set flecheoui=[7m[92m OK [0m[0m
set flechenon=[7m[91m NO [0m[0m
set firefox=[7m[91m Firefox [0m[0m
set edge=[7m[94m Edge [0m[0m

for /f "tokens=1-2 delims=:" %%a in ('ipconfig^|find "IPv4"^|find ": 172."') do set ip1==%%b
for /f "tokens=1-2 delims=:" %%a in ('ipconfig^|find "IPv4"') do set ip2==%%b
set ip1=%ip1:~1%
set ip2=%ip2:~1%

:menu0
cls
set heure0=%time:~0,5%
set heure=%heure0: =%
echo [7m%date%@%heure::=h%[0m
echo.
echo server    : %logonserver%
echo computer  : %computername%
echo username  : %username%
echo ip locale :%ip1% /%ip2%
echo.
echo ---- Accueil
echo.
echo 1. Dossiers
echo 2. Fichiers
echo 3. Path
echo 4. [7m[94m M [95m E [91m T [93m E [92m O [0m[0m
echo 5. Recherche Google
echo 6. Invite de commandes
echo 7. Utilitaires
echo.
echo 9. (quitter)
echo.
choice /c 12345679
if errorlevel 8 exit
if errorlevel 7 goto menu6
if errorlevel 6 start cmd.exe & goto menu0
if errorlevel 5 goto menu3
if errorlevel 4 goto choix31
if errorlevel 3 goto menu2
if errorlevel 2 goto menu5
if errorlevel 1 goto menu1

:menu1
cls
set heure0=%time:~0,5%
set heure=%heure0: =%
echo [7m%date%@%heure::=h%[0m
echo.
echo ---- Dossiers
echo.
echo 1. Creer
echo 2. Renommer
echo 3. Supprimer
echo.
echo 8. (...retour)
echo 9. (quitter)
echo.
choice /c 12389
if errorlevel 5 exit
if errorlevel 4 goto menu0
if errorlevel 3 goto choix13
if errorlevel 2 goto choix12
if errorlevel 1 goto choix11

:menu2
cls
set heure0=%time:~0,5%
set heure=%heure0: =%
echo [7m%date%@%heure::=h%[0m
echo.
echo ---- Path
echo.
echo 1. Ajouter au Path
echo 2. Restaurer Path par defaut
echo.
echo.
echo 8. (...retour)
echo 9. (quitter)
echo.
choice /c 12389
if errorlevel 5 exit
if errorlevel 4 goto menu0
if errorlevel 3 goto menu2
if errorlevel 2 goto choix22
if errorlevel 1 goto choix21

:choix11
cls
echo Reperetoires dans %cd% :
dir /b /ad /s
echo.
echo Nom du dossier ? (il sera cree dans %cd%)
echo.
set /p nomdossier= 
md %nomdossier%
cls
echo Reperetoires dans %cd% :
dir /ad /s /b
echo.
echo %flecheoui% Dossier %cd%%nomdossier% cree.
echo.
choice /m "Encore "
if errorlevel 2 goto menu1
if errorlevel 1 goto choix11

:choix12
cls
echo Reperetoires dans %cd% :
dir /ad /s /b
echo.
echo Dossier a renommer ?
echo.
set /p ancien=
echo.
echo Nouveau nom ?
echo.
set /p nouveau=
if exist %ancien%\ (
	ren %ancien% %nouveau%
	cls
	echo Reperetoires dans %cd% :
	dir /ad /s /b
	echo.
	echo %flecheoui% Renomme %cd%%ancien% en %nouveau%.
	) else (
	cls
	echo Reperetoires dans %cd% :
	dir /ad /s /b
	echo.
	echo %flechenon% Le dossier %cd%%ancien% n'existe pas...
	)
echo.
choice /m "Encore "
if errorlevel 2 goto menu1
if errorlevel 1 goto choix12

:choix13
cls
echo Reperetoires dans %cd% :
dir /ad /s /b
echo.
echo Dossier a supprimer ?
echo.
set /p nomdossier=
if exist %nomdossier%\ (
	rd %nomdossier% /s /q
	cls
	echo Reperetoires dans %cd% :
	dir /ad /s /b
	echo.
	echo %flecheoui% Dossier %cd%%nomdossier% supprime.
	) else (
	cls
	echo Reperetoires dans %cd% :
	dir /ad /s /b
	echo.
	echo %flechenon% Le dossier %cd%%nomdossier% n'existe pas...
	)
echo.
choice /m "Encore "
if errorlevel 2 goto menu1
if errorlevel 1 goto choix13

:choix21
cls
path
echo.
echo Chemin a ajouter ?
echo.
set /p papath=
path %papath%;%path%
cls
path
echo.
echo %flecheoui% ajoute au PATH.
echo.
choice /m "Encore "
if errorlevel 2 goto menu2
if errorlevel 1 goto choix11

pause
goto menu2

:choix22
cls
path
echo.
choice /m "Restaurer PATH par defaut "
if %errorlevel%==1 path %pathdefaut% & goto 12confirm
if %errorlevel%==2 goto menu1
:12confirm
cls
path
echo.
echo %flecheoui% PATH par defaut restaure.
echo.
pause
goto menu2

:choix31
cls
echo Ville ? (ou code postal)
set /p ville=
cls
echo Patience...
curl wttr.in/%ville%
echo.
pause
goto menu0

:menu3
cls
set heure0=%time:~0,5%
set heure=%heure0: =%
echo [7m%date%@%heure::=h%[0m
echo.
echo ---- Navigateur ?
echo.
echo 1. Navigateur par defaut
echo 2. %firefox%
echo 3. %edge%
echo.
echo 8. (...retour)
echo 9. (quitter)
echo.
choice /c 12389
if errorlevel 5 exit
if errorlevel 4 goto menu0
if errorlevel 3 goto choix42
if errorlevel 2 goto choix41
if errorlevel 1 goto choix43

:choix41
cls
echo %firefox% Mot cle ?
set /p motcle0=
set motcle1=%motcle0: =+%
set motcle2=!motcle1:"=%%22!
"%ProgramFiles%"\"Mozilla Firefox"\firefox.exe https://www.google.fr/search?q=%motcle2%
echo.
choice /m "Encore "
if errorlevel 2 goto menu0
if errorlevel 1 goto choix41
goto menu3

:choix42
cls
echo %edge% Mot cle ?
set /p motcle0=
set motcle1=%motcle0: =+%
set motcle2=!motcle1:"=%%22!
start microsoft-edge:https://www.google.fr/search?q=%motcle2%
echo.
choice /m "Encore "
if errorlevel 2 goto menu0
if errorlevel 1 goto choix42

:choix43
cls
echo Mot cle ?
set /p motcle0=
set motcle1=%motcle0: =+%
set motcle2=!motcle1:"=%%22!
start https://www.google.fr/search?q=%motcle2%
echo.
choice /m "Encore "
if errorlevel 2 goto menu0
if errorlevel 1 goto choix43

:menu5
cls
set heure0=%time:~0,5%
set heure=%heure0: =%
echo [7m%date%@%heure::=h%[0m
echo.
echo ---- Fichiers
echo.
echo 1. Cree fichier vide
echo 2. Renomme fichier
echo 3. Supprime fichier
echo.
echo 8. (...retour)
echo 9. (quitter)
echo.
choice /c 12389
if errorlevel 5 exit
if errorlevel 4 goto menu0
if errorlevel 3 goto choix53
if errorlevel 2 goto choix52
if errorlevel 1 goto choix51

:choix51
cls
echo Fichiers dans %cd% :
dir /b /s
echo.
echo Nom du fichier ? avec extension (il sera cree dans %cd%)
echo.
set /p nomfichier= 
type NUL > %nomfichier%
cls
echo Fichiers dans %cd% :
dir /b /s
echo.
echo %flecheoui% Fichier %cd%%nomfichier% cree.
echo.
choice /m "Encore "
if errorlevel 2 goto menu5
if errorlevel 1 goto choix51

:choix52
cls
echo Fichiers dans %cd% :
dir /b /s
echo.
echo Fichier a renommer ? (avec extension)
echo.
set /p ancien=
echo.
echo Nouveau nom ? (avec extension)
echo.
set /p nouveau=
if exist %ancien%\ (
	ren %ancien% %nouveau%
	cls
	echo Fichiers dans %cd% :
	dir /b /s
	echo.
	echo %flecheoui% Renomme %cd%%ancien% en %nouveau%.
	) else (
	cls
	echo Fichiers dans %cd% :
	dir /b /s
	echo.
	echo %flechenon% Le fichier %cd%%ancien% n'existe pas...
	)
echo.
choice /m "Encore "
if errorlevel 2 goto menu5
if errorlevel 1 goto choix52

:choix53
cls
echo echo Fichiers dans %cd% :
dir /b /s
echo.
echo Fichier a supprimer ? (avec extension)
echo.
set /p nomfich=
if exist %nomfich%\ (
	del %nomfich% /q
	cls
	echo Fichiers dans %cd% :
	dir /b /s
	echo.
	echo %flecheoui% Fichier %cd%%nomfich% supprime.
	) else (
	cls
	echo Fichiers dans %cd% :
	dir /b /s
	echo.
	echo %flechenon% Le fichier %cd%%nomfich% n'existe pas...
	)
echo.
choice /m "Encore "
if errorlevel 2 goto menu5
if errorlevel 1 goto choix53

:menu6
cls
set heure0=%time:~0,5%
set heure=%heure0: =%
echo [7m%date%@%heure::=h%[0m
echo.
echo ---- Utilitaires
echo.
echo 1. ipconfig
echo 2. msinfo32
echo 3. ncpa.cpl
echo 4. tasklist
echo.
echo 8. (...retour)
echo 9. (quitter)
echo.
choice /c 123489
if errorlevel 6 exit
if errorlevel 5 goto menu0
if errorlevel 4 goto choix64
if errorlevel 3 goto choix63
if errorlevel 2 goto choix62
if errorlevel 1 goto choix61

:choix61
cls
ipconfig
echo.
pause
goto menu6

:choix62
msinfo32
goto menu6

:choix63
ncpa.cpl
goto menu6

:choix64
cls
tasklist | more
pause
goto menu6