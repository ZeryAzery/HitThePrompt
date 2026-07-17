# 🪟 Aide au Scripting Powershell 🪟



---

<br>



### ©️ Afficher les méthodes et propriétés d'un objet avec `| gm`

```powershel
Get-WmiObject Win32_ComputerSystem | gm
```






### ⛔ Passer outre la politique d'exécution des scripts


Exécuter un script quelque soit le ExecutionPolicy
```powershell
Get-Content test.ps1 | iex
```
Ouvrir un shell dans le shell avec les droits bypass
```powershell
powershell.exe -exec bypass
```
Changer la valeur `ExecutionPolicy` pour le terminal en cours
```powershell
Set-ExecutionPolicy Bypass -Scope Process 
```
Changer la valeur `ExecutionPolicy` pour l'utilisateur en cours
```powershell
Set-ExecutionPolicy Unrestricted -Scope CurrentUser -Force
```


---

<br>



### 📍 Principaux types de données en PowerShell

Empêche d'affecter une valeur incorrecte

| Type | Description | Exemple |
| --------| -------- | ------------ | 
| `[string]` |	Chaîne de caractères (texte) | [string]$Nom = "Toto" |
| `[int]`	| 	Nombre entier			| 	[int]$Age = 30
| `[array]`	| 	Tableau (liste de valeurs)	| 	[array]$Couleurs = @("Rouge", "Bleu", "Vert")
| `[bool]`	| 	Booléen (Vrai/Faux)		| 	[bool]$Actif = $true
| `[double]` | 	Nombre décimal		| 		[double]$Prix = 19.99
| `[datetime]` | 	Date et heure		| 		[datetime]$Maintenant = Get-Date





---

<br>




# Hashtables et listes

### Déclarer un hashtable  
* Structure clé = valeur (comme dictinnaire python) 
* Les `{}` attendent une valeur pour chaque clé :
```powershell
$htable = @{
    "clé1" = "valeur1"
    "clé2" = "valeur2"
}
```



### Déclarer une liste 
Utiliser avec `()` 
```powershell
$liste = @(
    "3949"
    "3635"
    "3960"
    "3939"
    "1023"
)
```
Ne pas déclarer une liste avec des `{}` sinon Powershell attendra une valeur avec des `>>`.

| PowerShell | Python | Nom commun               |
| ---------- | ------ | ------------------------ |
| `@{}`      | `{}`   | Dictionnaire / Hashtable |
| `@()`      | `[]`   | Liste / Tableau          |





---

<br>




###  ☝️ Structures conditionnelles

Ces structures permettent d'exécuter un bloc de code sous certaines conditions.

|  Mot-clé |  Description                                |  Exemple |
|-----------|-----------------------------------------------|------------|
| `if`        | Exécute bloc de code si condition vraie       | if ($x -gt 10) { Write-Host "Plus grand que 10" } |
| `elseif`    | Vérifie autre condition si if est faux        | elseif ($x -eq 10) { Write-Host "C'est 10" } |
| `else`      | Exécute bloc si aucune condition remplie      | else { Write-Host "C'est plus petit" } |
| `switch`    | Alternative à plusieurs if                    | switch ($x) { 1 { "Un" }; 2 { "Deux" } } |


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

<br>

> [!IMPORTANT]
> * `else` n'a jamais de conditions derrière.
> * Et PowerShell attend obligatoirement cette syntaxe pour `else` :

✅ Syntaxe PowerShell stricte
```powershell
if ((5 -gt 3) -eq $true) { 
    Write-Host "C'est vrai"
} else {
    Write-Host "C'est faux"
}
```

❌ Contrairement aux langages C, C#, Python ou JS on ne peut pas faire :
```powershell
if ((5 -gt 3) -eq $true) { 
    Write-Host "C'est vrai"
}
else {
    Write-Host "C'est faux"
}
```
Dans ce cas Powershell interprêtera else comme une commande à part entière et génèrera une erreur.




---

<br>




### 🔄 Boucles (itérations)

Ces structures permettent de répéter une action plusieurs fois.

