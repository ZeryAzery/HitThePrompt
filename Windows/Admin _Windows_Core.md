# 🪟 Administration en Powershell Core 🪟


* Powershell n'a pas de sensiblité à la casse c'est juste visuel

* Sur serveur Core "Ctrl+Alt+Suprr" permet d'ouvrir le gestionnaire des tâches puis d'avoir la fenêtre "executer".

## 🔰 Commandes de base 🔰


### Sur serveur core permet d'ouvrir le menu de config du serveur
```powershell
sconfig
```

#### Trouver une commande (Alias: `gcm`):
```powershell
Get-Command *hash*
```


### Allonger la période d'essai Windows
```powershell
slmgr.vbs -rearm
```


### Renommer la machine :
```powershell
Rename-Computer -NewName "SRV-W19-CORE-1" -Restart
```


### Afficher domaine, manufacturer, model, nom machine, utilisateur, mémoire physique
```powershell
Get-WmiObject Win32_ComputerSystem
# ou
Get-CimInstance Win32_ComputerSystem | fl
```


### Afficher les infos de la machine
```powershell
Get-computerInfo 
```	


### Affichera juste le nom de la machine
```powershell
Get-computerInfo | Select CsName
# ou
hostname
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


### Ajouter du texte à un fichier existant
```powershell
Add-Content -Path C:\Administrateur\Users\fichiertest -Value "Ajoute Texte au fichier"
```


### Addon VBox, monter iso puis (Semble inutile sur un serveur core) :	
```powershell
Set-Location D:\ 	
VBoxWidowsAdditions-amd64.exe 
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





---
---





# 🍴 Point de restauration 🍴

### Autoriser un point de restauration à 0 minute (au lieu de 24h de base et où `-Value 0` = 0 minutes)
```powershell
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" -Name "SystemRestorePointCreationFrequency" -Value 0 -PropertyType DWord -Force
```


### Création d'un point de restauration
```powershell
Enable-ComputerRestore -Drive "C:\"
Checkpoint-Computer -Description "Avant Debloat" -RestorePointType "MODIFY_SETTINGS"
```




---
---





# 📶 Configurer le réseau 📶 


### Information réseau détaillée
```powershell
gip -Detailed
```


### Afficher les cartes réseau
```powershell
Get-NetAdapter
```


### Afficher le GUID de la carte réseau
```powershell
Get-NetAdapter | Select Name, InterfaceDescription, InterfaceGuid
```


### Afficher les cartes réseau up:
```powershell
Get-NetAdapter | Where-Object { $_.Status -eq "Up" }
```


### Afficher n° carte réseau
```powershell
Get-NetIPInterface 
```


### Afficher ipv4 et interfaces	
```powershell	
Get-NetIPAddress -AddressFamily IPv4 | select IPAddress, InterfaceAlias	
```


### IP statique et Gateway: 		
```powershell
New-NetIPaddress -InterfaceIndex 4 -IPAddress 192.0.100.1 -PrefixLength 24 -DefaultGateway 10.0.0.254 (ou 4 est le num de la carte réseau)
```


### Configurer le DNS
```powershell
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses ("8.8.8.8","8.8.4.4")
```


### Supprimer une adresse DNS 
```powershell
Get-DnsClientServerAddress -InterfaceIndex 6 | Set-DnsClientServerAddress -ResetServerAddresses
```


### Vérifier l’accès au réseau
```powershell
Test-Connection -ComputerName google.com
```


### Retirer une adresse IP
```powershell
Remove-NetIPAddress -InterfaceIndex 4 -IPAddress 192.168.0.2 -PrefixLengh 24
```


### Retirer une adresse IP
```powershell
Remove-NetIPAddress -IPAddress 192.168.100.1 -Confirm:$false
```


### Retirer la passerelle			
```powershell
Remove-NetRoute -InterfaceAlias "Ethernet" -NextHop "192.168.0.254"
```


### Désactiver carte réseau
```powershell
Disable-NetAdapter -Name  nom_carte_réseau
```


### Désactiver/Réactiver une carte réseau
```powershell
Restart-NetAdapter -Name nom_carte_réseau
```


### Désactiver l'IPv6
```powershell
Disable-NetAdapterBindin -InterfaceAlias "ethernet" -ComponentID ms_tcpip6
```


### Désactiver l'IPv6 partout
```powershell
Get-NetAdapter | ForEach-Object { Disable-NetAdapterBinding -Name $_.Name -ComponentID ms_tcpip6 }
```




---
---





# 📅 MISES À JOUR 📅 


###  Installer le module maj
```powershell
Install-Module PSWindowsUpdate
```


### Importer le module de maj
```powershell
Import-Module PSWindowsUpdate
```


### Installer les mises à jour
```powershell
Get-WindowsUpdate -AcceptAll -Install -AutoReboot								 	
Install-WindowsUpdate -AcceptAll 
```


