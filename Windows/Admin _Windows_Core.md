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
- [💿 GESTION DES DISQUES](#gestion-des-disques)
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
- [🛡️ DEFENDER](#defender)
- [🔢 WINRM](#winrm)
- [🔢 SSH](#ssh)
- [🏠 CONTROLEUR DE DOMAINE](#controleur-de-domaine)
- [🐈‍⬛ GITHUB](#github)
- [🟩 DIVERS](#divers)





<br>

---

<br>




# 🔰 COMMANDES DE BASE  <a id="commandes-de-base"></a>
 

### Sur serveur core permet d'ouvrir le menu de config du serveur
```powershell
sconfig
```


### Misc basics:
```powershell
# Renommer la machine et redémarrer
Rename-Computer -NewName "SRV-W19-CORE-1" -Restart

# Se déplacer à la racine ou dans le répertoire utilisateur (Alias: `sl` ou `cd`)	:		
Set-Location \
Set-Location ~

# Afficher l’emplacement actuel (Alias: `pwd` ou `gl`) :
Get-Location

# Afficher les infos réseaux (Alias: `gip` ou `ipconfig`)
Get-NetIPConfiguration

# Afficher le contenu de C:\  (alternative: `gci C:`  `dir C:`  `ls C:`)
Get-ChildItem -Path "C:\"  

# Redémarrer la machine (eq: `shutdown /r /t 0`)
Restart-Computer   

# Éteindre la machine (eq: `shutdown /s /t 0`)
Stop-Computer 	  

# Renommer/bouger un fichier (Alias: `rni` et `mi`)
Rename-Item
Move-Item			
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

### Infos motherboard
```bat
wmic baseboard get product,manufacturer,version,serialnumber
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
```bat
icacls /?
```

```powershell
man Get-Item
```

### Trouver une commande (Alias: `gcm`):
```powershell
Get-Command *hash*
```

### Afficher la version de Powershell
```powershell
$PSVersionTable
```

### Installer PowerShell core 7.5.4
```bat
winget install --id Microsoft.PowerShell --source winget
```

<br>

---

<br>




# 🔑 __LICENSING MANAGEMENT TOOL__  <a id="licensing-management-tool"></a>

| Commande                | ...                                                      |
|-------------------------|---------------------------------------------------------------|
| `slmgr.vbs -rearm`      | Allonger la période d'essai Windows                           |
| `slmgr /xpr`            | Affiche si Windows est activé de façon permanente ou non      |
| `slmgr /ipk <clé>`      | Installe une clé de produit Windows                           |
| `slmgr /ato`            | Active Windows avec la clé installée                          |
| `slmgr /dlv`            | Affiche les détails de licence et d'activation                |
| `slmgr /dli`            | Affiche un résumé de l'état de la licence                     |
| `slmgr /upk`            | Supprime la clé de produit actuelle                           |




<br>

---

<br>




# 🍴 __POINT DE RESTAURATION__  <a id="point-de-restauration"></a>


__Autoriser un point de restauration à 0 minute (au lieu de 24h de base et où `-Value 0` = 0 minutes)__
```powershell
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" -Name "SystemRestorePointCreationFrequency" -Value 0 -PropertyType DWord -Force
```


__Création d'un point de restauration__
```powershell
Enable-ComputerRestore -Drive "C:\"
Checkpoint-Computer -Description "Avant Debloat" -RestorePointType "MODIFY_SETTINGS"
```




<br>

---

<br>




# 📶 __CONFIGURATION RÉSEAU__  <a id="configuration-reseau"></a>


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




<br>

---

<br>




# 📅 __MISES À JOUR__   <a id="mises-a-jour"></a>


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

### Afficher les maj présentes
```bat
wmic qfe get Caption,Description,HotFixID,InstalledOn
```


### Vérifier la présence de mises à jours 

```powershell
$kbs= @("KB5066835", "KB5065789")

  foreach ($kb in $kbs) { 
  $hotfix = (Get-HotFix).hotfixid

    if ($hotfix -contains $kb) {
      Write-Host  "Found : $kb" -ForegroundColor Green }
    else { Write-Host  "Not found : $kb" -ForegroundColor Red }
     }
```
```bat
wmic qfe get Caption,Description,HotFixID,InstalledOn | findstr /C:"KB2393802"
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




<br>

---

<br>




# 🏃‍♀️‍➡️ __GESTION DES PROCESSUS__  <a id="gestion-des-processus"></a>


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




<br>

---

<br>





# 🌐 __GESTION DES PROCESSUS TCP__  <a id="gestion-des-processus-tcp"></a>

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





<br>

---

<br>





# 💿 __GESTION DES DISQUES__ <a id="gestion-des-disques"></a>


### Afficher les disques 
Pratique sur domaine pour afficher d'où proviennent les lecteurs réseaux
```powershell
Get-PSDrive -PSProvider FileSystem
```


### Affichier les disques durs
```powershell
Get-Disk
```


### Afficher le BusType
```powershell
Get-Disk | Select-Object Number, BusType, FriendlyName
```


### Afficher toutes les infos dispo sur un disque
```powershell
Get-Disk -Number 0 | Select-Object *
```


### Afficher les infos des disques qui ne sont pas des USB
```powershell
Get-Disk | select Number, FriendlyName, SerialNumber ,Size, PartitionStyle, BusType | ? BusType -ne 'USB' | ft
```


### Afficher le n° de disque qui n'est pas un USB
Peu être utile pour un fichier de démarrage (autounnatend.xml)
```powershell
(Get-Disk | Where-Object BusType -ne 'USB' | Sort-Object Number | Select-Object -First 1).Number
```

<br>

### Gestion des disques avec Diskpart

Diskpart est l'outils de partitionnement des disques de Windows en CLI.

```bat
# Ouvrir diskpart (dans un terminal)
diskpart

# Lister les diques 
lis dis

# Sélectionner un disque
sel dis

# Lister les volumes
lis vol

# Sélectionner un volume
sel vol

# Assigner une à un volume
ass letter D

# créer une partition primaire de 40Go (exprimé en Mo)
crea par prim size=40000
```

Le formatage ne s'effectue pas dans Diskpart
```bat
# Formater un disque au format NTFS 
exit
format G: /FS:ntfs
```






<br>

---

<br>






# 📂 __GESTION DES OBJETS__   <a id="gestion-des-objets"></a>

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


### Créer un fichier texte  (Alias `ni`):
```powershell
New-Item -Path C:\Administrateur\Users\fichiertest -ItemType File
```



### Créer un dossier avec ses fichiers personnalisés
```powershell
md TEST
$fichiers = ("Toto", "Coco", "Momo", "Dodo", "Popo")
$fichiers | % { ni TEST\$_.txt }
```


### Insérer du texte ligne par ligne dans un fichier (Here-String)
```powershell
Set-Content .\Toto.txt @"
Salut Toto !
Ligne 1
Ligne 2
"@
```


### Créer un fichier ou écrase ancien
```powershell
Set-Content -Path C:\Administrateur\Users\fichiertest -Value "Texte du fichier"
```



### Créer un fichier txt
```bat
echo null > .\Compta\toto.txt
```


### Renommer un fichier avec move
```bat
mv ".\Ananlyser le contenu d'un executable.doc" ".\Analyser executable.doc"
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
mklink /J "C:\Users\stoto\OneDrive - CYBER MANAGEMENT\Bureau\USB" "E:\"
```
* Cré un dossier 'USB' sur le bureau et ne sera accessible que si 'E:\' est joignable
* mklink va créer le dossier "USB" mais la destination doit déjà exister




<br>

---

<br>




# ➡️ __SORTIE DE COMMANDE DANS UN FICHIER__  <a id="sortie-de-commande-dans-un-fichier"></a>


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


### Ajouter du texte avec here-string
```powershell
$txtmomo =@"
Salut Momo !
Ligne 1
Ligne 2
"@
$txtmomo | Out-File .\Momo.txt
```


### Ajouter le texte sans écraser
```powershell
$nvtxtmomo | Out-File .\Momo.txt -Append
```
```bat
$nvtxtmomo >> .\Momo.txt
```


### Rediriger le résultat d'une commande dans un fichier .csv existant 
```bat
<commande> > C:\Users\admtoto\Desktop\User_OfficeE1.csv
```


### Rediriger le résultat d'une commande dans un fichier .csv non existant (Le dossier de destination doit quand même exister)
```powershell
<commande> | Export-Csv -Path  "C:\Users\admtoto\Desktop\lastlogon_active_users.csv" -NoTypeInformation -Encoding UTF8 -Delimiter ';'
```

* `-NoTypeInformation` évite la ligne #TYPE ... en haut du CSV.
* `-Delimiter` ';' permet (dans la version française d'Excel) d'avoir le résultat dans des colonnes 

### Rediriger le résultat d'une commande dans un fichier .csv non existant avec un chemin UNC
```powershell
<commande> | Export-Csv "\\192.168.64.60\C$\Users\toto\OneDrive - NEOPIX STUDIO\Desktop\LastLogonActiveUsers.csv" -NoTypeInformation -Encoding UTF8
```




<br>

---

<br>




# 🔪 __HASHAGE__  <a id="hashage"></a>


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




<br>

---

<br>




# 🔍 __RECHERCHER DES FICHIERS ET DOSSIERS__   <a id="rechercher-des-fichiers-et-dossiers"></a>



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




<br>

---

<br>




# 📇 __RECHERCHER DANS UN FICHIER__  <a id="rechercher-dans-un-fichier"></a>

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




<br>

---

<br>




# 🔎 __RECHERCHER UN FICHIER ET SON CONTENU__  <a id="rechercher-un-fichier-et-son-contenu"></a>



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




<br>

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





<br>

---

<br>




# 💾 __SAUVEGARDER ET COPIER__  <a id="sauvegarder-et-copier"></a>



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




<br>

---

<br>




# ↔️ __SMB__  <a id="smb"></a>



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




<br>

---

<br>




# ⬇️ __GESTION CONTENU HTTP/HTTPS__  <a id="telechargement-http-https"></a>



### Télécharger un fichier (Invoke-WebRequest)
```powershell
iwr https://example.com/hosts.txt -OutFile C:\Temp\hosts.txt -SkipCertificateCheck
```
* `-SkipCertificateCheck` → Utile pour les certificats auto-signés (eq -k curl)
* Alias `-OutFile` = `-o`
* Contrairement à curl, -OutFile attend toujours un nom de fichier dans sa sortie.


### Afficher sans télécharger (Invoke-RestMethod)
```powershell
irm https://get.activated.win
```

### Télécharger avec Invoke-RestMethod
irm est surtout utile pour API / JSON, pas pour de gros fichiers.
```powershell
irm https://example.com/hosts.txt -o C:\Temp\hosts.txt
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




<br>

---

<br>




# 🧱 __PARE-FEU__  <a id="pare-feu"></a>



### Disable all Firewall profiles (Requires Admin privileges)
```powershell
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
```
```bat
netsh advfirewall set allprofiles state off
```

### Désactiver la découverte réseau
```bat
netsh advfirewall firewall set rule group="Network Discovery" new enable=No
```

### Activer la découverte réseau
```bat
netsh advfirewall firewall set rule group="Network Discovery" new enable=Yes
```


### Afficher les règles de pare-feu
```powershell
Get-NetFirewallRule
```


### Règles ICMP IN/OUT
```powershell		
New-NetFirewallRule -DisplayName "Autoriser ICMPv4-In" -Protocol ICMPv4 -IcmpType 8 -Direction Inbound -Action Allow
New-NetFirewallRule -DisplayName "Autoriser ICMPv4-Out" -Protocol ICMPv4 -IcmpType 8 -Direction Outbound -Action Allow
```


### Ouvrir port 22 dans pare-feu
```powershell
New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
```




<br>

---

<br>




# 🛡️ __DEFENDER__   <a id="defender"></a>



### Désactiver Defender, ajouter une exclusion pour "C:\Windows\Temp", exclut les extension .exe et .ps1
```powershell		
Set-MpPreference -DisableRealtimeMonitoring $true -DisableBehaviorMonitoring $true -DisableIntrusionPreventionSystem $true -DisableIOAVProtection $true -DisableScriptScanning $true -DisablePrivacyMode $true -DisableBlockAtFirstSeen $true -ExclusionExtension "ps1", "exe";Add-MpPreference -ExclusionPath "C:\Windows\Temp"
```

<br>

| Set-MpPreference | Action |
|---------------------|--------|
| -DisableRealtimeMonitoring $true | Désactive la protection en temps réel |
| -DisableBehaviorMonitoring $true | Désactive la surveillance comportementale |
| -DisableIOAVProtection $true | Désactive l’analyse des fichiers téléchargés ou des pièces jointes |
| -DisableBlockAtFirstSeen $true | Désactive la détection cloud lors de la première apparition |
| -DisableEmailScanning $true | Désactive l’analyse des fichiers .pst et autres formats de messagerie |
| -DisableScriptScanning $true | Désactive l’analyse des scripts lors des scans antimalware |
| -ExclusionExtension "ps1", "exe" | Exclut les fichiers selon leur extension |


<br>

### Make exclusion for a certain folder
```powershell
Add-MpPreference -ExclusionPath "C:\Windows\Temp"
```

### Exclude files by extension
```powershell
Set-MpPreference -ExclusionExtension "ps1", "exe"
```

### Exclure une adresse IP
```powershell
Set-MpPreference -ExclusionIpAddress
```


### Réactiver Defender et retirer les exclusions
```shell
Set-MpPreference `
  -DisableRealtimeMonitoring $false `
  -DisableBehaviorMonitoring $false `
  -DisableIntrusionPreventionSystem $false `
  -DisableIOAVProtection $false `
  -DisableScriptScanning $false `
  -DisablePrivacyMode $false `
  -DisableBlockAtFirstSeen $false

Remove-MpPreference -ExclusionExtension "ps1","exe"
Remove-MpPreference -ExclusionPath "C:\Windows\Temp"
```



### Analyser un dossier précis
```powershell
Start-MpScan -ScanType CustomScan -ScanPath "C:\Users\Toto\Downloads\LePornoDouteuxDeToto.mkv" -verbose
```
→ Si aucune sortie, Defender n'a rien trouvé.


### Menaces détectées
```powershell
Get-MpThreat
```

### Information sur une menace détectée avec `Get-MpThreat`
Le ThreatID reçu dans la commande précédente n'est pas une valeur de Get-WinEvent il faut aller chercher la valeur du ThreatID (ici 246173 ) dans `Message` pour obtenir les infos sur cette détection.
```powershell 
Get-WinEvent -LogName "Microsoft-Windows-Windows Defender/Operational" | ? { $_.Message -match "246173" } | fl
```

### Historique des scans Defender
```powershell
Get-MpThreatDetection
```


### Afficher les 25 derniers Logs
```powershell
Get-WinEvent -LogName "Microsoft-Windows-Windows Defender/Operational" | Select -First 25
```



### Afficher les logs avec le RecordID unique de l'event
```powershell
Get-WinEvent -LogName "Microsoft-Windows-Windows Defender/Operational" |
Where-Object { $_.Id -in 1006,1116,1007,1117,1008,1118,1119,1015,1120,1127 } |
Select-Object TimeCreated, Id, RecordId, Message, LogName
```



### Analyser un event en particulier
```powershell
Get-WinEvent -LogName "Microsoft-Windows-Windows Defender/Operational" | Where-Object { $_.RecordID -eq 8169 } | fl
```


<br>



__Liste non exhaustive d'ID évènements Defender__

| ID événement | Description |
|-------------|-------------|
| 1006 | Programme malveillant détecté |
| 1116 | Programme malveillant détecté |
| 1007 | Action de protection système |
| 1117 | Action de protection système |
| 1008 | Échec de la protection système |
| 1118 | Échec de la protection système |
| 1119 | Échec de la protection système |
| 1015 | Comportement suspect |
| 1120 | Hash malveillant |
| 5007 | Modification de la configuration Defender |
| 1127 | Refus d’un processus non approuvé d’accéder à la mémoire |
| 5001 | Protection en temps réel désactivée |
| 5010 | Analyse de programme malveillant désactivée |
| 5012 | Analyse des virus désactivée |


<br>

Plus d'infos sur les ID des events sur le [site de microsoft ici](https://learn.microsoft.com/fr-fr/defender-endpoint/troubleshoot-microsoft-defender-antivirus)




<br>

---

<br>





# 🔢 __WINRM__  <a id="winrm"></a>

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




<br>

---

<br>




# 🔢 __SSH__   <a id="ssh"></a>

	
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
Une connexion doit déjà être établie...		
```powershell
Get-NetTCPConnection | Where-Object {$_.OwningProcess -eq (Get-Process -Name sshd-agent).Id}
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

### Transférer un fichier via SCP vers une machine Linux

Inutile de préciser le port source et inutile de préciser le port dest si port 22 (SSH actif sur machine Linux évidemment)
```shell
scp C:\Users\Administrateur\Desktop\domusers.txt -P <dest_port> toto@10.0.0.51:/home/toto/Bureau/
```




<br>

---

<br>




# 🏠 __CONTROLEUR DE DOMAINE__    <a id="controleur-de-domaine"></a>


### Installer les fonctionnalités

```powershell
# Synchroniser les DC
repadmin /syncall

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
Install-ADDSForest -DomainName "<domain.tld>" -DomainNetbiosName "<domain>" -SafeModeAdministratorPassword (ConvertTo-SecureString -AsPlainText "<Admin_Pswd>" -Force) -InstallDNS	

# Joindre le domaine
Add-Computer -DomainName CYBER-MANAGEMENT
# ou
Add-Computer -DomainName "<domain.tld>" -Credential (Get-Credential) -Restart

# Promouvoir en controleur de domaine (idem pour le réplicat)
Install-ADDSDomainController -DomainName "<domain.tld>" -InstallDNS -SafeModeAdministratorPassword (ConvertTo-SecureString -AsPlainText "<Admin_Pswd>" -Force) 
# ou 
Install-ADDSDomainController -DomainName "<domain.tld>" -InstallDns -Credential (Get-Credential "<domain.tld\administrateur>")

# Installer tous les outils RSAT:	
Get-WindowsCapability -Name RSAT* -Online | Add-WindowsCapability -Online
```

### Quick replication troubleshooting
```powershell
# Résoudre nom d'hôte
Resolve-DnsName <domain.tld>
nslookup <domain.tld>

# Vérifier la dispo du service AD
nltest /dsgetdc:<domain.tld>

# Tester le port LDAP
Test-NetConnection <hostname> -Port 389
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


### Lister les partages réseaux accessibles
Permet aussi de confirmer la connection au domaine
```bat
net view \\$env:USERDNSDOMAIN
```


### Extraire une liste de tous les sAMAccountName (Login name)
```powershell
Get-ADUser -Filter * | Select-Object -ExpandProperty SamAccountName | Out-File -Encoding UTF8 C:\Users\Administrateur\domusers.txt
```
`Out-File -Encoding UTF8` : éviter les problèmes de caractères ou d’outils qui lisent mal l’ANSI/Unicode



### Informations Password Policy
```powershell
Get-ADDefaultDomainPasswordPolicy
```


### Changer le mot de passe
```powershell
Set-ADAccountPassword EDDIE_ROACH -Reset -NewPassword (ConvertTo-SecureString "NouveauMotDePasse123!" -AsPlainText -Force)
```


### Forcer le changement au prochain login
```powershell
Set-ADUser EDDIE_ROACH -ChangePasswordAtLogon $true
```


### Vérifier quand le pswd à été changé
```powershell
Get-ADUser EDDIE_ROACH -Properties PasswordLastSet | Select PasswordLastSet
```



### Lister les comptes (Ordinateurs et Utilisateurs) qui ne nécéssitent pas de pré-authetification Kerberos
```powershell
Get-ADObject -LDAPFilter "(userAccountControl:1.2.840.113556.1.4.803:=4194304)"
```


### Lister les comptes qui ont la pré-authentication Kerberos désactivée
Commande équivalente à la précédente mais d'une autre façon (juste user ici)
```powershell
Get-ADUser -Filter * -Properties userAccountControl |
Where-Object { $_.userAccountControl -band 0x400000 } |
Select-Object Name, SamAccountName
```

* Le bit `0x400000` = `DONT_REQUIRE_PREAUTH` 
* `-band` vérifie le bit dans userAccountControl


### Synchroniser les DC
```bat
repadmin /syncall
```

<br>

---

<br>




# 🐈‍⬛ GITHUB  <a id="github"></a>


### Installer GitHub
```powershell
winget install --id Git.Git -e
```


### Cloner un dépot
```powershell
git clone https://github.com/ZeryAzery/HitThePrompt.git
```


### Ne **jamais** re-cloner un dépot
```powershell
git pull
```

<br>

* Clone → une seule fois par machine

* Pull → récupérer les modifs

* Commit + Push → synchroniser les modifs

<br>

**Toujours faire `git pull` avant de commencer à coder.**<br>
Si oubli de pull, rien ne sera écrasé mais ce message apparaît pour rappeler le pull manquant : <br>
`! [rejected] main -> main (fetch first)`



Script pour Push les modifications
```powershell
sl "C:\Users\t.petit\OneDrive - CYBER MANAGEMENT\Documents\HitThePrompt"
git add .
git commit -m "$(Get-Date -Format 'dd/MM/yyyy')"
git push
```

Éditer infos du compte GiHub (s'ouvre avec vi)
```powershell
git config --global --edit
```
**Commandes vi :** <br>
`i` → mode insertion <br>
`Esc` → retour en mode normal <br>
`x` → supprimer un caractère <br>
`dd` → supprime une ligne <br>
`:wq` → sauvegarder et quitter


<br>

---

<br>




# 🟩 DIVERS  <a id="divers"></a>


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
```bat
whoami /priv
```

<br>


### Générer un mot de passe avec Powershell ou une chaîne de caractère aléatoire

```powershell
Add-Type -AssemblyName System.Web
[System.Web.Security.Membership]::GeneratePassword(16, 4)
```
* `16` : longueur totale du mot de passe.
* `4` : nombre de caractères non alphanumériques (ex : !, @, #, etc.).




---

<br>




# Réseau WiFi

### Afficher les détails de la carte WiFi
```bat
netsh wlan show interfaces
```


### Afficher les détails driver de la carte WiFi
```bat
netsh wlan show drivers
```


### Afficher password WiFi
```bat
# Afficher les profiles ssid connus de la carte wifi
netsh wlan show profile

# Afficher les détails d'un profil ssid connu
netsh wlan show profile <SSID_Name>

# Afficher le Contenu de la clé d'un SSID
netsh wlan show profile <SSID_Name> key=clear
```


### Afficher tous les SSID détectés par une carte Wi-Fi
```bat
netsh wlan show networks
```
Plus de détails sur les SSID détectés
```bat
netsh wlan show networks mode=bssid
```


### URI de la page Localisation
```
start ms-settings:privacy-location
```
"Services de localisation" et "Permettre aux app d'accéder à la localisation" doivent être activé pour afficher tous les SSID. 

### Service de localisation et service de capteur (géoloc avancée)
Ces services doivent être activés pour faire apparaître les SSID inconnus de la carte WiFi.
```powershell
Get-Service lfsvc, SensorService
Start-Service lfsvc, SensorService
# Set-Service lfsvc -StartupType Automatic
# Set-Service SensorService -StartupType Automatic
```




---

<br>




# VPN




### Exemple VPN L2TP-PSK
```powershell
Add-VpnConnection -Name "VPN-Entreprise" -ServerAddress "<Nom.connexion.com>" -TunnelType L2tp -L2tpPsk "<key_here!>" -AuthenticationMethod Pap, MSChapv2 -EncryptionLevel Optional -Force
```
* `-RememberCredential -Name "VPN-Entreprise"`
* `-DnsSuffix 10.10.10.10` Si besoin préciser adresse IP
* `-EncryptionLevel Required`
* `Pap` needs to be enable with L2TP


### Afficher toutes les connexions VPN présentes :
```powershell
Get-VpnConnection
```


### Afficher une connexion spécifique :
```powershell
Get-VpnConnection -Name "VPN-Entreprise" | fl *
```


### Vérifier si elle est en profil utilisateur ou machine (important si déployée en GPO) :
```powershell
Get-VpnConnection -AllUserConnection
Get-VpnConnection -Name "VPN-Entreprise" -AllUserConnection
```


### Supprimer la connexion VPN (profil utilisateur) :
```powershell
Remove-VpnConnection -Name "VPN-Entreprise" -Force
```


### Supprimer si elle a été créée en mode machine (AllUserConnection) :
```powershell
Remove-VpnConnection -Name "VPN-Entreprise" -AllUserConnection -Force
```
Si la suppression échoue, vérifier d’abord si elle existe en mode utilisateur ou machine avec les commandes ci-dessus.



### Connecter l'utilisateur
```bat
rasdial "VPN-ABJ-TEST" user password
```
ou en pwsh
```powershell
Connect-VpnConnection -Name "VPN-Entreprise"
```




---

<br>




# Générer des clées cryptographiques

### Paire de clées publique et privées
* RSA 2048 bits avec .NET dans le dossier actuel
```bat
$rsa = [System.Security.Cryptography.RSA]::Create(2048)
[IO.File]::WriteAllText("$PWD\private.pem",$rsa.ExportRSAPrivateKeyPem())
[IO.File]::WriteAllText("$PWD\public.pem",$rsa.ExportSubjectPublicKeyInfoPem())
```






---

<br>






# Gestion de l'observateur d'éénements

### Afficher si anciens logs écrasés, maximum size logs (poids) et nombre de logs gardés ()
```powershell
Get-WinEvent -ListLog "Microsoft-Windows-NTLM/Operational"
```

* LogMode = Circular → les anciens événements sont écrasés automatiquement
* MaximumSize ≈ 1 Mo → très petit
* RecordCount ≈ 2000 → garde seulement ~2000 events récents

### Augmenter la taille de stockage des logs
Exemple pour 256 Mo de logs NTLM
```bat
wevtutil sl "Microsoft-Windows-NTLM/Operational" /ms:268435456
```
Exemple pour 1 Go de log 'Sécurité'
```bat
wevtutil sl Security /ms:1073741824
```