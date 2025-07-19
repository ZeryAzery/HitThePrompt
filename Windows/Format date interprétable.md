# Utiliser une date interprétable par le système avec ParseExact

[datetime]::ParseExact(...) permet de :
✅ Transformer une chaîne de caractères (ex : "16/06/2025")
➡️ en un objet DateTime réel que PowerShell (et tout Windows) peut comprendre et utiliser pour des opérations de date.

Par exemple lors de la création de scripts pour créer un nouvel utilisateur AD ou d'autres paramètres :

-AccountExpirationDate dans New-ADUser

Des comparaisons (if ($date -lt (Get-Date)))

Des calculs ($date.AddDays(30))

Des formats ($date.ToString("yyyy-MM-dd"))

💡 Si on tape juste :

```powershell
$date = "16/06/2025"
$date.GetType()
```
On remarque que $date est une string, pas une vraie date.
Si on fais :

```powershell
$date = [datetime]::ParseExact("16/06/2025", "dd/MM/yyyy", $null)
$date.GetType()
```
Ici on obtient un vrai [datetime], utilisable par le système.