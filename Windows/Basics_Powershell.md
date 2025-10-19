### Se déplacer à la racine ou dans le répertoire utilisateur (Alias: `sl` ou `cd`)	:		
```powershell
Set-Location \
Set-Location ~
```


### Afficher l’emplacement actuel (Alias: `pwd` ou `gl`) :
```powershell
Get-Location
```


### Afficher les infos réseaux (Alias: `gip` ou `ipconfig`)
```powershell
Get-NetIPConfiguration
```


### Afficher le contenu de C:\  (alternative: `gci C:`  `dir C:`  `ls C:`)
```powershell
Get-ChildItem -Path "C:\"  
```


### Redémarrer la machine (eq: `shutdown /r /t 0`)
```powershell
Restart-Computer   
```


### Éteindre la machine (eq: `shutdown /s /t 0`)
```powershell
Stop-Computer 	  
```


### Renommer/bouger un fichier (Alias: `rni` et `mi`)
```powershell
Rename-Item
Move-Item			
```