### Vérifier les mises à jours présentes

```powershell
$kbs= @("KB5066835", "KB5065789")

  foreach ($kb in $kbs) { 
  $hotfix = (Get-HotFix).hotfixid

    if ($hotfix -contains $kb) {
      Write-Host  "Found : $kb" -ForegroundColor Green }
    else { Write-Host  "Not found : $kb" -ForegroundColor Red }
     }
```


### Désinstaller une mise à jour problématique
```powershell
wusa /uninstall /kb:5066835
```

### Désinstaller un package et vérifier les résidus
```powershell
Uninstall-WindowsFeature -Name WDS
Get-WindowsFeature | Where-Object {$_.Name -like 'WDS*'}
Uninstall-WindowsFeature -Name WDS-AdminPack
```





---
---





# 📂 Gestion des Objets 📂 

> [!NOTE]
> * La plupart du temps les commande batch fonctionnent en Powershell, il peut être utile de les connaitre car elles sont souvent plus simple
> * Cependant il arrive que certaines options peuvent ne pas être reconnues par le terminal Powershell

###  Création de dossiers avec cmd
```batch
md COMPTABILITE, INFORMATIQUE, RH, PRODUCTION
```


### supression de dossiers avec cmd (/s suprimme tout son contenu)
```bat
rd /s	
```
* `/q` Mode silencieux, pas de confirmation demandée

```bat
rmdir /s /q "C:\Users\ccarpentier"
```



### Créer un fichier texte en batch dans powershell
```batch
echo null > .\Compta\toto.txt
```


### Insérer du texte en créant un fichier 
```batch
echo "salut je créé un fichier avec ça écrit dedans" > .\Compta\toto.txt
```


### Rajouter du texte dans un fichier existant 
```batch
echo "salut ligne 2" >> .\Compta\toto.txt
```


### Renommer un fichier avec move
```batch
mv ".\Ananlyser le contenu d'un executable.doc" ".\Analyser executable.doc"
```


### Créer un fichier texte  :
```powershell
New-Item -Path C:\Administrateur\Users\fichiertest -ItemType File
```


### Renommer un dossier :
```powershell
Rename-Item -Path "C:\DATAS\DIRECTION" -NewName "D_DIRECTION"
```


### Supprimer un fichier/Dossier (Alias: `ri` ⚠️ pas confondre avec Rename-Item...)
```powershell	
Remove-Item COMPTABILITE, INFORMATIQUE, RH, PRODUCTION
```



### Comparer des objects
```powershell
Compare-Object -ReferenceObject "blabla" -DifferenceObject "blablabla"
```



---
---




# 🔪🥩 Hashage 🔪🥩


### Récupérer le hash d'un fichier (sha256 par défault)
```powershell				
Get-FileHash .\Fichier\
```


### Choisir l'algorithme
```powershel			
Get-FileHash -Algorithm sha512 Chemin\fichier
```




---
---




# 🔍 Rechercher un fichier ou un dossier  🔍


* Utiliser `Get-ChildItem`

### Rechercher un fichier
```powershell
Get-ChildItem -Path "F:\Users\Toto\Desktop\Compta-2024" -Directory -Recurse -Force | Where-Object { $_.Name -like "*NomDuFichier*" }
```


