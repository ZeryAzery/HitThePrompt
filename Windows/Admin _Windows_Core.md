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



### Renommer la machine :
```powershell
Rename-Computer -NewName "SRV-W19-CORE-1" -Restart
```



### redémarrer directement dans le BIOS/UEFI
```bat
shutdown /r /fw /t 0
```
⚠️ Fonctionne si PC est en UEFI (pas BIOS legacy) et si le firmware le supporte.



### Afficher domaine, manufacturer, model, nom machine, utilisateur, mémoire physique
```powershell
Get-WmiObject Win32_ComputerSystem
```
```powershell
Get-CimInstance Win32_ComputerSystem | fl
```


### Afficher les infos de la machine
```powershell
Get-computerInfo 
```	


### Affichera juste le nom de la machine
```powershell
Get-computerInfo | Select CsName
```
```bat
hostname
```	


### Réinitialiser son mot de passe
```bat
net user Administrateur *
net user  /domain administrateur *
```



### Addon VBox, monter iso puis (Semble inutile sur un serveur core) :	
```powershell
Set-Location D:\ 	
VBoxWidowsAdditions-amd64.exe 
```



### Élément graphique sur serveur core 2025
```powershell
Add-WindowsCapability -Online -Name ServerCore.AppCompatibility
virtmgmt.msc
```


### Se servir de l'aide dans powershell
Télécharger les fichiers d'aide
```powershell
Update-Help 
```

Afficher l'aide pour `Get-Process`
```powershell
Get-Help Get-Process
```

Afficher les aides dans une fenêtre :
```powershell
Get-Help Unlock-BitLocker -ShowWindow
```


## Windows Software Licensing Management Tool

| Commande                | ...                                                      |
|-------------------------|---------------------------------------------------------------|
| `slmgr.vbs -rearm`      | Allonger la période d'essai Windows                           |
| `slmgr /xpr`            | Affiche si Windows est activé de façon permanente ou non      |
| `slmgr /ipk <clé>`      | Installe une clé de produit Windows                           |
| `slmgr /ato`            | Active Windows avec la clé installée                          |
| `slmgr /dlv`            | Affiche les détails de licence et d'activation                |
| `slmgr /dli`            | Affiche un résumé de l'état de la licence                     |
| `slmgr /upk`            | Supprime la clé de produit actuelle                           |



---



<br>



# 🍴 Point de restauration 🍴

__Autoriser un point de restauration à 0 minute (au lieu de 24h de base et où `-Value 0` = 0 minutes)__
```powershell
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" -Name "SystemRestorePointCreationFrequency" -Value 0 -PropertyType DWord -Force
```


__Création d'un point de restauration__
```powershell
Enable-ComputerRestore -Drive "C:\"
Checkpoint-Computer -Description "Avant Debloat" -RestorePointType "MODIFY_SETTINGS"
```



---



<br>



# 📶 Configurer le réseau 📶 


### Information réseau détaillée
```powershell
Get-NetIPConfiguration
gip -Detailed
```


### Choix de la carte réseau pour un ping (où IP source = carte réseau souhaitée)
```powershell
Test-Connection -ComputerName 192.168.51.253 -Source 192.168.51.245
```
version bat 
```bat
ping -S 192.168.51.245 192.168.51.253
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


### Tester l'écoute d'un port
```powershell		
Test-NetConnection -ComputerName localhost -Port 389
```



---



<br>



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



<br>



# 🟢🏃‍♀️‍➡️ Gestion des processus 🟢🏃‍♀️‍➡️


### Afficher les processus en cours 
```powershell
Get-Process
```


### Chercher avec wildcard
```powershell
Get-Process *green*
```


### Afficher les modules d'un processus
```powershell
(Get-Process -name Greenshot).Modules
```


### stopper un processus
```powershell
Get-Process | Where-Object { $_.Name -like '*Greenshot*' } | Stop-Process

Get-Process GreenShot | Stop-Process -Confirm

