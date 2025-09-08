# 🪟 Administration en Powershell Core 🪟


Powershell n'a pas de sensiblité à la casse c'est juste visuel


## 🔰 Commandes de base 🔰

#### Trouver une commande (Alias: gcm):
```powershell
Get-Command *hash*
```
### Allonger la période d'essai Windows
```powershell
slmgr.vbs -rearm
```
### Se déplacer à la racine ou dans le répertoire utilisateur (Alias: sl)	:		
```powershell
Set-Location \
Set-Location ~
```
### Afficher l’emplacement actuel (`pwd` ou `sl`focntionne aussi) :
```powershell
Get-Location
 ```
### Afficher le contenu de C:\  (alternative: gci C:  dir C:  ls C:)
```powershell
Get-ChildItem -Path "C:\"  
```
* Sur serveur Core "Ctrl+Alt+Suprr" permet d'ouvrir le gestionnaire des tâches puis d'avoir la fenêtre "executer".

### Renommer la machine :
```powershell
Rename-Computer -NewName "SRV-W19-CORE-1" -Restart
```
### Affichera juste le nom de l'ordi :
Get-computerInfo | Select CsName 
```	

### Réinitialiser son mot de passe
```bat
net user Administrateur *
```
### Réinitialiser son MDP	sur domaine
```bat
net user  /domain administrateur *
```

### Arréter un processus
```powershell
Stop-Process -Id 2960
```
### Créer un fichier ou écrase ancien
```powershell
Set-Content -Path C:\Administrateur\Users\fichiertest -Value "Texte du fichier"
```
### Ajoute texte fichier existant
```powershell
Add-Content -Path C:\Administrateur\Users\fichiertest -Value "Ajoute Texte au fichier"
```
### Sur serveur core permet d'ouvrir le menu de config du serveur
```powershell
sconfig
```
### Addon VBox, monter iso puis (Semble inutile sur un serveur core) :	
```powershell
Set-Location D:\ 	
VBoxWidowsAdditions-amd64.exe 
```
### Redémarrer la machine (eq: shutdown /r /t 0)
```powershell
Restart-Computer   
```
### Éteindre la machine (eq: shutdown /s /t 0)
```powershell
Stop-Computer 	  
```
### tester l'écoute d'un port
```powershell		
Test-NetConnection -ComputerName localhost -Port 389
```


### Élément graphique sur serveur core 2025
```powershell
Add-WindowsCapability -Online -Name ServerCore.AppCompatibility
virtmgmt.msc
```



### Se servir de l'aide dans powershell
```powershell
# Télécharger les fichiers d'aide :
Update-Help 
```
### Afficher l'aide pour `Get-Process`
```powershell
Get-Help Get-Process
```
### Afficher les aides dans une fenêtre :
```powershell
Get-Help Unlock-BitLocker -ShowWindow
```



## Windows Software Licensing Management Tool

| Commande                | Ouvre...                                                      |
|-------------------------|---------------------------------------------------------------|
| `slmgr.vbs -rearm`      | Allonger la période d'essai Windows                           |
| `slmgr /xpr`            | Affiche si Windows est activé de façon permanente ou non      |
| `slmgr /ipk <clé>`      | Installe une clé de produit Windows                           |
| `slmgr /ato`            | Active Windows avec la clé installée                          |
| `slmgr /dlv`            | Affiche les détails de licence et d'activation                |
| `slmgr /dli`            | Affiche un résumé de l'état de la licence                     |
| `slmgr /upk`            | Supprime la clé de produit actuelle                           |




## 🍴 Point de restauration 🍴
* Autoriser un point de restauration à 0 minute (au lieu de 24h de base et où -Value 0 = 0 minutes)
```powershell
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" `
  -Name "SystemRestorePointCreationFrequency" -Value 0 -PropertyType DWord -Force
```

* Création d'un point de restauration
```powershell
Enable-ComputerRestore -Drive "C:\"
Checkpoint-Computer -Description "Avant Debloat" -RestorePointType "MODIFY_SETTINGS"
```



## 📶 Configurer le réseau 📶 
```powershell
# Afficher les infos réseaux (Alias: gip ou ipconfig)
Get-NetIPConfiguration

