# Variables utilisateur courantes en PowerShell

## Nom de l’utilisateur
```powershell
$env:USERNAME
```


## Profil complet (ex : DOMAINE\Utilisateur)
```powershell
$env:USERDOMAIN\$env:USERNAME
```



## Dossier du profil utilisateur
```powershell
$env:USERPROFILE
```



## Dossier "Home" (équivalent Linux)
```powershell
$HOME
```



## Lister toutes les variables d’environnement
```powershell
Get-ChildItem Env:
```