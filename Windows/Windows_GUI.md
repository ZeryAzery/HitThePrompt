
# Raccourcis clavier utiles

### Ajouter un bureau virtuel
🪟 + `ctrl` + `d`


### Naviguer entre les bureaux virtuels
🪟 + `ctrl` + `→` ou `←`


### Fermer les bureaux virtuels
🪟 + `Tab`


### Retour bureau immédiat
🪟 + `d`


### Rouvrir un onglet fermé sur navigateur
`ctrl` + `Maj` + `T`


### Rouvrir les fenêtres d'un navigateur fermé
`ctrl` + `Shift` + `T`



---




<br>




### Fond d'écran Windows
```
C:\Windows\Web\
```

### Fond d'écran Utilisateur
```
C:\Users\<user-name>\AppData\Roaming\Microsoft\Windows\Themes\
```



---




<br>




## Applications sur la barre des tâches


### Chemin des app sur la barre des tâches 
```
C:\Users\<TonUtilisateur>\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar
```
```
%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar
```


Fichier binaire IconCache.db
```
C:\Users\<user>\AppData\Local\IconCache.db
```


### Fichier qui stoke les images des icones windows 
```
%windir%\system32\imageres.dll
```







---




<br>



## Changer la cible d'un raccourci

Dans la cible d'un raccourci (clic droit propriété) ajouter par exemple :
```bat
cmd.exe /c echo "action douteuse" "chemin\vers\le\fichier\normal"
```
Cette technique peut être utilisée par des attaquants pour effectuer des actions malicieuses


### Ajouter un raccourci à la barre des tâches qui n'est pas un programme
* Dans ce cas ça m'a permis d'ajouter un script ahk à la barre des taches
* Je fais pointer le programme ahk en tant que cible (donc épinglable)
* Puis ajouter le chemin du script en tant qu'argument
```
"C:\Program Files\AutoHotkey\v2\AutoHotkey.exe" "C:\Users\toto\Bureau\MonScript.ahk"
```


---




<br>




### Invoke-Item (alias = `ii`)
* Permet d'exécuter un/des programme(s) ou d'ouvrir un/des fichier(s) directement depuis le terminal
```powershell
Invoke-Item "C:\Users\User1\Documents\*.xls"
```
```powershell
ii  '.\CPUID HWMonitor.lnk'
```



---




<br>




# Activer wsl

```powershell
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
```

### Vérifier les services Hyper-V sont actif
```powershell
Get-Service hns, vmcompute
```

### Démarrer les services inactifs
```powershell
Start-Service vmcompute
Start-Service hns
```


### Lister les distributions disponibles pour WSL
```powershell
wsl --list --online
```


### Installer Debian
```powershell
wsl --install -d Debian
```
Faire `wsl` dans le terminal powershell pour accéder de nouveau à wsl



### Désinstaller une version de WSL (ex : Ubuntu)
```powershell
wsl --unregister Ubuntu
```


### Désactiver WSL complètement
```powershell
dism.exe /online /disable-feature /featurename:Microsoft-Windows-Subsystem-Linux /norestart
```
puis redémarrer