# Utiliser une date interprétable par le système avec ParseExact

### `[datetime]::ParseExact(...)` permet de :
- ✅ Transformer une chaîne de caractères (ex : "16/06/2025")
- ➡️ en un objet DateTime réel que PowerShell (et tout Windows) peut comprendre et utiliser pour des opérations de date.

### Permet de faire :
- Des comparaisons `(if ($date -lt (Get-Date)))`
- Des calculs `($date.AddDays(30))`
- Des formats `($date.ToString("yyyy-MM-dd"))`


### ❌ Si on tape juste :
```powershell
$date = "16/06/2025"
$date.GetType()
```
__On remarque que `$date` est une string__, pas une vraie date.

### ✅ En revanche si on fais :
```powershell
$date = [datetime]::ParseExact("16/06/2025", "dd/MM/yyyy", $null)
$date.GetType()
```
__Ici on obtient un vrai `[datetime]`__, utilisable par le système.

### Exemple dans un scripts pour créer un nouvel utilisateur AD et ajouter une date de fin :
```powershell
$expdate = [datetime]::ParseExact('25/05/2026', 'dd/MM/yyyy', $null)
New-ADUser -SamAccountName t.test -AccountExpirationDate $expdate
```