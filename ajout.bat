@echo off
net user 20211001moikad Azerty1+ /add /expires:27/03/23 /times:lundi-vendredi,08-17
net user 20211001dutjer Azerty1+ /add /expires:27/03/23 /times:lundi-vendredi,08-17
net user 20211001bibste Azerty1+ /add /expires:27/03/23 /times:lundi-vendredi,08-17
net user 20211001marnad Azerty1+ /add /expires:27/03/23 /times:lundi-vendredi,08-17

md E:\fichiersutilisateurs\formateurs\moikad
md E:\fichiersutilisateurs\formateurs\dutjer
md E:\fichiersutilisateurs\formateurs\bibste
md E:\fichiersutilisateurs\formateurs\marnad

net share commun /delete
net share commun=E:\fichiersutilisateurs\commun /grant:Administrateurs,full /grant:20231001,full /grant:Formateurs,full
net share 20211001moikad=E:\fichiersutilisateurs\formateurs\moikad /grant:Administrateurs,full /grant:20211001moikad,full
net share 20211001dutjer=E:\fichiersutilisateurs\formateurs\dutjer /grant:Administrateurs,full /grant:20211001dutjer,full
net share 20211001bibste=E:\fichiersutilisateurs\formateurs\bibste /grant:Administrateurs,full /grant:20211001bibste,full
net share 20211001marnad=E:\fichiersutilisateurs\formateurs\marnad /grant:Administrateurs,full /grant:20211001marnad,full

net group Formateurs /add
net group Formateurs 20211001moikad /add
net group Formateurs 20211001dutjer /add
net group Formateurs 20211001bibste /add
net group Formateurs 20211001marnad /add