Get-Process GreenShot | Stop-Process -Force
```

### Arréter un processus avec son Id
```powershell
Stop-Process -Id 2960
```



---



<br>



# 🏃‍♀️‍➡️🌐 Gestion des processus TCP 🏃‍♀️‍➡️🌐

Microsoft a volontairement séparé le réseau des process, pour avoir le nom des process TCP il faut utiliser `Get-Process` aussi

### Obtenir les process TCP avec le nom du programme
```powershell
Get-NetTCPConnection | Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, State, OwningProcess, @{Name="ProcessName";Expression={ (Get-Process -Id $_.OwningProcess).Name }} | ft
```


Exemple pour obtenir l'IPv4 en sortie
```powershell
Get-NetIPAddress -AddressFamily IPv4 |
? { $_.IPAddress -like "192.168*" } |
Select -ExpandProperty IPAddress
```


### Sortie des process TCP "Established" sur l'IPv4 de "Ethernet 4"
```powershell
$ipv4addr = Get-NetIPAddress -AddressFamily IPv4 | ? { $_.InterfaceAlias -eq "Ethernet 4" } | Select -ExpandProperty IPAddress

Get-NetTCPConnection | 
    Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, State, OwningProcess, @{Name="ProcessName";Expression={ (Get-Process -Id $_.OwningProcess).Name }} | 
    Where-Object { $_.State -eq "Established" -and $_.LocalAddress -eq "$ipv4addr" } | ft

```


Sinon utiliser process explorer...

---



<br>



# 📇 📂 Gestion des Objets 📂 📇

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
`/q` Mode silencieux, pas de confirmation demandée

```bat
rmdir /s /q "C:\Users\ccarpentier"
```



### Créer un fichier texte en batch dans powershell
```bat
echo null > .\Compta\toto.txt
```



### Créer un fichier ou écrase ancien
```powershell
Set-Content -Path C:\Administrateur\Users\fichiertest -Value "Texte du fichier"
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


### Créer un lien entre deux fichiers ou dossiers (cmd)
```bat
mklink /J "C:\Users\jsimeoni\OneDrive - ABEJ SOLIDARITE\Bureau\USB" "E:\"
```
* Cré un dossier 'USB' sur le bureau et ne sera accessible que si 'E:\' est joignable
* mklink va créer le dossier "USB" mais la destination doit déjà exister



---



<br>



# ➡️📇 Sortie d'une commande dans un fichier .txt/.csv ➡️📇


### Insérer du texte en créant un fichier 
```batch
echo "salut je créé un fichier avec ça écrit dedans" > .\Compta\toto.txt
```


### Rajouter du texte dans un fichier existant 
```batch
echo "salut ligne 2" >> .\Compta\toto.txt
```


### Ajouter du texte à un fichier existant
```powershell
Add-Content -Path C:\Administrateur\Users\fichiertest -Value "Ajoute Texte au fichier"
```


### rediriger le résultat d'une commande dans un fichier .csv existant 
```bat
[<commande>] > C:\Users\admazie\Desktop\User_OfficeE1.csv
```


### Rediriger le résultat d'une commande dans un fichier .csv non existant (Le dossier de destination doit quand même exister)
```powershell
[<commande>] | Export-Csv -Path  "C:\Users\admintoto\Desktop\lastlogon_active_users.csv" -NoTypeInformation -Encoding UTF8 -Delimiter ';'
```

