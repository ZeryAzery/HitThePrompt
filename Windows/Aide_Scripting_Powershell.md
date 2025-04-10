# Support d'aide au Scripting Powershell


## 📌 Principaux types de données en PowerShell:

Elles empêche d'affecter une valeur incorrecte

| 🟠Type | 👉Description | 👉Exemple |
| --------| -------- | ------------ | 
| [string] |	Chaîne de caractères (texte) | [string]$Nom = "Toto" |
| [int]	| 	Nombre entier			| 	[int]$Age = 30
| [array]	| 	Tableau (liste de valeurs)	| 	[array]$Couleurs = @("Rouge", "Bleu", "Vert")
| [bool]	| 	Booléen (Vrai/Faux)		| 	[bool]$Actif = $true
| [double] | 	Nombre décimal		| 		[double]$Prix = 19.99
| [datetime] | 	Date et heure		| 		[datetime]$Maintenant = Get-Date


## 📌 Structures conditionnelles

Ces structures permettent d'exécuter un bloc de code sous certaines conditions.

| 🔧 Mot-clé | 👉 Description                                | ✅ Exemple |
|-----------|-----------------------------------------------|------------|
| if        | Exécute bloc de code si condition vraie       | if ($x -gt 10) { Write-Host "Plus grand que 10" } |
| elseif    | Vérifie autre condition si if est faux        | elseif ($x -eq 10) { Write-Host "C'est 10" } |
| else      | Exécute bloc si aucune condition remplie      | else { Write-Host "C'est plus petit" } |
| switch    | Alternative à plusieurs if                    | switch ($x) { 1 { "Un" }; 2 { "Deux" } } |

⚠️ else n'a jamais de conditions derrière ! ⚠️

## 🔄 Boucles (itérations)

Ces structures permettent de répéter une action plusieurs fois.

| 🔧 Mot-clé     | 👉 Description                                | ✅ Exemple |
|---------------|-----------------------------------------------|------------|
| while         | Répète tant que la condition est vraie        | while ($x -lt 5) { $x++ } |
| do { } while  | Exécute au moins une fois avant de tester     | do { $x++ } while ($x -lt 5) |
| for           | Répète un nombre défini de fois               | for ($i=0; $i -lt 5; $i++) { Write-Host $i } |
| foreach       | Parcourt chaque élément d'une collection      | foreach ($item in $tableau) { Write-Host $item } |


## 🔁 Saut de boucle / sortie de script

Ces mots-clés servent à interrompre ou passer une itération.

| 🔧 Mot-clé | 👉 Description                            | ✅ Exemple |
|-----------|-------------------------------------------|------------|
| break     | Arrête complètement la boucle             | if ($x -eq 5) { break } |
| continue  | Passe à l'itération suivante              | if ($x -eq 5) { continue } |
| return    | Quitte une fonction avec une valeur       | return "Fin de fonction" |
| exit      | Quitte complètement le script             | exit |


## 🛑 Gestion des erreurs (Try-Catch)

Ces structures permettent de gérer les erreurs sans planter le script.

| 🔧 Mot-clé | 👉 Description                                | ✅ Exemple |
|-----------|-----------------------------------------------|------------|
| try       | Définit un bloc de code à tester              | try { Get-Item "C:\fichier.txt" } |
| catch     | Capture erreur et exécute code alternatif     | catch { Write-Host "Erreur détectée" } |
| finally   | Exécute code  erreur ou non                   | finally { Write-Host "Terminé" } |


## Alias

| Alias | Commande| 
| -----| -------- |  
| gm	| Get-Member | 
| gcm 	| Get-Command | 
| %  	| foreach | 
| fm	| Format-Table | 
| fl 	| Format-List | 
| iex 	| Invoke-Expression | 
| gc	| Get-Content | 


## 😱 Passer outre la politique d'exécution des scripts 
```powershell
Get-Content test.ps1 | iex
```
```powershell
powershell.exe -exec bypass
```




