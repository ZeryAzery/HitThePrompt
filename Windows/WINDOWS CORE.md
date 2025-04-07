# 🪟 WINDOWS SERVER CORE 🪟


Powershell n'a pas de sensiblité à la casse c'est juste visuel

```powershell
#Trouver une commande:
				gcm *bitlocker*
• Afficher les aides dans une fenêtre		help Unlock-BitLocker -ShowWindow


• Équivalent de cd en PS1: 			Set-Location
• Se déplacer à la racine: 			Set-Location \
• Se placer dans le répertoire utilisateur :	cd ~ ou sl ~
• Afficher l’emplacement actuel:		Get-Location (pwd is working as well...)
• Afficher le contenu de C:\ :			Get-ChildItem -Path "C:\" #Commandes alternative: gci C:  dir C:  ls C:

• Ctrl+Alt+Suprr :			Ouvre le gestionnaire des tâches (permet d'ouvrir la fenêtre "executer" pour ouvrir Powershell..)

• Renommer la machine :	 		Rename-Computer -NewName "SRV-W19-CORE-1" -Restart
• Obtenir une info: 			Get
• Affichera juste le nom de l'ordi:	Get-computerInfo | Select CsName 
• Réinitialiser son mot de passe : 	net user Administrateur *
• Réinitialiser son MDP	sur domaine :	net user  /domain administrateur *


• DL fichiers d’aide powershell :	Update-Help (Exemple : Get-Help Get-Process)
• Arréter un processus :		Stop-Process -Id 2960

• Renommer un dossier :			Rename-Item -Path "C:\DATAS\DIRECTION" -NewName "D_DIRECTION"
• Créer un fichier texte :		New-Item -Path C:\Administrateur\Users\fichiertest -ItemType File
• Créer un fichier ou écrase ancien :	Set-Content -Path C:\Administrateur\Users\fichiertest -Value "Texte du fichier"
• Ajoute texte fichier existant :	Add-Content -Path C:\Administrateur\Users\fichiertest -Value "Ajoute Texte au fichier"

	

• Menu de config du serveur:		sconfig

• Addon VBox, monter iso puis :	D: et 	VBoxWidowsAdditions-amd64.exe (useless ??)
• Redémarrer:				Restart-Computer ou shutdown /r /t 0  
• Éteindre:				Stop-Computer 	 ou shutdown /s /t 0  
• lister un dossier: 			dir ou ls ou gci (Pour Get-ChildItem)
• revenir au dossier parent:		cd ..
• Chnager de répertoire 		cd ou sl (pour Set-Location)

• Afficher le contenu d'un fichier:	cat nom_fichier ou cat C:\chemin\nom_fichier ou gc (pour Get-Content)

• tester l'écoute d'un port 		Test-NetConnection -ComputerName localhost -Port 389


## 🖼️ SYSPREP 🖼️ 


Faire le sysprep avant le clone si besoin de déployer l'image plusieurs fois et choisir arrêter au lieu de redémarrer(pour éviter que la machine reprenne un SID au démarrage)

• cd \windows\system32\sysprep
• .\sysprep.exe /generalize /reboot
 

## 📶 CONFIG RESEAU 📶 



• Afficher les infos réseaux:		Get-NetIPConfiguration (eq ipconfig...)
• Ou mieu son Alias:			gip
• Afficher plus d'infos:		gip -Detailed

• Nom de la carte réseau:		Get-NetAdapter
• Afficher les cartes réseau up:	Get-NetAdapter | Where-Object { $_.Status -eq "Up" }
• Afficher n° carte réseau:		Get-NetIPInterface 
• Afficher ipv4 et interfaces		Get-NetIPAddress -AddressFamily IPv4 | select IPAddress, InterfaceAlias
	
• IP statique et Gateway: 		New-NetIPaddress -InterfaceIndex 4 -IPAddress 192.0.100.1 -PrefixLength 24 -DefaultGateway 10.0.0.254 (ou 4 est le num de la carte réseau)



• Configurer le DNS:			Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses ("8.8.8.8","8.8.4.4")

• Supprimer une adresse DNS :		Get-DnsClientServerAddress -InterfaceIndex 6 | Set-DnsClientServerAddress -ResetServerAddresses

• Vérifier l’accès au réseau:		Test-Connection -ComputerName google.com


• retirer adresse IP:			Remove-NetIPAddress -InterfaceIndex 4 -IPAddress 192.168.0.2 -PrefixLengh 24
	ou mieux			Remove-NetIPAddress -IPAddress 192.168.100.1 -Confirm:$false

• Retirer la passerelle			Remove-NetRoute -InterfaceAlias "Ethernet" -NextHop "192.168.0.254"


• Désactiver carte réseau:		Disable-NetAdapter -Name  nom_carte_réseau
• Désactiver/Réactiver:			Restart-NetAdapter -Name nom_carte_réseau

• Désactiver l'IPv6:			Disable-NetAdapterBindin -InterfaceAlias "ethernet" -ComponentID ms_tcpip6
• Désactiver l'IPv6 partout:		Get-NetAdapter | ForEach-Object { Disable-NetAdapterBinding -Name $_.Name -ComponentID ms_tcpip6 }



## 📂 Gestion des Objets 📂 


• Récup hash				Get-FileHash .\Fichier\
• Récupérer un hash			Get-FileHash -Algorithm -sha512 Chemin\fichier
• Créer des dossiers avec mkdir		mkdir COMPTABILITE, INFORMATIQUE, RH, PRODUCTION 
• New-Item				Je ne veux pas en parler tellement mkdir semble plus simple -_-
• Supprimer un fichier/Dossier		Remove-Item COMPTABILITE, INFORMATIQUE, RH, PRODUCTION
• Son Alias				ri COMPTABILITE, INFORMATIQUE, RH, PRODUCTION

• Renommer un fichier:			Rename-Item
• Son Alias				rni
• Renommer un fichier avec move:	mv '.\Ananlyser  le contenu d''un executable.doc' '.\Analyser executable.doc'
• Alias 				mi
• comparer des objects			Compare-Object -ReferenceObject "fhfufu" -DifferenceObject "fehueh"
•



## 📇🔍 Rechercher un mot ou une expression dans un fichier 📇🔍 ##

• Rechercher un mot, une expression dans fichier:		Select-String -Path "C:\chemin\vers\rockyou.txt" -Pattern "mot_à_rechercher"					 
• Chercher uniquement les mots commençant par "pass" :		Select-String -Path "C:\chemin\vers\rockyou.txt" -Pattern "^pass"					
• Recherche sensible à la casse:				Select-String -Path "C:\chemin\vers\rockyou.txt" -Pattern "Password" -CaseSensitive
• Tous les mots contenant "pass", mais uniquement en entier (contiendra "pass" mais uniquement précédé ou suivit d'un caractère qui ne sera pas une lettre)
								Select-String -Path "C:\chemin\vers\rockyou.txt" -Pattern "\bpass\b"

• Ne pas afficher le numéro de ligne:	Select-String -Path "C:\Users\Axel\Desktop\rockyou.txt" -Pattern "\bpass\b" | ForEach-Object { $_.Line }

• Rechercher les 10 dernières lignes :				Get-Content C:\Users\Axel\Desktop\rockyou.txt | Select-Object -Last 10



Formats de fichiers que Powershell peut utiliser:

📂 Format	📜 Supporté nativement ?	🔧 Méthode à utiliser
TXT		✅ Oui				Get-Content ou Select-String
CSV		✅ Oui				Import-Csv
JSON		✅ Oui				ConvertFrom-Json
XML		✅ Oui				Select-Xml
DOC, DOCX	❌ Non				COM Object ou OpenXML
PDF		❌ Non				PDFtoText ou une librairie externe
XLS, XLSX	❌ Non				COM Object ou Import-Excel
		

## 🧱 PARE-FEU 🧱 


• règles ICMP IN : 			New-NetFirewallRule -DisplayName "Autoriser ICMPv4-In" -Protocol ICMPv4 -IcmpType 8 -Direction Inbound -Action Allow
• règles ICMP OUT :			New-NetFirewallRule -DisplayName "Autoriser ICMPv4-Out" -Protocol ICMPv4 -IcmpType 8 -Direction Outbound -Action Allow

• Ouvrir port 22 dans pare-feu:		New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22


• Activer Defender: 			Set-MpPreference -DisableRealtimeMonitoring $false -DisableIntrusionPreventionSystem $false -DisableIOAVProtection $false -DisableScriptScanning $false -EnableControlledFolderAccess Enabled -EnableNetworkProtection Enabled


• Désactiver  Defender			Set-MpPreference -DisableRealtimeMonitoring $true -DisableBehaviorMonitoring $true -DisableIntrusionPreventionSystem $true -DisableIOAVProtection $true -DisableScriptScanning $true -DisablePrivacyMode $true


	


## 📅 MISES A JOUR 📅 

• Installer le module maj:		Install-Module PSWindowsUpdate
• Importer le module de maj:		Import-Module PSWindowsUpdate
• Installer les mises à jour:		Get-WindowsUpdate -AcceptAll -Install -AutoReboot
					
			 	
Install-WindowsUpdate -AcceptAll 

DISM /Online /Cleanup-Image /RestoreHealth
Test-NetConnection -ComputerName www.microsoft.com -Port 80



## 🔢 SSH 🔢 
	
• Vérifier si le service est actif		Get-Process sshd ou Get-Service sshd
  Faire les mises à jours avant installation
• Installer OpenSSH Server: 			Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
• Démarrer service SSH:				Start-Service sshd
• Configurer démarrage auto SSH:		Set-Service -Name sshd -StartupType 'Automatic'
• Ouvrir port 22 dans pare-feu:			New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22


Créer une règle NAT de redirection (PortForwarding) pfsense sur interface WAN vers le port 22 sur adresse NAT IP du server core pour pouvoir utiliser client ssh depuis machine hôte (attention sur machine hôte pour la page web pfsense mettre https si erreur...) et entrer l'IP de la pâte WAN >> exemple : ssh administrateur@ip_pâte_WAN

• Voir sur quel port SSH écoute			Get-NetTCPConnection | Where-Object {$_.OwningProcess -eq (Get-Process -Name sshd).Id}
• Afficher le port configuré dans sshd_config	Get-Content "$env:ProgramData\ssh\sshd_config" | Select-String "^Port"
• Afficher la règle, port local et protocole 	Get-NetFirewallRule -Name *ssh* | Get-NetFirewallPortFilter | Format-Table Name, LocalPort, Protocol




## 🏠 INSTALLER UN CONTROLEUR DE DOMAINE 🏠 


-Étape 1 : Installer les fonctionnalités

• Installer le rôle AD DS:			Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
• Importer le module AD DS:			Import-Module ADDSDeployment

-Étape 2 : Promouvoir le serveur en contrôleur de domaine

• Ajouter domaine nouvelle forêt:		Install-ADDSForest -DomainName "TSSR.INFO" -DomainNetbiosName "TSSR" -SafeModeAdministratorPassword (ConvertTo-SecureString -AsPlainText "Mon_mot_de_passe" -Force) -InstallDNS	
• Joindre le domaine:				Add-Computer -DomainName TSSR.INFO

• Retélécharger les modules pour le réplicat :	Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

• Promouvoir en controleur de domaine:		Install-ADDSDomainController -DomainName "TSSR.INFO" -SafeModeAdministratorPassword (ConvertTo-SecureString -AsPlainText "Mon_mot_de_passe" -Force) -InstallDNS

Ou mieux et plus simple :

• Promouvoir en controleur de domaine:  : 	Install-ADDSDomainController -DomainName "domain.tld" -InstallDns:$true -Credential (Get-Credential "DOMAIN\administratreur")


> Sur machine cliente
• Joindre domaine:				Add-Computer -DomainName "example.com" -Credential (New-Object PSCredential ("administrateur@tssr.info", (ConvertTo-SecureString "Mon_mot_de_passe" -AsPlainText -Force))) -Restart
	\\	 :				Add-Computer -DomainName "votre_nom_de_domaine" -Credential (Get-Credential) -Restart

/!\  Ne pas oublier de mettre dans le nom d'utilisateur le nom du domaine avant "TSSR\administrateur"...
• Installer tous les outils RSAT:	Get-WindowsCapability -Name RSAT* -Online | Add-WindowsCapability -Online



			


## 👮 CREER UN NOUVEL UTILISATEUR ADMIN DU DOMAINE 👮 


• Créer un nouvel utilisateur : 		New-ADUser -Name "admaxel" -GivenName "Adm" -Surname "axel" -SamAccountName "admaxel" -UserPrincipalName "admaxel@tssr-cybe
r.org" -AccountPassword (ConvertTo-SecureString "*******" -AsPlainText -Force) -Enabled $true

• Voir les groupes admin : 	Get-ADGroup -Filter 'Name -like "*admin*"'
				Get-ADGroup -Filter 'Name -like "*stratégie*"'



• Ajouter l'utilisateur "admaxel" aux groupes admin  : 


	# Liste des groupes auxquels ajouter l'utilisateur
$groupes = @(
    "Administrateurs",
    "Administrateurs du schéma",
    "Administrateurs de l’entreprise",
    "Admins du domaine",
    "Propriétaires créateurs de la stratégie de groupe"
)

# Ajout de l'utilisateur à chaque groupe
foreach ($groupe in $groupes) {
    Add-ADGroupMember -Identity $groupe -Members "admaxel" -ErrorAction SilentlyContinue
}








