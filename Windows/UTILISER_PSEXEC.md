# __UTILISER PSEXEC__



---


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
5. [ERREURS RENCONTRÉES](#erreurs-rencontrées)
6. [INTÉRAGIR AVEC UNE SESSION DISTANTE](#intéragir-avec-une-session-distante)



---


## __PRÉREQUIS__

- PsExec ne fonctionne qu’entre hôtes **Windows**.
- Le port **TCP 445** (SMB) doit être ouvert.
- Le partage **ADMIN$** doit être actif.
- Le service **Netlogon** est parfois nécessaire.
- Requière un __compte administrateur sur la machine hôte.__
- Ajouter PsExec au PATH système (Modifier la variable **Path** et y ajouter le dossier où se trouve `PsExec.exe`)


---


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



## __INTÉRAGIR AVEC UNE SESSION DISTANTE__

__Connaître le N° de la session distante permet de pouvoir interagir avec__

```batch
psexec \\192.168.64.184 query user
```

`-i` : Exécution interactive (ex. GUI) sur une session.

```cmd
psexec \\192.168.64.94 -i notepad.exe
```

Cibler une session spécifique (ex : session 2)

```c
psexec -s \\192.168.64.172 -i 2 notepad
```

Démarrer Chrome à distance

```powershell
psexec -s \\192.168.64.172 -u Administrateur -p ***** -i 1 powershell `
-command "Start-Process 'C:\Program Files\Google\Chrome\Application\chrome.exe'"
```
---

### Envoyer un message

```cmd
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


## __ERREURS RENCONTRÉES__

### Netlogon non démarré

```cmd
sc query netlogon
net start netlogon
```

### Partage réseau bloqué (souvent en Workgroup)

- S'assurer que le pare-feu autorise SMB (port 445).
- Activer le réseau "Privé" pour le profil réseau.

### Ordre des options critique

Cette commande peut échouer :

```cmd
psexec \\192.168.0.15 -siu -a 1 -low Administrateur cmd
```

Mais celle-ci peut fonctionner :

```cmd
psexec \\192.168.0.15 -a 1 -low -siu Administrateur cmd
```


---



## FIN
