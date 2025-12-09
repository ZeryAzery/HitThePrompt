# __UTILISER PSEXEC__



---


<br>


## __À propos de PsExec__

- Mark Russinovich a développé PsExec et de nombreux outils Windows regroupés dans la suite **Microsoft Sysinternals**.
- L'outils se  télécharge sur le site de Microsoft ou depuis le Microsoft Store. 
- C’est un outil d’administration qui permet d’exécuter des commandes, scripts ou programmes à distance sur des machines Windows en environnement AD (ou en WORKGROUP) .
- Lors de l’exécution, PsExec copie un exécutable (`PSEXESVC.exe`) sur la cible via ADMIN$, le lance, puis le supprime après usage.


---


## __Sommaire__

1. [PRÉREQUIS](#prérequis)  
2. [COMMANDES DE BASE](#commandes-de-base)  
3. [GESTION DES LOGICIELS](#gestion-des-logiciels)
   - [Avec Chocolatey](#avec-chocolatey)
   - [Avec WMIC (cmd)](#avec-wmic-cmd) 
4. [POSSIBILITÉS SUPPLÉMENTAIRES](#possibilités-supplémentaires)  
   - [Installer GLPI Agent](#installer-glpi-agent)  
   - [Joindre un PC au domaine](#joindre-un-pc-au-domaine)  
   - [Lancer un script PowerShell](#Lancer-un-script-PowerShell)  
   - [Arguments supplémentaires](#arguments-supplémentaires)  
5. [INTÉRAGIR AVEC UNE SESSION DISTANTE](#intéragir-avec-une-session-distante)
6. [TROUBLESHOOTING](#troubleshooting)



---


<br>



## __PRÉREQUIS__

- PsExec ne fonctionne qu’entre hôtes **Windows**.
- Les ports **TCP 445** (SMB) et **UDP/TCP 135** (RPC Endpoint Mapper) doivent êtres ouverts. (correspond au Partage de fichiers et imprimantes)
- Le partage **ADMIN$** doit être actif.
- Le service **Netlogon** est parfois nécessaire.
- Requière un __compte administrateur sur la machine hôte.__
- Ajouter PsExec au PATH système (Modifier la variable **Path** et y ajouter le dossier où se trouve `PsExec.exe`)



---


<br>



## __COMMANDES DE BASE__


### Exemple avec un fichier 

Créer un fichier `import.txt` (peu importe le nom) avec des IPs ou des noms de machines :

```text
192.168.64.10
192.168.64.11
```

Redémarrer toutes les machines listées __(se placer dans le dossier où se trouve le fichier):__

```cmd
cd "C:\Users\J.PETIT\OneDrive - NEOPIX\Documents"
psexec @import.txt shutdown /r /t 0
```

### Exécuter une commande simple sur une machine

```cmd
psexec \\192.168.64.98 hostname
```

Cibler plusieurs machines :

```cmd
psexec \\192.168.64.98,PC-02 hostname
```

### Obtenir un terminal PowerShell distant

```cmd
psexec \\192.168.64.98 powershell.exe
```

### Exécuter en tant que SYSTEM

```cmd
psexec -s \\192.168.64.98 powershell.exe
```

Cela donne les privilèges maximum sur la machine distante.

### Cibler un compte spécifique __( Permet d'exécuter en tant que)__

```cmd
psexec \\PC-01 hostname -u PC-01\Administrateur -p motdepasse
```

### Combiner plusieurs options (voir après pour l'option `-i`)

```cmd
psexec \\192.168.0.15 -siu Administrateur cmd
```


---


<br>



## __GESTION DES LOGICIELS__

### Avec Chocolatey

[Chocolatey](https://chocolatey.org/) est un gestionnaire de paquets pour Windows.

Depuis PowerShell :

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; `
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
```

Installer un logiciel (ex : Firefox)

```cmd
psexec -s \\192.168.64.98 choco install firefox -y
```

Mettre à jour un logiciel (ex : UltraVNC)

```cmd
psexec -s \\192.168.64.98 choco upgrade ultravnc -y
```

Si un redémarrage est demandé, on peut forcer un reboot à distance :

```cmd
psexec -s \\192.168.64.98 powershell.exe
shutdown /r /f /t 0
```

### Avec WMIC (cmd)

Chocolatey ne gère que les logiciels de sa base. Pour d'autres (ex : Symantec), on peut utiliser `wmic`.

Lister les logiciels installés

```cmd
psexec \\192.168.64.169 wmic product get name
```

Désinstaller un logiciel contenant "Symantec" dans son nom

```cmd
psexec -s \\192.168.64.169 -u PC\Administrateur -p motdepasse ******
wmic product where "name like '%%Symantec%%'" call uninstall /nointeractive
```

💡 Astuce : tester avec ou sans `-s` selon la version de Windows.


---


<br>



## __POSSIBILITÉS SUPPLÉMENTAIRES__

### Installer GLPI Agent

```shell
psexec -s \\192.168.64.98 msiexec.exe /i "\\SRV-2022\glpi-agent\GLPI-Agent-1.4-x64.msi" /quiet `
SERVER="http://192.168.100.150/glpi/front/inventory.php" RUNNOW=1
```

### Joindre un PC au domaine

```powershell
psexec -s \\192.168.64.145 -u administrateur -pV Mdp_Local_Account powershell -Command "$pw = ConvertTo-SecureString 'Mdp_Admin_Account' -AsPlainText -Force; $cred = New-Object System.Management.Automation.PSCredential('neopix.local\admtoto', $pw); Add-Computer -DomainName 'domaine.local' -Credential $cred -Restart"
```

### Lancer un script PowerShell

Utiliser `-File` pour indiquer le fichier .ps1

```cmd
psexec \\192.168.64.169 powershell -File "\\SRV\scripts\inventaire.ps1" -ExecutionPolicy Bypass
```

### Arguments supplémentaires

`-c` : Copie et exécute un programme.

```cmd
psexec \\192.168.64.94 -c "C:\Installers\AnyDesk.exe"
```


---


<br>



## __INTÉRAGIR AVEC UNE SESSION DISTANTE__

__Connaître le N° de la session distante permet de pouvoir interagir avec__

```batch
psexec \\192.168.64.184 query user
```

`-i` : Exécution interactive (ex. GUI) sur une session.

```sh
psexec \\192.168.64.94 -i notepad.exe
```

Cibler une session spécifique (ex : session 2)

```sh
psexec -s \\192.168.64.172 -i 2 notepad
```

Démarrer Chrome à distance

```powershell
psexec -s \\192.168.64.172 -u Administrateur -p ***** -i 1 powershell `
-command "Start-Process 'C:\Program Files\Google\Chrome\Application\chrome.exe'"
```
---

### Envoyer un message

```sh
psexec -s \\192.168.64.142 -u Administrateur -p ***** msg * "Bonjour !"
```

### Faire jouer un son `beep(frequency, duration)`

```powershell
psexec -s \\192.168.64.172 -i 1 -u Administrateur -p ***** powershell `
-command "[console]::beep(500,500)"
```

### Jouer "Joyeux anniversaire" 🎂 🎵

```powershell
psexec -s \\192.168.64.172 -i 1 -u Administrateur -p ***** powershell -command [console]::beep(264,250);[console]::beep(264,250);[console]::beep(297,500);[console]::beep(264,500);[console]::beep(352,500);[console]::beep(330,1000);[console]::beep(264,250);[console]::beep(264,250);[console]::beep(297,500);[console]::beep(264,500);[console]::beep(396,500);[console]::beep(352,1000);[console]::beep(264,250);[console]::beep(264,250);[console]::beep(528,500);[console]::beep(440,500);[console]::beep(352,500);[console]::beep(330,500);[console]::beep(297,1000);[console]::beep(466,250);[console]::beep(466,250);[console]::beep(440,1000)

```


---


<br>



## __TROUBLESHOOTING__


### Ordre des options

Cette commande peut échouer :
```bat
psexec \\192.168.0.15 -siu -a 1 -low Administrateur cmd
```

Mais celle-ci peut fonctionner :
```bat
psexec \\192.168.0.15 -a 1 -low -siu Administrateur cmd
```

<br>



### Netlogon non démarré

```bat
sc query netlogon
net start netlogon
```

<br>


### Partage réseau bloqué (souvent en Workgroup)


* Activer le réseau "Privé" pour le profil réseau.

* Vérifier ces ports sont ouverts et non bloqués vi le pare-feu :

| Port             | Description         |
| ---------------- | ------------------- |
| **445/TCP**      | SMB / IPC$          |
| **135/TCP**      | RPC                 |
| ports dynamiques | RPC Endpoint Mapper |

<br>

Règle de pare-feu 

* Si WinRM est actif (WinRM ne dépend pas du service LanmanServer)
```powershell
Enable-PSRemoting -Force
Invoke-Command -ComputerName NOM-PC -ScriptBlock { Set-NetFirewallRule -DisplayGroup "File and Printer Sharing" -Enabled True }
```

* Sans WinRM (fonctionnera seulement si le port 135 RPC est ouvert)
```powershell
wmic /node:NOM-PC process call create "powershell.exe -command Set-NetFirewallRule -DisplayGroup 'File and Printer Sharing' -Enabled True"
```


<br>


### Vérifier si le partage IPC$ est actif

```bat
net use \\PC-CIBLE\c$
```
Access is denied → le compte n’est pas admin local

The network path was not found → machine éteinte / pare-feu

Sinon → OK


<br>


### Vérifier le service LanmanServer (cmd)

* LanmanServer gère tous les partages réseaux sur la machine, y compris fichiers/imprimantes et l'accès SMB
* Ces ports associés sont : 445 (SMB), 135 (RPC), parfois 139 (NetBIOS sur TCP)
* Pour que les partages administratifs (C$, ADMIN$, etc.) puissent se faire, LanmanServer doit être actif

Voir si le service est actif
```bat
sc \\NOM-PC query lanmanserver
```
Sinon l'activer avec
```bat
sc \\NOM-PC start lanmanserver
```

* ⚠️ IMPORTANT : activer l’IPC distant ne contourne pas les droits.
Il faut toujours un compte admin local sur la machine cible.
Mais si le partage IPC$ est bloqué, même un admin recevra “Access Denied”

* net use \\PC\IPC$ ouvre juste une session SMB, pas besoin d’être admin local pour que ça réponde.
* sc \\PC query/service demande un accès RPC ADMIN, réservé exclusivement aux administrateurs locaux.


<br>


### Activer les partages administratifs (C$, ADMIN$…)

Cette méthode crée les partages automatiquement au démarrage
* Sur Windows client
```powershell
Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name AutoShareWks -Value 1 -Type DWord
Restart-Service LanmanServer -Force
```

* Sur Windows Server
```powershell
Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name AutoShareServer -Value 1 -Type DWord
Restart-Service -Name LanmanServer -Force
```



Ancienne méthode pour activer admin share si les autres ne fonctionnent pas (cmd ou powershell)
```bat
reg add "\\NOM-PC\HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableAdminShares /t REG_DWORD /d 0 /f
```
```powershell
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "DisableAdminShares" -Value 0 -Type DWord -Force
```



### Autoriser l’accès au réseau (local account token filter) → Contrôle l’élévation des droits pour les comptes locaux lors d’un accès à distance

* Avec cmd
```bat
reg add "\\NOM-PC\HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v LocalAccountTokenFilterPolicy /t REG_DWORD /d 1 /f
```

* Avec powershell
```powershell
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "LocalAccountTokenFilterPolicy" -PropertyType DWord -Value 1 -Force
```
Le système doit redémarrer

* 0 = filtrage activé (les comptes locaux à distance sont restreints)
* 1 = désactive le filtrage → les comptes locaux conservent les droits d’admin à distance

Même si C$ est activé, sans cette clé un compte local peut ne pas pouvoir accéder au partage administratif depuis un autre PC.



---



## FIN
