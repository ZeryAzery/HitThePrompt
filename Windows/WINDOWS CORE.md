# 🪟 Administration en Powershell Core 🪟


Powershell n'a pas de sensiblité à la casse c'est juste visuel

## 🔰 Commandes de base 🔰


### Trouver une commande :
```powershell
Get-Command *hash*
gcm *bitlocker*
```

### Afficher les aides dans une fenêtre :
```powershell	
Get-Help Unlock-BitLocker -ShowWindow
```

### Se déplacer à la racine :
```powershell 			
Set-Location \
```

### Se placer dans le répertoire utilisateur :
```batch	
cd ~  
sl ~
```

### Afficher l’emplacement actuel ('pwd' focntionne aussi) :
```powershell
Get-Location
``` 

### Afficher le contenu de C:\
```powershell 
Get-ChildItem -Path "C:\" #Commandes alternative: gci C:  dir C:  ls C:
```

Sur serveur Core "Ctrl+Alt+Suprr" permet d'ouvrir le gestionnaire des tâches ce qui permet d'ouvrir la fenêtre "executer" pour ouvrir Powershell

### Renommer la machine :
```powershell
Rename-Computer -NewName "SRV-W19-CORE-1" -Restart
```

### Affichera juste le nom de l'ordi:
```powershell	
Get-computerInfo | Select CsName 
```

### Réinitialiser son mot de passe : 	
```batch
net user Administrateur *
```

### Réinitialiser son MDP	sur domaine :	
```batch
net user  /domain administrateur *
```

### DL fichiers d’aide powershell :
```powershell
Update-Help 
```

### Afficher l'aide pour 'Get-Process'
```powershell
Get-Help Get-Process
```

### Arréter un processus  :
```powershell
Stop-Process -Id 2960
```

### Renommer un dossier :
```powershell
Rename-Item -Path "C:\DATAS\DIRECTION" -NewName "D_DIRECTION"
```

### Créer un fichier texte  :
```powershell
New-Item -Path C:\Administrateur\Users\fichiertest -ItemType File
```

### Créer un fichier ou écrase ancien :
```powershell
Set-Content -Path C:\Administrateur\Users\fichiertest -Value "Texte du fichier"
```

### Ajoute texte fichier existant :	
```powershell
Add-Content -Path C:\Administrateur\Users\fichiertest -Value "Ajoute Texte au fichier"
```

### Sur serveur core permet d'ouvrir le menu de config du serveur
```powershell
sconfig
```

### Addon VBox, monter iso puis (Semble inutile sur un serveur core) :
```powershell	
D:\ 	
VBoxWidowsAdditions-amd64.exe 
```

### Redémarrer la machine :
```powershell
Restart-Computer #(ou shutdown /r /t 0)  
```

### Éteindre la machine :
```powershell
Stop-Computer 	 #(ou shutdown /s /t 0)  
```

### Lister un dossier : 			
```powershell
dir 
ls 
gci
```

### Revenir au dossier parent :
```powershell
cd ..
```

### Changer de répertoire :
```powershell
cd
sl
```

### Afficher le contenu d'un fichier:
```powershell	
cat 'nom_fichier' 
cat "C:\chemin\nom_fichier"  
gc "C:\chemin\nom_fichier"
```

### tester l'écoute d'un port :
```powershell 		
Test-NetConnection -ComputerName localhost -Port 389
```

## 🖼️ SYSPREP 🖼️ 


Faire le sysprep avant le clone si besoin de déployer l'image plusieurs fois et choisir arrêter au lieu de redémarrer (pour éviter que la machine reprenne un SID au démarrage)

```powershell
# Emplacement sysprep
cd \windows\system32\sysprep

# Exécuter sysprep
.\sysprep.exe /generalize /reboot
```

## 📶 CONFIG RESEAU 📶 

```powershell
# Afficher les infos réseaux (Alias: gip)
Get-NetIPConfiguration (eq ipconfig...)

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
# ou 			
Remove-NetIPAddress -IPAddress 192.168.100.1 -Confirm:$false

# Retirer la passerelle			
Remove-NetRoute -InterfaceAlias "Ethernet" -NextHop "192.168.0.254"

# Désactiver carte réseau
Disable-NetAdapter -Name  nom_carte_réseau
# Désactiver/Réactiver
Restart-NetAdapter -Name nom_carte_réseau

# Désactiver l'IPv6
Disable-NetAdapterBindin -InterfaceAlias "ethernet" -ComponentID ms_tcpip6
# Désactiver l'IPv6 partout
Get-NetAdapter | ForEach-Object { Disable-NetAdapterBinding -Name $_.Name -ComponentID ms_tcpip6 }
```

## 📂 Gestion des Objets 📂 

```powershell
# Récup hash				
Get-FileHash .\Fichier\

# Récupérer un hash			
Get-FileHash -Algorithm -sha512 Chemin\fichier

# Créer des dossiers avec mkdir		
mkdir COMPTABILITE, INFORMATIQUE, RH, PRODUCTION 

# Supprimer un fichier/Dossier	
Remove-Item COMPTABILITE, INFORMATIQUE, RH, PRODUCTION

# Son Alias				
ri COMPTABILITE, INFORMATIQUE, RH, PRODUCTION

# Renommer un fichier (Alias: rni)
Rename-Item			

# Renommer un fichier avec move:	
mv ".\Ananlyser le contenu d'un executable.doc" ".\Analyser executable.doc"

# Alias de Move-Item				
mi

# comparer des objects			
Compare-Object -ReferenceObject "fhfufu" -DifferenceObject "fehueh"
```

