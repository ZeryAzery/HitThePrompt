# Raccourci de l'invite d'exécution

| Commande             | Ouvre...                                                      |
|----------------------|---------------------------------------------------------------|
| `mstsc`              | Connexion Bureau à distance                                   |
| `taskschd.msc`       | Planificateur de tâches                                       |
| `firewall.cpl`       | Paramètres du Pare-feu Windows                                |
| `wf.msc`             | Pare-feu Windows avec fonctions avancées                      |
| `lusrrmgr.msc`       | Gestion des utilisateurs et groupes locaux                    |
| `ncpa.cpl`           | Connexions réseau                                             |
| `msconfig`           | Configuration du système (démarrage, services, etc.)          |
| `control`            | Panneau de configuration classique                            |
| `appwiz.cpl`         | Programmes et fonctionnalités                                 |
| `sysdm.cpl`          | Propriétés système                                            |
| `compmgmt.msc`       | Gestion de l’ordinateur (utilisateurs, disques, événements)   |
| `sysprep`            | Outil de préparation du système (déploiement)                 |
| `secpol.msc`         | Stratégies de sécurité locale                                 |
| `rsop.msc`           | Jeu résultant de la stratégie locale                          |
| `regedit`            | Éditeur du Registre                                           |
| `mmc`                | Console de gestion Microsoft                                  |
| `taskmgr`            | Gestionnaire des tâches                                       |
| `optionalfeatures`   | Fonctionnalités Windows à activer ou désactiver               |
| `eventvwr.msc`       | Observateur d’événements                                      |
| `printmanagement.msc` | Gestionnaire d'impression/drivers                            |
| `services.msc`       | Console de gestion des services                               |
| `devmgmt.msc`        | Gestionnaire de périphériques                                 |
| `diskmgmt.msc`       | Gestion des disques                                           |
| `netplwiz`           | Paramètres avancés des comptes utilisateurs                   |
| `inetcpl.cpl`        | Options Internet                                              |
| `powercfg.cpl`       | Options d’alimentation                                        |
| `mmsys.cpl`          | Paramètres de son                                             |
| `main.cpl`           | Propriétés de la souris                                       |
| `control printers`   | Périphériques et imprimantes                                  |
| `shell:startup`      | Dossier des programmes de démarrage de l’utilisateur         |
| `slmgr`              | Windows Software Licensing Management Tool                    |
| `certmgr.msc`        | Gestionnaire de certificats                                   |
| `hdwwiz.cpl`         | Assistant d’ajout de matériel (identique devmgmt ?)           |
| `perfmon`            | Moniteur de performance                                       |
| `dxdiag`             | Outil de diagnostic DirectX                                   |
| `msinfo32`           | Information systèmes                                          |
| `tpm.msc`            | Gestion du module de plateforme sécurisée (TPM)               |

## Active Directory :

| Commande             | Ouvre...                                                      |
|----------------------|---------------------------------------------------------------|
| `adsiedit.msc`       |  équivalent de "regedit" pour Active Directory.               |
| `dsa.exe`            |  Utilisateurs et ordinateurs de l'Active Directory.           |
| `virtmgmt.msc`       |  Gestionnaire Hyper-V                                         |
| `gpedit.msc`         |  Gestionnaire de stratégies de groupe                         |
| `adsiedit.msc`       |  Modification ADSI                                         |
| `gpmc.msc`           | Console de gestion des stratégies de groupe (GPMC)            |
 


## Utiliser les variables d'environnement 

| Chemin / Dossier                       | Variable                            |
| -------------------------------------- | ----------------------------------- |
| C:\WINDOWS                             | `%systemroot%` ou  `%windir%` |
| C:\Users\Axel\AppData\Local\Temp       | `%temp%` |
| C:\ProgramData                         | `%ProgramData%` |  
| C:\Users\Axel                          | `%userprofile%`                     |
| C:\Users\Axel\Documents                | `%userprofile%\Documents`           |
| C:\Users\Axel\AppData\Roaming          | `%appdata%`                         |
| C:\Users\Axel\Desktop                  | `%userprofile%\Desktop`             |
| C:\Program Files                       | `%ProgramFiles%`                    |
| C:\Program Files (x86)                 | `%ProgramFiles(x86)%`               |
| C:\Windows\System32                    | `%systemroot%\System32`             |
| Dossier système 64-bits                | `%windir%\System32`                 |
| Dossier système 32-bits sur OS 64-bits | `%windir%\SysWOW64`                 |
| Chemin complet du serveur DNS          | `%SystemRoot%\System32\drivers\etc` |