* `-NoTypeInformation` évite la ligne #TYPE ... en haut du CSV.
* `-Delimiter` ';' permet (dans la version française d'Excel) d'avoir le résultat dans des colonnes 

### Rediriger le résultat d'une commande dans un fichier .csv non existant avec un chemin UNC
```powershell
[<commande>] | Export-Csv "\\192.168.64.60\C$\Users\toto\OneDrive - NEOPIX STUDIO\Desktop\LastLogonActiveUsers.csv" -NoTypeInformation -Encoding UTF8
```



---



<br>



# 🔪🥩 Hashage 🔪🥩


### Récupérer le hash d'un fichier (sha256 par défault)
```powershell				
Get-FileHash .\Fichier\
```



### Choisir l'algorithme
```powershel			
Get-FileHash -Algorithm sha512 Chemin\fichier
```



### Vérifier la différence entre deux hash
```powershel
$h1 = (Get-FileHash 'C:\Users\Toto\Desktop\debian13.iso').hash
$h2 = (Get-FileHash 'C:\Users\Toto\Download\debian13.iso').hash
```
```powershell
$h1 -eq $h2
```



---



<br>



# 🔍 Rechercher des fichiers/dossiers avec `Get-ChildItem` 🔍



### Rechercher un fichier
```powershell
Get-ChildItem -Path "F:\Users\Toto\Desktop\Compta-2024" -File -Recurse -Force | Where-Object { $_.Name -like "*NomDuFichier*" }
```


### Rechercher un dossier
```powershell
Get-ChildItem -Path C:\ -Directory -Recurse -Force -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "*NomDuDossier*" }
```
```powershell
Get-ChildItem -Path F:\Users\toto\ -Directory -Recurse -Force  -Name "*save*"
```


### Rechercher les fichiers en fonction de l'extension 
```powershell
Get-ChildItem -Path E:\ -Filter *.md -Recurse
```

- -Filter *.md → cherche les fichiers finissant par `.md`
- -Recurse → descend dans tous les sous-dossiers



### Chercher sur plusieurs extensions
```powershell
gci C:\Users\ -Recurse -Include *.pst, *.ost -ErrorAction SilentlyContinue
```



### Afficher uniquement le chemin complet
```powershell
Get-ChildItem -Path E:\ -Filter *.md -Recurse | Select-Object -ExpandProperty FullName
```



---



<br>



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




### Utiliser `Get-ChildItem` et `Select-String` pour affinner la recherche

* Rechercher une expression dans un fichier 
```powershell
Get-ChildItem -Path "C:\Users\toto" -Recurse -Filter *.txt | Select-String "proxmox"
# ou plus propre
Get-ChildItem -Path "C:\Users\toto\" -Recurse -Filter *.txt | Select-String "proxmox" | select Path, Line, LineNumber | fl
```
 Le `-Filter` Windows filtre les fichiers directement au niveau du système, donc plus rapide et plus efficace




* Éviter les erreurs de permissions durant la recherche
```powershell
Get-ChildItem C:\ -Recurse -File -Force -ErrorAction SilentlyContinue |
Select-String "cl_resend" -ErrorAction SilentlyContinue |
Select Path, Line, LineNumber |
Format-List
```



---



<br>



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



<br>



## Générer un mot de passe avec Powershell ou une chaîne de caractère aléatoire

```powershell
Add-Type -AssemblyName System.Web
[System.Web.Security.Membership]::GeneratePassword(16, 4)
```
* 16 : longueur totale du mot de passe.
* 4 : nombre de caractères non alphanumériques (ex : !, @, #, etc.).




---



<br>



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



<br>



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



<br>



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


### Choix de l'interface pour SSH (`-b` IP Interface src)
```bat
ssh -b 192.168.51.245 admin@192.168.51.253
```

### Forcer SSH à utiliser SHA1 (n'est plus sécurisé aujourd'hui)
Sur certains vieux endpoint il faut se connecter de cette façon...
```bat
ssh -b 192.168.64.60 -oKexAlgorithms=+diffie-hellman-group14-sha1 admin@192.168.51.254
```


### Créer une clé rsa
```powershell
ssh-keygen.exe -t rsa -b 4096
```



---



<br>



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
(Get-ADUser -Identity j.dupont).DistinguishedName
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



---



<br>



### Ouvrir un nouveau terminal pour exécuter "en tant que"
```bat
runas /user:DOMAINE\MonCompteAD "cmd.exe"
```


### Vérifier le niveau des privilèges de l'utilisateur en cours
```bat
whoami /all
```