## 📇🔍 Rechercher un mot ou une expression dans un fichier 📇🔍

```powershell
# Rechercher un mot, une expression dans fichier
Select-String -Path "C:\chemin\vers\rockyou.txt" -Pattern "mot_à_rechercher"

# Chercher uniquement les mots commençant par "pass" 
Select-String -Path "C:\chemin\vers\rockyou.txt" -Pattern "^pass"

# Recherche sensible à la casse
Select-String -Path "C:\chemin\vers\rockyou.txt" -Pattern "Password" -CaseSensitive

# Tous les mots contenant "pass", mais uniquement en entier (contiendra "pass" mais uniquement précédé ou suivit d'un caractère qui ne sera pas une lettre)
Select-String -Path "C:\chemin\vers\rockyou.txt" -Pattern "\bpass\b"

# Ne pas afficher le numéro de ligne:	
Select-String -Path "C:\Users\Axel\Desktop\rockyou.txt" -Pattern "\bpass\b" | ForEach-Object { $_.Line }

# Rechercher les 10 dernières lignes 
Get-Content C:\Users\Axel\Desktop\rockyou.txt | Select-Object -Last 10
```

### Formats de fichiers que Powershell peut utiliser:

| 📂 Format	| 📜 Supporté nativement ?	| 🔧 Méthode à utiliser |
| ----- | ----- | ----- |
| TXT	|	✅ Oui	| Get-Content ou Select-String |
| CSV	|	✅ Oui |	Import-Csv |
| JSON | ✅ Oui | ConvertFrom-Json |
| XML	|	✅ Oui	|	Select-Xml |
| DOC, DOCX	| ❌ Non	| COM Object ou OpenXML |
| PDF | ❌ Non	|	PDFtoText ou une librairie externe |
| XLS, XLSX |	❌ Non | COM Object ou Import-Excel |
		

## 🧱 PARE-FEU 🧱 

```powershell
# règles ICMP IN : 			
New-NetFirewallRule -DisplayName "Autoriser ICMPv4-In" -Protocol ICMPv4 -IcmpType 8 -Direction Inbound -Action Allow

# règles ICMP OUT 
New-NetFirewallRule -DisplayName "Autoriser ICMPv4-Out" -Protocol ICMPv4 -IcmpType 8 -Direction Outbound -Action Allow

# Ouvrir port 22 dans pare-feu
New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22

# Activer Defender: 			
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

## 🔢 SSH 🔢 

```powershell	
# Vérifier si le service est actif		
Get-Process sshd ou Get-Service sshd

# Faire les mises à jours avant installation

# Installer OpenSSH Server: 			
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# Démarrer service SSH
Start-Service sshd

# Configurer démarrage auto SSH
Set-Service -Name sshd -StartupType 'Automatic'

# Ouvrir port 22 dans pare-feu
New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22


# Voir sur quel port SSH écoute			
Get-NetTCPConnection | Where-Object {$_.OwningProcess -eq (Get-Process -Name sshd).Id}

# Afficher le port configuré dans sshd_config	
Get-Content "$env:ProgramData\ssh\sshd_config" | Select-String "^Port"

# Afficher la règle, port local et protocole 	
Get-NetFirewallRule -Name *ssh* | Get-NetFirewallPortFilter | Format-Table Name, LocalPort, Protocol
```



## 🏠 INSTALLER UN CONTROLEUR DE DOMAINE 🏠 


### Installer les fonctionnalités

```powershell
# Installer le rôle AD DS
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# Importer le module AD DS
Import-Module ADDSDeployment
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
Add-Computer -DomainName "example.com" -Credential (New-Object PSCredential ("administrateur@tssr.info", (ConvertTo-SecureString "Mon_mot_de_passe" -AsPlainText -Force))) -Restart

# ou 
Add-Computer -DomainName "votre_nom_de_domaine" -Credential (Get-Credential) -Restart

# ⚠️ Ne pas oublier de mettre le nom du domaine avant pour éviter une erreur : "TSSR\administrateur"

# Installer tous les outils RSAT:	
Get-WindowsCapability -Name RSAT* -Online | Add-WindowsCapability -Online
```

	
## 👮 CREER UN NOUVEL UTILISATEUR ADMIN DU DOMAINE 👮 

```powershell
# Créer un nouvel utilisateur : 		
New-ADUser -Name "admaxel" -GivenName "Adm" -Surname "axel" -SamAccountName "admaxel" -UserPrincipalName "admaxel@tssr-cybe
r.org" -AccountPassword (ConvertTo-SecureString "*******" -AsPlainText -Force) -Enabled $true

# Voir les groupes admin : 	Get-ADGroup -Filter 'Name -like "*admin*"'
Get-ADGroup -Filter 'Name -like "*stratégie*"'

# Ajouter l'utilisateur "admaxel" aux groupes admin  : 
$groupes = @(
    "Administrateurs",
    "Administrateurs du schéma",
    "Administrateurs de l’entreprise",
    "Admins du domaine",
    "Propriétaires créateurs de la stratégie de groupe"
)

foreach ($groupe in $groupes) {
    Add-ADGroupMember -Identity $groupe -Members "admaxel" -ErrorAction SilentlyContinue
}