|  Mot-clé     |  Description                                |  Exemple |
|---------------|-----------------------------------------------|------------|
| `while`         | Répète tant que la condition est vraie        | while ($x -lt 5) { $x++ } |
| `do { } while`  | Exécute au moins une fois avant de tester     | do { $x++ } while ($x -lt 5) |
| `for`           | Répète un nombre défini de fois               | for ($i=0; $i -lt 5; $i++) { Write-Host $i } |
| `foreach`       | Parcourt chaque élément d'une collection      | foreach ($item in $tableau) { Write-Host $item } |




---

<br>



### 🔁 Saut de boucle / sortie de script

Ces mots-clés servent à interrompre ou passer une itération.

|  Mot-clé |  Description                            |  Exemple |
|-----------|-------------------------------------------|------------|
| `break`     | Arrête complètement la boucle             | if ($x -eq 5) { break } |
| `continue`  | Passe à l'itération suivante              | if ($x -eq 5) { continue } |
| `return`    | Quitte une fonction avec une valeur       | return "Fin de fonction" |
| `exit`      | Quitte complètement le script             | exit |




---

<br>



### ⚠️ Gestion des erreurs (Try-Catch)

Ces structures permettent de gérer les erreurs sans planter le script.

|  Mot-clé  |  Description                               |  Exemple                           |
|-------------|-----------------------------------------------|----------------------------------------|
| `try`         | Définit un bloc de code à tester              | try { Get-Item "C:\fichier.txt" }      |
| `catch`       | Capture erreur et exécute code alternatif     | catch { Write-Host "Erreur détectée" } |
| `finally`     | Exécute code  erreur ou non                   | finally { Write-Host "Terminé" }       |




---

<br>



## Les Alias 

Afficher les Alias
```powershell
Get-Alias
```

Afficher les Alias d'une commande précise
```powershell
Get-Alias -Definition Set-Location
```

| Alias | Commande              | Utilité                                                                                                           |
|------:|:----------------------|-------------------------------------------------------------------------------------------------------------------|
| gm    | Get-Member            | Affiche les membres (propriétés et méthodes) d’un objet. Très utile pour explorer les objets retournés par d’autres commandes.  |
| gcm   | Get-Command           | Liste toutes les commandes disponibles ou récupère des informations sur une commande spécifique.                        |
| %     | ForEach-Object        | Applique une action à chaque élément d’une collection.                                                       |
| ?     | Where-Object          | Filtre une collection en ne gardant que les éléments pour lesquels la condition est vraie.                               |
| ft    | Format-Table          | Affiche les objets en tableau                                                                         |
| fl    | Format-List           | Affiche les objets en liste, pratique pour voir toutes les propriétés d’un objet.                        |
| iex   | Invoke-Expression     | ⚠️ Exécute une chaîne de texte comme une commande PowerShell.                                                |
| irm   | Invoke-RestMethod     | Envoie des requêtes HTTP/HTTPS à des API REST. Utilisé pour interagir avec des services web RESTful (retourne souvent du JSON ou XML).   |
| iwr   | Invoke-WebRequest     | Plus généraliste qu’`irm`, permet d’envoyer des requêtes HTTP (GET, POST...) pour télécharger des pages, des fichiers, etc.           |
| gc    | Get-Content           | Lit le contenu d’un fichier ligne par ligne (utile pour lire des logs, scripts, etc.).                               |
| select | Select-Object        | Sélectionne les propriétés d'un objet ou d'un ensemble d'objets. Sélectionne des objets dans un tableau.           | 
      
__Exemple__
```powershell
Get-Service | ? { $_.Status -eq "Running" }
```



---

<br>



# Les différents opérateurs


### ✅ Opérateurs de comparaison (Comparison Operators)

Testent l’égalité ou la comparaison entre nombres/valeurs.

| Opérateur | Signification     |
|:---------:| ----------------- |
| `-eq`     | égal              |
| `-ne`     | différent         |
| `-gt`     | supérieur         |
| `-ge`     | supérieur ou égal |
| `-lt`     | inférieur         |
| `-le`     | inférieur ou égal |


→ Versions sensibles à la casse

`-ceq`, `-cne`, `-cgt`, `-cge`, `-clt`, `-cle`

__Exemple d'utilisation simple :__ (retournera "True" or "False")
```powershell
5 -ge 2
2 -ne 2
```



---

<br>



### 🔤 Opérateurs pour les chaînes (String Operators)

Wildcards, regex, recherches dans des collections.

