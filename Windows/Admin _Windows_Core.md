# 🪟 __ADMINISTRATRION EN POWERSHELL__


* __Powershell n'a pas de sensiblité à la casse c'est juste visuel__

* __Sur serveur Core "Ctrl+Alt+Suprr" permet d'ouvrir le gestionnaire des tâches puis d'avoir la fenêtre "executer".__

<br>

## __Sommaire__

- [🔰 COMMANDES DE BASE](#commandes-de-base)
- [🔑 LICENSING MANAGEMENT TOOL](#licensing-management-tool)
- [🍴 POINT DE RESTAURATION](#point-de-restauration)
- [📶 CONFIGURATION RÉSEAU](#configuration-reseau)
- [📅 MISES À JOUR](#mises-a-jour)
- [🏃‍♀️‍➡️ GESTION DES PROCESSUS](#gestion-des-processus)
- [🌐 GESTION DES PROCESSUS TCP](#gestion-des-processus-tcp)
- [📂 GESTION DES OBJETS](#gestion-des-objets)
- [➡️ SORTIE DE COMMANDE DANS UN FICHIER](#sortie-de-commande-dans-un-fichier)
- [🔪 HASHAGE](#hashage)
- [🔍 RECHERCHER DES FICHIERS ET DOSSIERS](#rechercher-des-fichiers-et-dossiers)
- [📇 RECHERCHER DANS UN FICHIER](#rechercher-dans-un-fichier)
- [🔎 RECHERCHER UN FICHIER ET SON CONTENU](#rechercher-un-fichier-et-son-contenu)
- [💾 SAUVEGARDER ET COPIER](#sauvegarder-et-copier)
- [↔️ SMB](#smb)
- [⬇️ GESTION CONTENU HTTP/HTTPS](#telechargement-http-https)
- [🧱 PARE-FEU](#pare-feu)
- [🛡️ DEFENDER](#️defender)
- [🔢 WINRM](#winrm)
- [🔢 SSH](#ssh)
- [🏠 CONTROLEUR DE DOMAINE](#controleur-de-domaine)
- [🟩 DIVERS](#divers)





---

<br>




<a id="commandes-de-base"></a>

# 🔰 COMMANDES DE BASE
 

### Sur serveur core permet d'ouvrir le menu de config du serveur
```powershell
sconfig
```



### Renommer la machine :
```powershell
Rename-Computer -NewName "SRV-W19-CORE-1" -Restart
```



### Redémarrer directement dans le BIOS/UEFI
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



### Afficher informations BIOS
```powershell
Get-CimInstance -ClassName Win32_BIOS
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


### Aide dans powershell
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

Outils Windows Legacy Get-Help ne fonctionnera pas utiliser /?
```powershell
icacls /?
```

```powershell
man Get-Item
```

### Trouver une commande (Alias: `gcm`):
```powershell
Get-Command *hash*
```




---

<br>




<a id="licensing-management-tool"></a>

# 🔑 __LICENSING MANAGEMENT TOOL__

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




<a id="point-de-restauration"></a>

# 🍴 __POINT DE RESTAURATION__ 


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




<a id="configuration-reseau"></a>

# 📶 __CONFIGURATION RÉSEAU__  


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




<a id="mises-a-jour"></a>

# 📅 __MISES À JOUR__  


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




<a id="gestion-des-processus"></a>

# 🏃‍♀️‍➡️ __GESTION DES PROCESSUS__


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




<a id="gestion-des-processus-tcp"></a>

# 🌐 __GESTION DES PROCESSUS TCP__ 

Microsoft a volontairement séparé le réseau des process, pour avoir le nom des process TCP il faut utiliser `Get-Process` aussi

### Obtenir les process TCP avec le nom du programme
```powershell
Get-NetTCPConnection | 
Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, State, OwningProcess, @{Name="ProcessName";Expression={ (Get-Process -Id $_.OwningProcess).Name }} | 
ft
```


### Vérifier le chemin d'un binaire 
```powershell
(Get-Process -Id <PID>).Path
```

### Exemple pour obtenir l'IPv4 en sortie
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
    Where-Object { $_.State -eq "Established" -and $_.LocalAddress -eq "$ipv4addr" } | 
    ft
```

## NETSTAT

Afficher les connexions réseaux active en rapport avec les programmes
```bat
netstat -nbf 
```

Afficher les connexions réseaux active sur un port
```bat
netstat -nbf | find <port>
```

Afficher les connexions réseaux active établies
```bat
netstat -ano | findstr "ESTABLISHED"
```

Trouver le chemin d'exécution d'un processus avec son Id
```bat
wmic process where processid=13128 get executablepath
```



### Sinon utiliser process explorer et/ou TCP view de la suite Sysinternals 
Afin d'avoir une meilleur vue sur tous les process et d'approfondir en détails :
[Télécharger Sysinternals ici](https://learn.microsoft.com/fr-fr/sysinternals/downloads/)




---

<br>




<a id="gestion-des-objets"></a>

# 📂 __GESTION DES OBJETS__ 

> [!NOTE]
> * La plupart du temps les commande batch fonctionnent en Powershell 
> * Il peut être utile de les connaitre car elles sont souvent plus simple
> * Il arrive que certaines options peuvent ne pas être reconnues par Powershell


###  Création de dossiers avec cmd
```batch
md COMPTABILITE, INFORMATIQUE, RH, PRODUCTION
```


### Supression de dossiers (/s suprimme tout son contenu)
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


### Renommer un fichier avec move
```bat
mv ".\Ananlyser le contenu d'un executable.doc" ".\Analyser executable.doc"
```


### Créer un fichier ou écrase ancien
```powershell
Set-Content -Path C:\Administrateur\Users\fichiertest -Value "Texte du fichier"
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




<a id="sortie-de-commande-dans-un-fichier"></a>

# ➡️ __SORTIE DE COMMANDE DANS UN FICHIER__


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


### Rediriger le résultat d'une commande dans un fichier .csv existant 
```bat
<commande> > C:\Users\admazie\Desktop\User_OfficeE1.csv
```


### Rediriger le résultat d'une commande dans un fichier .csv non existant (Le dossier de destination doit quand même exister)
```powershell
<commande> | Export-Csv -Path  "C:\Users\admintoto\Desktop\lastlogon_active_users.csv" -NoTypeInformation -Encoding UTF8 -Delimiter ';'
```

* `-NoTypeInformation` évite la ligne #TYPE ... en haut du CSV.
* `-Delimiter` ';' permet (dans la version française d'Excel) d'avoir le résultat dans des colonnes 

### Rediriger le résultat d'une commande dans un fichier .csv non existant avec un chemin UNC
```powershell
<commande> | Export-Csv "\\192.168.64.60\C$\Users\toto\OneDrive - NEOPIX STUDIO\Desktop\LastLogonActiveUsers.csv" -NoTypeInformation -Encoding UTF8
```




---

<br>




<a id="hashage"></a>

# 🔪 __HASHAGE__ 


### Récupérer le hash d'un fichier (sha256 par défault)
```powershell				
Get-FileHash .\Fichier\
```



### Choisir l'algorithme
```powershell			
Get-FileHash -Algorithm sha512 Chemin\fichier
```



### Vérifier la différence entre deux hash
```powershell
$h1 = (Get-FileHash 'C:\Users\Toto\Desktop\debian13.iso').hash
$h2 = (Get-FileHash 'C:\Users\Toto\Download\debian13.iso').hash
$h1 -eq $h2
```




---

<br>




<a id="rechercher-des-fichiers-et-dossiers"></a>

# 🔍 __RECHERCHER DES FICHIERS ET DOSSIERS__ 



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
Get-ChildItem -Path E:\ -Filter *.md -Recurse -Force
```

- `-Filter *.md` → cherche les fichiers finissant par `.md`
- `-Recurse` → descend dans tous les sous-dossiers
- `-Force` → fichiers cachés, fichiers système, certains dossiers protégés (ne fera pas apparaître les fichiers corrompues ou illisibles)
- `-ErrorAction` → évite que la recherche s’arrête si un dossier est refusé

<br>

__→  Valeurs courantes de `-ErrorAction`__
| Valeur            | Comportement |
|-------------------|--------------|
| Continue          | Affiche l’erreur et continue (par défaut) |
| SilentlyContinue  | Ignore l’erreur sans rien afficher |
| Stop              | Transforme l’erreur en erreur bloquante |
| Ignore            | Ignore totalement l’erreur (rarement utile) |
| Inquire           | Demande quoi faire à chaque erreur |




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




<a id="rechercher-dans-un-fichier"></a>

# 📇 __RECHERCHER DANS UN FICHIER__

 `Get-Content` et `Select-String`

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

<br>




<a id="rechercher-un-fichier-et-son-contenu"></a>

# 🔎 __RECHERCHER UN FICHIER ET SON CONTENU__



`Get-ChildItem` et `Select-String` combinés

Rechercher une expression dans un fichier 
```powershell
Get-ChildItem -Path "C:\Users\toto" -Recurse -Filter *.txt -ErrorAction SilentlyContinue | Select-String "proxmox"
```
```powershell
Get-ChildItem -Path "C:\Users\toto\" -Recurse -Filter *.txt -ErrorAction SilentlyContinue | Select-String "proxmox" | select Path, Line, LineNumber | fl
```
```powershell
Get-ChildItem -Path "C:\Users\toto\" -Recurse -Filter *.txt -ErrorAction SilentlyContinue | Select-String "proxmox" | select Path, LineNumber | ft
```
Le `-Filter` Windows filtre les fichiers directement au niveau du système, donc plus rapide et plus efficace



Éviter les erreurs de permissions durant la recherche
```powershell
Get-ChildItem C:\ -Recurse -File -Force -ErrorAction SilentlyContinue |
Select-String "cl_resend" -ErrorAction SilentlyContinue |
Select Path, Line, LineNumber |
Format-List
```




---

<br>




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





---

<br>




<a id="sauvegarder-et-copier"></a>

# 💾 __SAUVEGARDER ET COPIER__



### Compress-Archive (zip)
```powershell
$date = Get-Date -Format "Le_dd-MM-yyyy_à_HH'h'mm"; Compress-Archive -Path \\PC-01\E$\RD -DestinationPath "E:\srcipt_save\saveRD_$date.zip" -Force
```


### Copier un fichier
```powershell
Copy-Item .\README.md -Destination 'C:\Users\toto\OneDrive - CYBER MANAGEMENT\Bureau\'
```


### Copier/Télécharger un fichier d'un serveur distant (si partage SMB et droits ok sur utilisateur admtoto )
```powershell
Copy-Item \\192.168.10.125\C$\PARTAGES\Cles_Bitlocker\PC-485\"Clé de récupération BitLocker.txt" -Destination C:\Users\admtoto\Desktop\ -Recurse -Force
```




---

<br>




<a id="smb"></a>

# ↔️ __SMB__



### Afficher les partages SMB
```powershell
Get-SmbShare
```


### Vérifier si la connexion SMB fonctionne (avec utilisateur en cours)
```bat
net use \\192.168.10.125\C$\PARTAGES\Cles_Bitlocker
```
```powershell
Test-Path \\192.168.10.125\C$\PARTAGES\Cles_Bitlocker
```


### Afficher le contenu d'un fichier partagé sur le réseau 
```powershell
gc \\192.168.10.125\C$\PARTAGES\Cles_Bitlocker\PC-485\"Clé de récupération BitLocker.txt"
```


### Partager un répertoire
```powershell
New-SmbShare -Name "Partage_DATAS" -Path "C:\DATAS" -FullAccess "Utilisateurs du domaine" 
```


### Supprimer un partage
```powershell
Remove-SmbShare -Name "Partage_DATAS"
```
```bat
net use \\192.168.10.125\PARTAGES /delete
```

### Voir les droits SMB d’un partage
```powershell
Get-SmbShareAccess -Name PARTAGES
```


### Monter un lecteur réseau 
ne pas mettre `/persistent:yes` si c'est juste temporaire 
```powershell
net use Z: \\192.168.10.125\C$\PARTAGES\Cles_Bitlocker /user:DOMAIN\Administrateur /persistent:yes
```
```powershell
New-PSDrive -Name Z -PSProvider FileSystem -Root \\192.168.10.125\C$\PARTAGES\Cles_Bitlocker -Persist
```

### Supprimmer lecteur réseau
```powershell
net use Z: /delete
```
```powershell
Remove-PSDrive Z
```

### Voir si le chiffrement SMB est activé
```powershell
Get-SmbShare | Select Name, EncryptData
```


### Voir qui est connecté aux partages
```powershell
Get-SmbSession
```


### connexions ouvertes vers les partages
```powershell
Get-SmbConnection
```


Fermer une session SMB
```powershell
Close-SmbSession -SessionId 3
```


Voir les erreurs SMB récentes (logs)
```powershell
Get-WinEvent -LogName Microsoft-Windows-SMBServer/Operational -MaxEvents 30
```

---

<br>







# ⬇️ __GESTION CONTENU HTTP/HTTPS__ <a id="telechargement-http-https"></a>



### Télécharger un fichier (Invoke-WebRequest)
```powershell
iwr https://example.com/hosts.txt -OutFile C:\Temp\hosts.txt -SkipCertificateCheck
```
`-SkipCertificateCheck` → Utile pour les certificats auto-signés (eq -k curl)



### Afficher sans télécharger (Invoke-RestMethod)
```powershell
irm https://get.activated.win
```

### Télécharger avec Invoke-RestMethod
irm est surtout utile pour API / JSON, pas pour de gros fichiers.
```powershell
irm https://example.com/hosts.txt -OutFile C:\Temp\hosts.txt
```


### Télécharger avec BitsTransfer
* BITS = Background Intelligent Transfer Service 
* Reprise automatique si le transfert est interrompu et reprend là où il s’est arrêté.
* Pratique pour gros fichiers ou connexions instables.

```powershell
Start-BitsTransfer -Source https://cdimage.kali.org/kali-2025.4/kali-linux-2025.4-installer-amd64.iso -Destination "F:\Users\Toto\Documents\Images ISO\Linux\"
```

Télécharger plusiseurs fichiers
```powershell
Start-BitsTransfer -Source "https://example.com/file1.txt","https://example.com/file2.txt" -Destination "C:\Temp\"
```

Permet aussi de copier des fichiers d'un partage SMB
```powershell
Start-BitsTransfer -Source \\server\share\file.txt -Destination C:\Temp\file.txt
```





---

<br>




<a id="pare-feu"></a>

# 🧱 __PARE-FEU__



### Afficher les règles de pare-feu
```powershell
Get-NetFirewallRule
```


### règles ICMP IN/OUT
```powershell		
New-NetFirewallRule -DisplayName "Autoriser ICMPv4-In" -Protocol ICMPv4 -IcmpType 8 -Direction Inbound -Action Allow
New-NetFirewallRule -DisplayName "Autoriser ICMPv4-Out" -Protocol ICMPv4 -IcmpType 8 -Direction Outbound -Action Allow
```


### Ouvrir port 22 dans pare-feu
```powershell
New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
```




---

<br>




<a id="defender"></a>

# 🛡️ __DEFENDER__ 



### Activer Defender
```powershell 			
Set-MpPreference -DisableRealtimeMonitoring $false -DisableIntrusionPreventionSystem $false -DisableIOAVProtection $false -DisableScriptScanning $false -EnableControlledFolderAccess Enabled -EnableNetworkProtection Enabled
```


### Désactiver  Defender	
```powershell		
Set-MpPreference -DisableRealtimeMonitoring $true -DisableBehaviorMonitoring $true -DisableIntrusionPreventionSystem $true -DisableIOAVProtection $true -DisableScriptScanning $true -DisablePrivacyMode $true
```




---

<br>




<a id="winrm"></a>

# 🔢 __WINRM__ 

* Compte admin
* Ports 5985 / 5986 autorisés
* Pare-feu Windows autorisé pour WinRM



### Activer la règler de parefeu
```powershell
Enable-NetFirewallRule -Name "WINRM-HTTP-In-TCP"
```


### Installer puis vérifier que WinRM est actif
```powershell
Enable-PSRemoting -Force
Get-Service winrm
```


### tester psremoting sur une machine
```powershell
Test-WsMan LENTBK14-1822
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




<a id="ssh"></a>

# 🔢 __SSH__ 

	
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




<a id="controleur-de-domaine"></a>

# 🏠 __CONTROLEUR DE DOMAINE__  


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

	


### 👮 Créer un nouvel utilisateur admin du domaine  

```powershell
# Créer un nouvel utilisateur  		
New-ADUser -Name "Adminname" -GivenName "Admin" -Surname "name" -SamAccountName "Adminname" -UserPrincipalName "Adminname@domainname.fr" -AccountPassword (ConvertTo-SecureString "*******" -AsPlainText -Force) -Enabled $true

# Rechercher des groupes : 	
Get-ADGroup -Filter 'Name -like "*admin*"'
Get-ADGroup -Filter 'Name -like "*stratégie*"'

# Ajouter l'utilisateur "admtoto" aux groupes admin 
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
# ou
Get-ADUser -Identity NomUser | Select-Object DistinguishedName
```


### Dernière authentification d'un PC ou utilisateur
```powershell
Get-ADComputer -Identity LENTBK15-2336 -Properties LastLogonDate
```
```powershell
Get-ADUser -Identity R.PETIT -Properties LastLogonDate
```


### Renommer un PC du domaine  
Fonctionne depuis n'importe quelle machine du domaine...
```powershell
Rename-Computer -ComputerName "DESKTOP-SQ5RDA2" -NewName "LENV15-2130" -DomainCredential (Get-Credential) -Restart
```


### Vérifier la relation DC & FSMO
```bat
Netdom query fsmo
``` 

### Basculer les rôles FSMO 
```powershell
Move-ADDirectoryServerOperationMasterRole -Identity <SRV-Name> OperationMasterRole 0,1,2,3,4
```
- 0 : Schema Master 
- 1 : Domain Naming Master 
- 2 : RID Master 
- 3 : PDC Emulator 
- 4 : Infrastructure Master 




---

<br>




<a id="divers"></a>

# 🟩 DIVERS


### Vérouiller l'écran d'une session
```powershell
rundll32.exe user32.dll,LockWorkStation; exit
```


<br>


### Ouvrir un nouveau terminal pour exécuter "en tant que"
```bat
runas /user:DOMAINE\MonCompteAD "cmd.exe"
```


<br>


### Vérifier le niveau des privilèges de l'utilisateur en cours
```bat
whoami /all
```


<br>


## Générer un mot de passe avec Powershell ou une chaîne de caractère aléatoire

```powershell
Add-Type -AssemblyName System.Web
[System.Web.Security.Membership]::GeneratePassword(16, 4)
```
* `16` : longueur totale du mot de passe.
* `4` : nombre de caractères non alphanumériques (ex : !, @, #, etc.).
