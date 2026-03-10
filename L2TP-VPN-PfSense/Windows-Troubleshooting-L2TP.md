# TROUBLESHOOTING VPN L2TP

### Vérifier / démarrer les services IPsec
```powershell
Get-Service PolicyAgent, IKEEXT, RasMan | Select Name, Status, StartType
```
Si un service est arrêté :
```PowerShell
Set-Service PolicyAgent -StartupType Automatic
Start-Service PolicyAgent

Set-Service IKEEXT -StartupType Automatic
Start-Service IKEEXT

Set-Service RasMan -StartupType Automatic
Start-Service RasMan
```

### Ouvrir les ports nécessaires (côté client)
Outbound
```PowerShell
New-NetFirewallRule -DisplayName "VPN UDP 500" -Direction Outbound -Protocol UDP -RemotePort 500 -Action Allow
New-NetFirewallRule -DisplayName "VPN UDP 4500" -Direction Outbound -Protocol UDP -RemotePort 4500 -Action Allow
New-NetFirewallRule -DisplayName "VPN UDP 1701" -Direction Outbound -Protocol UDP -RemotePort 1701 -Action Allow
```

Inbound
```PowerShell
New-NetFirewallRule -DisplayName "VPN UDP 500 IN" -Direction Inbound -Protocol UDP -LocalPort 500 -Action Allow
New-NetFirewallRule -DisplayName "VPN UDP 4500 IN" -Direction Inbound -Protocol UDP -LocalPort 4500 -Action Allow
New-NetFirewallRule -DisplayName "VPN UDP 1701 IN" -Direction Inbound -Protocol UDP -LocalPort 1701 -Action Allow
```

### Activer NAT-T (CRUCIAL si serveur derrière NAT)

Très fréquent avec L2TP/IPsec.
```PowerShell
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\PolicyAgent" `
-Name "AssumeUDPEncapsulationContextOnSendRule" `
-Value 2 -PropertyType DWord -Force
```
* 0 = désactivé
* 1 = client derrière NAT
* 2 = client et serveur derrière NAT (valeur la plus sûre)

### Journaux
```
eventvwr.msc
```
Journaux Windows → Application → Système

Filtre par source :
- RasClient
- IKEEXT
- RemoteAccess
- PolicyAgent

Journaux détaillés IPsec <br>
Applications and Services Logs → Microsoft → Windows → IKE → IPsec

### Voir les dernières erreurs VPN en PowerShell
```PowerShell
Get-WinEvent -LogName Application | Where-Object {$_.ProviderName -match "Ras"} | Select TimeCreated, Id, Message -First 20
```
Pour IKE :
```PowerShell
Get-WinEvent -LogName "Microsoft-Windows-IKE/Operational" -MaxEvents 20
```

