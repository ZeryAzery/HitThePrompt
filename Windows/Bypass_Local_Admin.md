# Réinitialiser le mot de passe Admin de Windows 11
* __Objectif :__ Remplacer le bouton "Accessibilité" du login WIndows par une invite de commande CMD

Commencer par booter sur une clée Windows pour atteindre le mode oobe et faire shift + F10

## Remplacer utilman.exe par cmd.exe

Rentrer dans le dique C:\ (se servir de diskpart si besoin ) et backup `utilman.exe`
```batch
cd C:\Windows\System32
copy utilman.exe utilman.exe.bkp
```
On copy cmd sur utilman
```batch 
copy cmd.exe Utilman.exe
```
On redémarre (commande oobe)
```batch 
wpeutil reboot
```

* Cliquer sur le bouton "Accessibilité" devrait maintenant ouvrir l'invite de commande

Lister les compte locaux :
```batch 
net user
```
Changer le mot de passe Administrateur
```batch 
net user Aministrateur Mdp*2025
```
* Si une l'erreur système 8654 se produit c'est que le compte est protégé par LAPS.

Créer un nouveau compte local et l'ajouter au groupe administrateur
```batch 
net user admin Mdp*2025 /add
net localgroup Administrateurs admin /add
```

Renommer les .exe à leurs valeurs initiales après...
