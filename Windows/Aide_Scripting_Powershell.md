# Support d'aide au Scripting Powershell


## 📌 Principaux types de données en PowerShell

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

> [!IMPORTANT]  
> else n'a jamais de conditions derrière !

> [!TIP]
> switch peut utiliser "Default" pour gérer les erreurs comme dans cet exemple :

```powershell
$usrvalue = Read-Host "Indiquer un numéro pour lancer un logiciel"
switch ($usrvalue)
{
    "1" { Start-Process notepad.exe }
    "2" { Start-Process powershell.exe }
    Default { Write-Host Entree invalide }
}      
```

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

| 🔧 Mot-clé  | 👉 Description                               | ✅ Exemple                           |
|-------------|-----------------------------------------------|----------------------------------------|
| try         | Définit un bloc de code à tester              | try { Get-Item "C:\fichier.txt" }      |
| catch       | Capture erreur et exécute code alternatif     | catch { Write-Host "Erreur détectée" } |
| finally     | Exécute code  erreur ou non                   | finally { Write-Host "Terminé" }       |


## Alias and purposes

| Alias | Commande              | Utilité                                                                                                                                                    |
|-------|-----------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------|
| gm    | Get-Member            | Affiche les membres (propriétés et méthodes) d’un objet. Très utile pour explorer les objets retournés par d’autres commandes.                           |
| gcm   | Get-Command           | Liste toutes les commandes disponibles ou récupère des informations sur une commande spécifique.                                                           |
| %     | ForEach-Object        | Applique une action à chaque élément d’une collection.                                                                  |
| ft    | Format-Table          | Affiche les objets en tableau                                                                |
| fl    | Format-List           | Affiche les objets en liste, pratique pour voir toutes les propriétés d’un objet.                                                                          |
| iex   | Invoke-Expression     | ⚠️ Exécute une chaîne de texte comme une commande PowerShell.                                                |
| irm   | Invoke-RestMethod     | Envoie des requêtes HTTP/HTTPS à des API REST. Utilisé pour interagir avec des services web RESTful (retourne souvent du JSON ou XML).                    |
| iwr   | Invoke-WebRequest     | Plus généraliste qu’`irm`, permet d’envoyer des requêtes HTTP (GET, POST...) pour télécharger des pages, des fichiers, etc.                               |
| gc    | Get-Content           | Lit le contenu d’un fichier ligne par ligne (utile pour lire des logs, scripts, etc.).                                                                    |



## ⛔ Passer outre la politique d'exécution des scripts
 
```powershell
Get-Content test.ps1 | iex
```
```powershell
powershell.exe -exec bypass
```

## Déclarer un hashtable  (Structure clé = valeur, comme un dictinnaire en python) les {} attendent une valeur pour chaque clé :
```powershell
$liste = @{
    "clé1" = "valeur1"
    "clé2" = "valeur2"
}
```
## Si c'est juste pour une liste utiliser les "()" : (sinon powershell attendra une valeur avec des ">>") :
```powershell
$liste = @(
    "3949"
    "3635"
    "3960"
    "3939"
    "1023"
)
```

| PowerShell | Python | Nom commun               |
| ---------- | ------ | ------------------------ |
| `@{}`      | `{}`   | Dictionnaire / Hashtable |
| `@()`      | `[]`   | Liste / Tableau          |



