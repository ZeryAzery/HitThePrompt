
# Document d'Architecture Technique (DAT)

## 1. Architecture

### Schéma réseau

![alt text](<Lab_BadBlood.drawio.png>)


### Schéma des services

```mermaid
flowchart TD
    A[Hyperviseur] -->|hosts| W(Windows Server)
    A --> | hosts| C(Windows Client)
    A --> | hosts| L(Linux Server)

    W --> |running| Z{AD DC}
    W --> |running| E{DNS}
    W --> |running| F{WinRM}
    W --> |running| R{RDP}
    W --> |running| G{SMB} 
    W --> |executed| J>BadBlood] 

    L --> |running| H{WEB VLA}
    L --> |running| I{SSH}

    C --> |joined| Z
```



### Tableau des comptes administratifs

| Nom du compte        | Rôle              | Localisation   | Stockage des identifiants         |
|---------------------|------------------|----------------|---------------------------------------|
| Administrateur    | Admin Windows AD   | DC1-SRVW19     | `\\DC1-SRVW19\C$\Keepass\kps_base.kdbx`  |
| root                | Admin Linux        | Debian12.5     | `\\DC1-SRVW19\C$\Keepass\kps_base.kdbx`   |
|                     |                    |                |                                           |
|                     |                     |               |                                           |
|                      |                       |                 |                                          


## 2. Environnement

### Systèmes d’exploitation utilisés
|        OS                 | Hostname   |            Rôle                              |
|--------------------------|------------|---------------------------------------------------|                
| **Windows Server 2019**  | DC1-SRVW19 | Active Directory, DNS, SMB, WinRM                | 
|  **Windows 10 Pro**       | PC01-W10   | Workstation joignable au domaine                   | 
|  **Debian 12.5**         | DEB-APACHE | Serveur Web avec l’application _VulnerableLightApp_ | 

### Adressage IP

|        Hostname          |   IP        |  CIDR   |
|------------------------|--------------|---------|               
| **DC1-SRVW19**          | 10.0.0.1         | /24 |
|   **DEB-APACHE**        | 10.0.0.3        | /24 |
|  **PC01-W10**         | 192.168.200.100    |  /24 |

---

## 3. Exploitation

### Vérification des intégrités des images

* Vérifier un hash sous Windows
```powershell
Get-FileHash -Algorithm sha512 "F:\Users\Axel\Documents\Images ISO\Windows\Win 11\Win11_24H2_French_x64.iso"
```
![alt text](<File_Hash.png>)

* Vérifier un hash sous Linux
```bash
sha512sum "/tmp/debian.12.5.netinst.iso"
```
---

### Statuts des services critiques

#### Services DNS et Web

Vérification que le service web est lancé via dotnet
```bash
ps aux | grep dotnet
```
![alt text](<Vérif_dotnet.png>)

---

### Connexions SSH et WinRM réussies

* Se conencter avec WinRM
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
![alt text](<winrm_whoami.png>)
---

### Partages SMB/Samba

## Partage samba

```batch
net use \\10.0.0.3 /user:axel
```
![alt text](<Vérif_partage_samba.png>)
![alt text](<Partage_samba.png>)

---

### Nombre d'utilisateurs dans l’Active Directory

* Afficher le nombre total d'utilisateur
```powershell
(Get-ADUser -Filter *).count
```
![alt text](<Nombre_User_AD.png>)
---

### Diagramme de gestion de projet

```mermaid
gantt
    title Projet de mise en place du Lab (AD + Debian Web)
    dateFormat  YYYY-MM-DD
    excludes    weekends

    section Préparation
    Téléchargement des ISO               :done, iso, 2025-05-10, 1d
    Vérification des hashs              :done, hash, 2025-05-11, 1d

    section Installation des VMs
    Installation Windows Server         :done, winserv, 2025-05-12, 2d
    Installation Debian 12.5            :done, deb, 2025-05-14, 1d
    Joindre client Windows au domaine   :done, join, 2025-05-15, 1d

    section Configuration des Services
    DNS / AD / WinRM                    :done, confad, 2025-05-16, 1d
    Partages SMB / Samba                :done, share, 2025-05-17, 1d
    Déploiement de l'application Web    :done, web, 2025-05-18, 1d
    Test des accès SSH et WinRM         :done, access, 2025-05-19, 1d

    section Sécurisation (à faire)
    Audit de sécurité et durcissement   :crit, secu, 2025-05-20, 3d
```
---

## Notes