### Rechercher un dossier
```powershell
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




---
---






# 📇 Affichage/recherche du contenu d'un fichier 📇

* Utiliser `Get-Content` et `Select-String` 

### Afficher le contenu d'un fichier (Alias: gc) 	
```powershell
Get-Content "C:\chemin\nom_fichier"
```

### Rechercher les 10 dernières lignes d'un fichier
```powershell
Get-Content C:\Users\User_name\Desktop\rockyou.txt | Select-Object -Last 10
```


### Rechercher un mot, une expression dans fichier
```powershell
Select-String -Path "C:\chemin\vers\rockyou.txt" -Pattern "mot_à_rechercher"
```


### Chercher uniquement les mots commençant par "pass" 
```powershell
Select-String -Path "C:\chemin\vers\rockyou.txt" -Pattern "^pass"
```


### Recherche sensible à la casse
```powershell
Select-String -Path "C:\chemin\vers\rockyou.txt" -Pattern "Password" -CaseSensitive
```

### Tous les mots contenant "pass" sans afficher le n° de ligne (précédé ou suivit d'un caractère qui ne sera pas une lettre avec regex \b)
```powershell
Select-String -Path "C:\chemin\vers\rockyou.txt" -Pattern "\bpass\b" | ForEach-Object { $_.Line }
```



---




## Formats de fichiers que Powershell peut utiliser:

| 📂 Format	| 📜 Supporté nativement ?	| 🔧 Méthode à utiliser |
| ----- | :---: | ----- |
| TXT	|	✅ Oui	| Get-Content ou Select-String |
| CSV	|	✅ Oui |	Import-Csv |
| JSON | ✅ Oui | ConvertFrom-Json |
| XML	|	✅ Oui	|	Select-Xml |
| DOC, DOCX	| ❌ Non	| COM Object ou OpenXML |
| PDF | ❌ Non	|	PDFtoText ou une librairie externe |
| XLS, XLSX | ❌ Non | COM Object ou Import-Excel |




---



## Générer un mot de passe avec Powershell ou une chaîne de caractère aléatoire

```powershell
Add-Type -AssemblyName System.Web
[System.Web.Security.Membership]::GeneratePassword(16, 4)
```
* 16 : longueur totale du mot de passe.
* 4 : nombre de caractères non alphanumériques (ex : !, @, #, etc.).




---
---




# 🛡️ 🧱 Pare-Feu & Defender 🧱 🛡️


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




---
---




# 🔢 WinRM 🔢



### Installation de WinRM
```powershell
Enable-PSRemoting -Force
```


### Vérifier que WinRM est activé
```powershell
Get-Service winrm
```


### tester psremoting sur une machine
```powershell
Test-WsMan LENTBK14-1822
```


### Activer la règler de parefeu
```powershell
Enable-NetFirewallRule -Name "WINRM-HTTP-In-TCP"
```


### Utilisation de WinRM pour des connexions distante
```powershell
Enter-PSSession -ComputerName PC01-W10 -Credential nom_domaine\compte_admin
```


### Ouvrir (en admin) fenêtre GUI pour autoriser un compte en PSRemoting
```powershell
Set-PSSessionConfiguration -Name Microsoft.PowerShell -ShowSecurityDescriptorUI
```



---
---




# 🔐🔢 SSH 🔢🔐

	
### Vérifier si le service est actif
```powershell		
Get-Process ssh-agent  
Get-Service ssh-agent
```


### Installer OpenSSH Server (faire les màj avant) 			
```powershell
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
```


### Démarrer/redémarrer le service SSH
```powershell
Start-Service ssh-agent
Restart-Service ssh-agent
```


### Configurer démarrage auto SSH
```powershell
Set-Service ssh-agent -StartupType 'Automatic'
```


### Ouvrir port 22 dans pare-feu
```powershell
New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
```


### Voir sur quel port SSH écoute			
```powershell
Get-NetTCPConnection | Where-Object {$_.OwningProcess -eq (Get-Process -Name sshd).Id}
```


### Afficher le port configuré dans sshd_config	
```powershell
Get-Content "$env:ProgramData\ssh\sshd_config" | Select-String "^Port"
```


### Afficher la règle, port local et protocole 	
```powershell
Get-NetFirewallRule -Name *ssh* | Get-NetFirewallPortFilter | Format-Table Name, LocalPort, Protocol
```


### Créer une clé rsa
```powershell
ssh-keygen.exe -t rsa -b 4096
```




---
---




# 🏠 Installer un contrôleur de domaine 🏠 


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
# ou
Add-Computer -DomainName "domainname" -Credential (Get-Credential) -Restart

# Promouvoir en controleur de domaine
Install-ADDSDomainController -DomainName "TSSR.INFO" -SafeModeAdministratorPassword (ConvertTo-SecureString -AsPlainText "Mon_mot_de_passe" -Force) -InstallDNS
# ou 
Install-ADDSDomainController -DomainName "domain.tld" -InstallDns:$true -Credential (Get-Credential "DOMAIN\administrateur")

# Installer tous les outils RSAT:	
Get-WindowsCapability -Name RSAT* -Online | Add-WindowsCapability -Online
```

	


### 👮 Créer un nouvel utilisateur admin du domaine 👮 

```powershell
# Créer un nouvel utilisateur  		
New-ADUser -Name "Adminname" -GivenName "Admin" -Surname "name" -SamAccountName "Adminname" -UserPrincipalName "Adminname@domainname.fr" -AccountPassword (ConvertTo-SecureString "*******" -AsPlainText -Force) -Enabled $true

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


### Afficher le chemin LDAP d'un utilisateur
```powershell
(Get-ADUser -Identity aziegler).DistinguishedName
```
#ou
```powershell
Get-ADUser -Identity NomUser | Select-Object DistinguishedName
```


### Vérifier dernière authentification d'un PC
```powershell
Get-ADComputer -Identity LENTBK15-2336 -Properties LastLogonDate
```



### Vérifier dernière authentification d'un utilisateur
```powershell
Get-ADUser -Identity R.PETIT -Properties LastLogonDate
```



### Renommer un PC du domaine avec un compte admin (depuis n'importe quelle machine du domaine...)
```powershell
Rename-Computer -ComputerName "DESKTOP-SQ5RDA2" -NewName "LENV15-2130" -DomainCredential (Get-Credential) -Restart
```