| Opérateur      | Signification                           |
|:--------------:| --------------------------------------- |
| `-like`        | correspond avec wildcard (`*test*`)     |
| `-notlike`     | ne correspond pas aux wildcards         |
| `-match`       | correspond à une regex                  |
| `-notmatch`    | ne correspond pas à une regex           |
| `-contains`    | la collection contient l'élément        |
| `-notcontains` | la collection ne contient pas l'élément |
| `-in`          | l’élément est dans la collection        |
| `-notin`       | l’élément n’est pas dans la collection  |

Rajouter un `c` devant les opérateurs pour les rendre sensible à la casse

__Exemple__
```powershell
"hello" -like "he*"     # True (commence par "he")
```



---

<br>



### 🧠 Opérateurs logiques

Combinent plusieurs conditions.

| Opérateur | Signification                   |
|:---------:| ------------------------------- |
| `-and`    | logique "ET"                    |
| `-or`     | logique "OU"                    |
| `-not`    | logique "NON"                   |
| `!`       | négation (équivalent de `-not`) |

__Exemple__
```powershell
(5 -gt 3) -and (2 -lt 10)   # True
```



---

<br>



### 🔄 Opérateurs d'affectation

Modifient la valeur d’une variable.

| Opérateur | Signification                   |
|:---------:| ------------------------------- |
| `=`       | assignation simple              |
| `+=`      | addition puis assignation       |
| `-=`      | soustraction puis assignation   |
| `*=`      | multiplication puis assignation |
| `/=`      | division puis assignation       |

__Exemple__
```powershell
$x = 5
$x += 3      # x vaut maintenant 8
```


---

<br>


### 📝 Opérateurs de type (Type Operators)

Vérifient ou convertissent le type d’un objet

| Opérateur | Utilité                                                 |
|:---------:| ------------------------------------------------------- |
| `-is`     | teste si un objet est d’un type donné                   |
| `-isnot`  | teste si un objet n’est pas d’un type donné             |
| `-as`     | convertit vers un type (retourne `$null` si impossible) |

__Exemple__
```powershell
"123" -as [int]      # 123 (convertit la chaîne en entier)
```




---

<br>




### 🔍 Opérateurs divers utiles

Gammes, pipeline, exécution, arrays…

| Opérateur | Signification                          |
| --------- | -------------------------------------- |
| `..`      | range operator (ex : `1..5`)           |
| `,`       | opérateur d’array                      |
| `&`       | invoke operator (exécute une commande) |
| `.`       | dot-sourcing                           |
| `%`       | alias de `ForEach-Object`              |
| `?`       | alias de `Where-Object`                |

<br>

__Exemples:__

Produira : 1 2 3 4 5
```powershell
1..5        
```

`&` exécutera un programme via son chemin complet (si absent du PATH)
```powershell
& "C:\Program Files\7-Zip\7z.exe" a -tzip "Site-Malveillant.zip" "Site-Malveillant"       
```



---

<br>



### Pour les accents dans le terminal (au début du script)
```powershell
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()
```


### Pour les accents dans la sortie d'un fichier 
```powershell
Set-Content ... -Encoding utf8
```
### Utiliser return ou exit avec if
__"exit" va fermer le terminal__
```powershell
while ($Response -notin $Choices) {
    $Response = Read-Host "Voulez-vous continuer ? ('o' continuer, 'n' sortir)"
}

if ($Response -eq "n") {
    exit
}

# Si on arrive ici, c'est forcément "o"
```

__"return" va fermer le script__
```powershell
while ($Response -notin $Choices) {
    $Response = Read-Host "Voulez-vous continuer ? ('o' continuer, 'n' sortir)"
}

if ($Response -eq "n") {
    return
}
```


### Prendre un compte un espace vide
PowerShell est construit sur .NET, du coup on peux appeler les méthodes .NET directement.
```powershell
$Event = Get-WinEvent -FilterHashtable @{LogName = 'System';Level = 1,2,3;StartTime=(Get-Date).AddMinutes(-10)} -ErrorAction SilentlyContinue | Format-List | Out-String
$CritEvent = if ([string]::IsNullOrWhiteSpace($Event)) { "Aucun évènement système au cours de ces 10 dernières minutes." } else { $Event }
```