# Afficher plus d'infos
gip -Detailed

# Nom de la carte réseau
Get-NetAdapter

# Afficher les cartes réseau up:	
Get-NetAdapter | Where-Object { $_.Status -eq "Up" }

# Afficher n° carte réseau
Get-NetIPInterface 

# Afficher ipv4 et interfaces		
Get-NetIPAddress -AddressFamily IPv4 | select IPAddress, InterfaceAlias	

# IP statique et Gateway: 		
New-NetIPaddress -InterfaceIndex 4 -IPAddress 192.0.100.1 -PrefixLength 24 -DefaultGateway 10.0.0.254 (ou 4 est le num de la carte réseau)

# Configurer le DNS
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses ("8.8.8.8","8.8.4.4")

# Supprimer une adresse DNS 
Get-DnsClientServerAddress -InterfaceIndex 6 | Set-DnsClientServerAddress -ResetServerAddresses

# Vérifier l’accès au réseau
Test-Connection -ComputerName google.com

# Retirer une adresse IP
Remove-NetIPAddress -InterfaceIndex 4 -IPAddress 192.168.0.2 -PrefixLengh 24

# Retirer une adresse IP
Remove-NetIPAddress -IPAddress 192.168.100.1 -Confirm:$false

# Retirer la passerelle			
Remove-NetRoute -InterfaceAlias "Ethernet" -NextHop "192.168.0.254"

# Désactiver carte réseau
Disable-NetAdapter -Name  nom_carte_réseau

# Désactiver/Réactiver une carte réseau
Restart-NetAdapter -Name nom_carte_réseau

# Désactiver l'IPv6
Disable-NetAdapterBindin -InterfaceAlias "ethernet" -ComponentID ms_tcpip6

# Désactiver l'IPv6 partout
Get-NetAdapter | ForEach-Object { Disable-NetAdapterBinding -Name $_.Name -ComponentID ms_tcpip6 }
```



## 📂 Gestion des Objets 📂 
* Création/supression de dossiers avec cmd (/s suprimme tout son contenu)
```bat
md toto 
rd /s	
md COMPTABILITE, INFORMATIQUE, RH, PRODUCTION
```
```powershell
# Renommer un dossier :
Rename-Item -Path "C:\DATAS\DIRECTION" -NewName "D_DIRECTION"

# Créer un fichier texte  :
New-Item -Path C:\Administrateur\Users\fichiertest -ItemType File
 
# Supprimer un fichier/Dossier (Alias: ri (⚠️))	
Remove-Item COMPTABILITE, INFORMATIQUE, RH, PRODUCTION

# Renommer/bouger un fichier (Alias: rni et mi)
Rename-Item
Move-Item			
```
```bash	
# Renommer un fichier avec move
mv ".\Ananlyser le contenu d'un executable.doc" ".\Analyser executable.doc"
```

```powershell
# Comparer des objects		
Compare-Object -ReferenceObject "blabla" -DifferenceObject "blablabla"
```



## 🔪🥩 Hashage 🔪🥩
```powershell
# Récup hash				
Get-FileHash .\Fichier\

# Récupérer un hash			
Get-FileHash -Algorithm sha512 Chemin\fichier
```




## 📇🔍 Afficher, rechercher, et rechercher un mot ou une expression dans un fichier 📇🔍


### Utiliser Get-Content
```powershell
# Afficher le contenu d'un fichier (Alias: gc) 	 
Get-Content "C:\chemin\nom_fichier"

# Rechercher les 10 dernières lignes 
Get-Content C:\Users\User_name\Desktop\rockyou.txt | Select-Object -Last 10

