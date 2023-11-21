@echo off
FOR /F delims^=^ eol^= %%i IN (gens.txt) DO (
	md 20231001\%%i
	net share %%i /delete
	net share %%i=E:\fichiersutilisateurs\20231001\%%i /grant:%%i,full /grant:Administrateurs,full
	cmd /c "icacls E:\fichiersutilisateurs\20231001\%%i /grant %%i:(OI)(CI)(F) /T"
)
pause

:: 	icacls doit etre dans cmd /c, va savoir pourquoi