# Rechercher un dossier
Get-ChildItem -Path C:\ -Directory -Recurse -Force -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "*NomDuDossier*" }
```


### Rechercher les fichiers en fonction de l'extension 
```powershell
Get-ChildItem -Path E:\ -Filter *.md -Recurse
```
- -Filter *.md → cherche les fichiers finissant par `.md`

- -Recurse → descend dans tous les sous-dossiers

### Afficher uniquement le chemin complet
```powershell
Get-ChildItem -Path E:\ -Filter *.md -Recurse | Select-Object -ExpandProperty FullName
```

### Utiliser Select-String 
```powershell
# Rechercher un mot, une expression dans fichier
Select-String -Path "C:\chemin\vers\rockyou.txt" -Pattern "mot_à_rechercher"

# Chercher uniquement les mots commençant par "pass" 
Select-String -Path "C:\chemin\vers\rockyou.txt" -Pattern "^pass"

# Recherche sensible à la casse
Select-String -Path "C:\chemin\vers\rockyou.txt" -Pattern "Password" -CaseSensitive

# Tous les mots contenant "pass" sans afficher le n° de ligne (précédé ou suivit d'un caractère qui ne sera pas une lettre avec regex \b)
Select-String -Path "C:\chemin\vers\rockyou.txt" -Pattern "\bpass\b" | ForEach-Object { $_.Line }
```

### Formats de fichiers que Powershell peut utiliser:
| 📂 Format	| 📜 Supporté nativement ?	| 🔧 Méthode à utiliser |
| ----- | :---: | ----- |
| TXT	|	✅ Oui	| Get-Content ou Select-String |
| CSV	|	✅ Oui |	Import-Csv |
| JSON | ✅ Oui | ConvertFrom-Json |
| XML	|	✅ Oui	|	Select-Xml |
| DOC, DOCX	| ❌ Non	| COM Object ou OpenXML |
| PDF | ❌ Non	|	PDFtoText ou une librairie externe |
| XLS, XLSX | ❌ Non | COM Object ou Import-Excel |




## Générer un mot de passe avec Powershell ou une chaîne de caractère aléatoire
```powershell
Add-Type -AssemblyName System.Web
[System.Web.Security.Membership]::GeneratePassword(16, 4)
```
* 16 : longueur totale du mot de passe.
* 4 : nombre de caractères non alphanumériques (ex : !, @, #, etc.).





## 🛡️ 🧱 Pare-Feu & Defender 🧱 🛡️
### Pare-Feu
```powershell
# règles ICMP IN  			
New-NetFirewallRule -DisplayName "Autoriser ICMPv4-In" -Protocol ICMPv4 -IcmpType 8 -Direction Inbound -Action Allow

# règles ICMP OUT 
New-NetFirewallRule -DisplayName "Autoriser ICMPv4-Out" -Protocol ICMPv4 -IcmpType 8 -Direction Outbound -Action Allow

# Ouvrir port 22 dans pare-feu
New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
```

### Defender
```powershell
# Activer Defender 			
Set-MpPreference -DisableRealtimeMonitoring $false -DisableIntrusionPreventionSystem $false -DisableIOAVProtection $false -DisableScriptScanning $false -EnableControlledFolderAccess Enabled -EnableNetworkProtection Enabled

# Désactiver  Defender			
Set-MpPreference -DisableRealtimeMonitoring $true -DisableBehaviorMonitoring $true -DisableIntrusionPreventionSystem $true -DisableIOAVProtection $true -DisableScriptScanning $true -DisablePrivacyMode $true
```




## 📅 MISES À JOUR 📅 
```powershell
# Installer le module maj
Install-Module PSWindowsUpdate

# Importer le module de maj
Import-Module PSWindowsUpdate

# Installer les mises à jour
Get-WindowsUpdate -AcceptAll -Install -AutoReboot								 	
Install-WindowsUpdate -AcceptAll 
```




## 🔢 WinRM 🔢
```powershell
# Installation de WinRM
Enable-PSRemoting -Force

# Vérifier que WinRM est activé
Get-Service winrm

# Activer la règler de parefeu
Enable-NetFirewallRule -Name "WINRM-HTTP-In-TCP"

# Utilisation de WinRM pour des connexions distante
Enter-PSSession -ComputerName PC01-W10 -Credential nom_domaine\compte_admin

# Ouvrir (en admin) fenêtre GUI pour autoriser un compte en PSRemoting
Set-PSSessionConfiguration -Name Microsoft.PowerShell -ShowSecurityDescriptorUI
```




## 🔐🔢 SSH 🔢🔐
```powershell	
# Vérifier si le service est actif		
Get-Process ssh-agent  
Get-Service ssh-agent

# Installer OpenSSH Server (faire les màj avant) 			
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# Démarrer/redémarrer le service SSH
Start-Service ssh-agent
Restart-Service ssh-agent

# Configurer démarrage auto SSH
Set-Service ssh-agent -StartupType 'Automatic'

# Ouvrir port 22 dans pare-feu
New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22

# Voir sur quel port SSH écoute			
Get-NetTCPConnection | Where-Object {$_.OwningProcess -eq (Get-Process -Name sshd).Id}

# Afficher le port configuré dans sshd_config	
Get-Content "$env:ProgramData\ssh\sshd_config" | Select-String "^Port"

# Afficher la règle, port local et protocole 	
Get-NetFirewallRule -Name *ssh* | Get-NetFirewallPortFilter | Format-Table Name, LocalPort, Protocol

# Créer une clé rsa
ssh-keygen.exe -t rsa -b 4096
```



## 🏠 Installer un contrôleur de domaine 🏠 


### Installer les fonctionnalités
```powershell
# Installer le rôle AD DS
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# Importer le module AD DS
Import-Module ADDSDeployment

# Exemple pour WDS
Install-WindowsFeature -Name WDS -IncludeManagementTools
```

### Promouvoir le serveur en contrôleur de domaine
```powershell
# Ajouter domaine nouvelle forêt
Install-ADDSForest -DomainName "TSSR.INFO" -DomainNetbiosName "TSSR" -SafeModeAdministratorPassword (ConvertTo-SecureString -AsPlainText "Mon_mot_de_passe" -Force) -InstallDNS	

# Joindre le domaine
Add-Computer -DomainName TSSR.INFO

# Retélécharger les modules pour le réplicat 
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# Promouvoir en controleur de domaine
Install-ADDSDomainController -DomainName "TSSR.INFO" -SafeModeAdministratorPassword (ConvertTo-SecureString -AsPlainText "Mon_mot_de_passe" -Force) -InstallDNS

# Promouvoir en controleur de domaine (plus simple):  	
Install-ADDSDomainController -DomainName "domain.tld" -InstallDns:$true -Credential (Get-Credential "DOMAIN\administrateur")

# Joindre domaine Sur machine cliente 
Add-Computer -DomainName "domainname" -Credential (Get-Credential) -Restart

# ⚠️ Ne pas oublier de mettre le nom du domaine avant pour éviter une erreur : "TSSR\administrateur"

# Installer tous les outils RSAT:	
Get-WindowsCapability -Name RSAT* -Online | Add-WindowsCapability -Online
```

	


## 👮 Créer un nouvel utilisateur admin du domaine 👮 
```powershell
# Créer un nouvel utilisateur  		
New-ADUser -Name "Adminname" -GivenName "Admin" -Surname "name" -SamAccountName "Adminname" -UserPrincipalName "Adminnamel@domainname.fr" -AccountPassword (ConvertTo-SecureString "*******" -AsPlainText -Force) -Enabled $true

# Rechercher des groupes : 	
Get-ADGroup -Filter 'Name -like "*admin*"'
Get-ADGroup -Filter 'Name -like "*stratégie*"'

# Ajouter l'utilisateur "admaxel" aux groupes admin 
$groupes = @(
    "Administrateurs",
    "Administrateurs du schéma",
    "Administrateurs de l’entreprise",
    "Admins du domaine",
    "Propriétaires créateurs de la stratégie de groupe"
)

foreach ($groupe in $groupes) {
    Add-ADGroupMember -Identity $groupe -Members "adminname" -ErrorAction SilentlyContinue
}
```
