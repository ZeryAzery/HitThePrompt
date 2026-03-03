# Debian commands



---

<br>



## 🔰 Commandes de bases



### Manuel d'aide d'une commande
```bash
man grep
```

### Aide tl;dr
```bash
sudo apt install tldr
tldr awk
```



### Mise à jour 
```bash
apt update && apt upgrade -y
```

### Configurer clavier fr :
```bash
apt install console-setup
```

### Nettoyer le terminal :
```bash
clear
```

### Vérifier/Ajuster heure et fuseau horaire :
```bash
timedatectl
timedatectl set-timezone Europe/Paris
```

### Trouver son adresse publique :
```bash
curl ifconfig.me
```

### Changer le mdp :
```bash
passwd
```

### Afficher nom/Renommer la machine : (puis redémarrer)
```bash
hostname
nano /etc/hostname
hostnamectl set-hostname nom_hôte
```

### Passer en sudo :
```bash
su root 
su -l #(donne plus de privilèges)
```

### Vérifier quel terminal on utilise :
```bash
echo $SHELL
```


## Nom de la distribution + version
```shell
cat /etc/os-release
```

## Nom du système + architecture
```shell
uname -a
```


### Version du Kernel :
```bash
uname -r
```

## Architecture du processeur
```shell
uname -m
```



### Version de Debian :
```bash 
cat /etc/issue  
cat /etc/debian_version
```

### Créer un alias (fichier .bashrc) :
```bash
cd ~
nano .bashrc 
```

Puis ajouter 
```ini 
alias ll='ls -la'
```
Recharger le fichier pour que les modifs prennent effet
```bash
source .bashrc (rajouter ~/ si pas dans le répertoire utilisateur : source ~/.bashrc)
```



### Exemple de personalisation/création d'un alias (`ls -la` ici)
```bash
alias ll="ls -la | awk 'NR==1 {print; next} {printf \"%s | %s | %s | %s  %2s %3s %3s %8s %s %s %s %s\n\", substr(\$1,1,1), substr(\$1,2,3), substr(\$1,5,3), substr(\$1,8,3), \$2, \$3, \$4, \$5, \$6, \$7, \$8, \$9}'"
```
Je précise que ça n'a surement pas été créé à l'aide de ChatGPT (ouhhh que non)







---

<br>






# 📶 Réseau 


### Pour une config statique dans le fichier interfaces : (nano /etc/network/interfaces)
```sh
allow-hotplug enp0s3
iface enp0s3 inet static
	address 192.168.0.16/24
	gateway 192.168.0.1
	dns-nameserver 8.8.8.8
```
> [!NOTE] 
> * __*allow-hotplug*__ active l’interface quand elle est détectée  
> * __*auto*__ active l’interface au démarrage du système (pendant le boot)
> * ⚠️ Ne pas mettre les deux à la fois.


### Config DHCP
```sh
# loopback
auto lo
iface lo inet loopback

# enp0s8
auto enp0s8
iface enp0s8 inet dhcp
```


### Pour reset la carte reseau : 
```bash
systemctl restart networking
```

### Activer/Désactiver une carte réseau :
```bash
ifup enp0s3
ifdown enp0s3
```

### Affichier la table ARP connue :
```bash
ip neigh show
```

### Désactive IPv6 au niveau du système, ajouter les lignes dans /etc/sysctl.conf
```bash
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1 
sysctl -p # recharger pour appliquer les modifs
```

### Afficher les ports en écoute s
```bash
ss -tulnp 
```
* `-t`: TCP 
* `-u`: UDP
* `-l`: Ports en écoute
* `-n`: Ne pas résoudre les noms
* `-p`: processus associé


### Voir quel processus utilise un port
```bash
lsof -i -P -n | grep LISTEN
```

### Fichier de résolution DNS
```bash
/etc/resolv.conf
```



---

<br>




# 📁 Manipulation de fichiers


### Supprimer un dossier et tout son contenu :
```bash
rm -rf /chemin/vers/le/dossier
```


### Copier un dossier et tout son contenu :
```bash
cp -r tssr-cyber.fr /root/site.backup
```


### Afficher/rentrer dans un dossier caché 
```bash
ls -la
cd ./.ssh
```


### écraser le contenu d'un fichier : (définitif)
```bash
> nom-fichier
```


###  Le chevron simple écrase, le double (>>) rajoute le texte:
```bash
touch toto.txt | echo "tartanpion" > toto.txt
touch toto.txt | echo -e "\nturlututu" >> toto.txt # (-e permet d'interpréter le saut de ligne \n )
```


### Afficher les permissions du dossier en cours :
```bash
ls -ld .
```


### Rechercher le fichier .bashrc en redirigeant les flux d'erreurs dans /dev/null :
```bash
find /home -type f -name '.bashrc' 2>/dev/null
```


### Intégrité d'un fichier (hachage):
```bash
sha256sum nom_fichier
```


### Vérifier le poid d'un fichier :
```bash
du nom_fichier #(du pour disk usage)
ls -lh
```


### Trier avec la commande ls et ses options:
```bash
ls -larth /var/log/suricata/
```
* `-l` : permissions, propriétaire, taille, date...
* `-a` : fichiers cachés.
* `-r` : Trie les fichiers dans l'ordre inverse 
* `-t` : Trie du plus récent au plus ancien.
* `-h` : Affiche les tailles des fichiers 



### Copier ou créer un fichier en lui donnant les permissions 

* `ìnstall` est un genre de `cp` amélioré
* Permet de copié ou créé un fichier/dossier si il n'existe pas
* Permet de définir les permissions, propriétaire et groupe

les permissions (-m)
le propriétaire (-o)
le groupe (-g)
créer les dossiers nécessaires (-d)

```bash
install -m 0755 script_test.sh /usr/local/bin/
```




### Transférer un fichier avec netcat : (fonctionne avec tous types de fichiers)
```bash
apt install netcat
```
* sur machine réceptrice ("-l" pour listening, "-p" pour port):	
```bash
netcat -l -p 1234 > toto.txt 
```
* sur machine émettrice :		
```bash
cat toto.txt | netcat 192.168.100.50 1234 -q 0
```

### Transmettre un fichier de l'lhôte vers une VM : (chmod 777 requis je crois...)
```bash
scp -r "C:\Users\Toto\Desktop\img site\section-1-bg.jpg" root@192.168.0.20:/var/www/html/tssr-cyber/img
```
### Transmettre un fichier sur une autre machine avec port spécifique (scp utilise ssh)
```bash
scp -P 6666 aliasll.sh Toto@10.0.0.6:/home/Toto
```





---

<br>






# 📇 Samba


### Installer Samba
```bash
sudo apt update
sudo apt install samba
```
### Créer les dossiers à partager
```bash
sudo mkdir -p /srv/samba/readonly
sudo mkdir -p /srv/samba/writeable
sudo chown nobody:nogroup /srv/samba/readonly
sudo chown Toto:Toto /srv/samba/writeable
sudo chmod 755 /srv/samba/readonly
sudo chmod 770 /srv/samba/writeable
sudo chown -R Toto:Toto /srv/samba/writeable
sudo chmod 770 /srv/samba/writeable
```



### Ajouter l’utilisateur Samba
```bash
sudo smbpasswd -a Toto
```



### Modifier la configuration Samba
```bash
sudo nano /etc/samba/smb.conf
```



### Ajouter à la fin du fichier smb.conf
```shell
[readonly]
   path = /srv/samba/readonly
   browsable = yes
   read only = yes
   guest ok = yes

[writeable]
   path = /srv/samba/writeable
   browsable = yes
   read only = no
   valid users = Toto
```



```
### __Protéger la confidentialité en empêchant l’interception :__

??
```




### Activer le chiffrement SMB (SMB Encryption) dans le fichier /etc/samba/smb.conf, exemple pour un dossier "secure"
```bash
[secure]
  path = /srv/samba/secure
  read only = no
  valid users = Toto
  smb encrypt = required
```



### Vérifier la conf du fichier samba
```bash 
testparm
testparm -s
```



### Redémarrer Samba et tester depuis un client
```bash 
sudo systemctl restart smbd 
smbclient -L //IP_du_serveur -U Toto
```



### Ajouter des règles de parefeux pour samba
```bash 
sudo ufw allow 137,138/udp
sudo ufw allow 139,445/tcp
```



### Tester depuis une machine windows
```batch
net use \\10.0.0.3\writeable
```



### Voir les connexions actives côté serveur
```sh 
sudo smbstatus
```




---

<br>




# 🪝 GREP


### Rechercher un mot exacte
```bash  
grep -i "^admin$" ./rockyou.txt
```



### Rechercher un mot exacte: Exclure avec grep : (i=ignore la casse et v= exclu)
```sh
journalctl -xe | grep -iv "CRON"
```



### Vérifier si une ligne spécifique existe déjà dans un fichier
```sh
grep -qxF "alias ll='ls -la'" ~/.bashrc
```


### Chercher plusieurs expressions danns un fichier
```sh
grep -Ei "error|fail|denied" /etc/server.log
```




---

<br>





# 🔍 FIND  


### Rechercher ce qui contient test dans le dossier actuel:
```bash
find ./ -type f -name "*test*"
```


### Localiser un binaire 
```sh
locate ls
```
```sh
where kerbrute
```




---

<br>





# 👮‍♀️ Gestion des permissions

| Octal | Signification                 |
|-------|-------------------------------|
| 0     | --- (aucune permission)       |
| 1     | --x (exécution)               |
| 2     | -w- (écriture)                |
| 3     | -wx (écriture + exécution)    |
| 4     | r-- (lecture)                 |
| 5     | r-x (lecture + exécution)     |
| 6     | rw- (lecture + écriture)      |
| 7     | rwx (lecture + écriture + exécution) |



### Donner les permissions max au dossier en cours
```bash
chmod 777 .
```



### Droit d'exécution d'un fichier pour l'utilisateur en cours
```sh
chmod +x script.sh 
```


### Droit de lecture pour tout le monde sur un fichier
```bash
chmod a+r fichier.txt
```

* `a` → « all », donc tous les utilisateurs : propriétaire (u), groupe (g) et autres (o)
* `+r` → ajoute le droit de lecture



### Activer/Retirer le Sticky bit sur un fichier/dossier
```bash
chmod +t Archives
chmod -t Archives 
```




---

<br>





# 📇 Gestion des packages


### Pour changer de serveur de gestion de paquets :
```bash 
nano /etc/apt/sources.list
```

### retirer un ancien dépot inutile
```sh
sudo rm /etc/apt/sources.list.d/stretch-backports.list
```


### Rechercher des paquets
```bash   
apt search suricata
apt-cache search suricata
```



### Montrer les paquets installés/chercher un paquet installé
```bash 
apt list --installed 
apt list --installed | grep nom_paquet
```



### Désinstaller un package et ses dépendances inutilisées
```bash 
apt remove --purge nom_package
apt autoremove --purge nom_package
```




---

<br>






#  🛣️ SSH


### Installer SSH
```bash
apt install openssh-server -y
```


### Vérifier et démarrer le service SSH
```bash
sudo systemctl enable ssh --now
sudo systemctl status ssh
```



### Modifier le fichier de configuration (pour changer le port d'écoute par exemple)
```bash
nano /etc/ssh/sshd_config
systemctl restart ssh
```



### Vérifier le port SSH utilisé
```bash
ss -tlnp | grep ssh
```



### Désinstaller et réinstaller OpenSSH
```bash
systemctl stop ssh
apt remove --purge openssh-server -y
apt autoremove -y
```



### Vérifier les journaux ssh
```bash
journalctl -u ssh
```

* La clé privée sera dans ~/.ssh/id_rsa et la clé publique dans ~/.ssh/id_rsa.pub
* cd /root/.ssh et faire ls les deux fichiers des clée devraient être ici
* copier la clé publique (id_rsa.pub) dans un fichier nommé "authorized_keys"
* sur MobaXterm (pratique pour coller le fichier clé privée sur la machine cliente) :
	* En haut à gauche dans le gestionnaire de fichier inquer l'adresse (/root/.ssh)
	* Et télécharger le fichier clé privée (id_rsa) dans C:\Users\Toto\.ssh 
	* Ensuite fermer moba et le rouvrir 
	* Si tout fonctionne supprimer la clée privée du serveur

* La clé publique (id_rsa.pub doit être sur la machine cliente et la clé privée sur la machine à laquelle on souhaite se connectée !)
* Configurer le fichier etc/ssh/sshd_config et changer ces valaurs :
```ini
# Désactiver l'authentification par mot de passe
PasswordAuthentication no
# Forcer l'authentification par clé publique 	
PubkeyAuthentication yes
```



```bash	
systemctl restart sshd
```



### Spécifier un port pour la connexion ssh
```bash	
ssh -p 4444 Toto@192.168.100.2
```




---

<br>






# 🙋‍♂️ DHCP


### S'installe ici automatiquement : `/etc/dhcp` 
```bash
apt install isc-dhcp-server
```



### Configurer les fichiers DHCP : (dhcp > plage IP/Mask/Bail au minimum pour fonctionner, puis GW et DNS)
```sh
nano /etc/default/isc-dhcp-server
```


```ini
# Puis ajouter
INTERFACESv4="enp0s3"
```


### Renommer le fichier d'origine en .old
```bash
cp  /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.old
```


### Vider puis éditer `/etc/dhcp/dhcpd.conf`
```sh
#echo /dev/null > /etc/dhcp/dhcpd.conf
> /etc/dhcp/dhcpd.conf
nano /etc/dhcp/dhcpd.conf
```



### Exemple d'un fichier dhcpd.conf :
```ini
default-lease-time 30000;
max-lease-time 30000;

authoritative;

subnet 192.168.20.0 netmask 255.255.255.0 {
range 192.168.20.10 192.168.20.100;
option routers 192.168.20.254;
option domain-name-servers 8.8.8.8;
}
```



### Enregisterer le fichier puis redémarrer le servive
```bash
systemctl restart isc-dhcp-server
# ou
service isc-dhcp-server restart
```


### Vérifier qu'il a prit le DHCP : (montre les machines qui ont chopé le dhcp)
```bash
cat /var/lib/dhcp/dhcpd.leases
```





---

<br>






# 🗒️ DNS 


```bash
apt install bind9
ls /etc/bind
```


* __Il y a 3 fichiers à configurer pour le dns :__
	* named.conf.local
	* db.127
	* db.local



### Fichier de conf DNS : named.conf.local
```bash
nano /etc/bind/named.conf.local
```


configurer le fichier comme ceci :
```ini
zone "debdns.net {
type master;
file "/etc/bind/dir.debdns.net";
allow-update {none ; } ;
};
zone "20.168.192. in-addr.arpa" {
type master;
file "/etc/bind/inv.tssr.net";
}; 
```



### Fichier zone directe db.127
```bash
# Créer les fichiers "dir.debdns.net" et "inv.debdns.net" :
cp /etc/bind/db.local /etc/bind/dir.tssr.net # zone directe
cp /etc/bind/db.127 /etc/bind/inv.tssr.net   # zone inversée
# Configurer le fichier de la zone directe :
nano /etc/bind/dir.debdns.net
# À la place de local host mettre debian-srv.debdns.net et root.debdns.net 
# et
NS 	debian-srv.debdns.net.
A	192.168.20.30
# Pour tester :
nslookup + NOM
```



### Fichier zone inversée db.local
```ini
# À la place de localhost mettre srv.tssr.net et root.debdns.net
# et
NS	SRV.tssr.net
PTR	SRV.tssr.net
PTR	SRV.tssr.net
```



### Pour tester le DNS :
```sh
named-checkzone tssr.net /etc/bind/dir.tssr.net
nslookup + IP # (! Sur nslookup ne pas taper ctrl+C mais exit !)
```

> [!NOTE] 
> Chaque serveur DNS à sa propre zone et s'il n'a pas l'adresse dans sa base il ira chercher dans une base supérieure
Il y a 13 serveurs racines dans le monde (principalement aux États Unis)





---

<br>






# 🙋 Gestion des utilisateurs  


### Lister les utilisateurs :
```bash
cut -d: -f1 /etc/passwd | grep "Toto"
```


### Ajouter un utilisateur : (`-m` permet de créer en même temps le répertoire personnel)
```bash
useradd -m <user_créé>
```


### Vérifier si l'utilisateur a les droits sudo
```bash
sudo -l
```


### Ajouter un user au sudoers :
```bash
sudo usermod -aG sudo nom_utilisateur
```


### ou plus simple :
```bash
sudo adduser nom_utilisateur sudo
```


### Création du mot de passe
```bash
passwd <nom_user>
```


### Supprimer un utilisateur et son répertoire d'origine : (root ou sudo)
```bash
userdel -r jeandupont
```


### Installer zsh :
```bash
sudo apt-get install zsh
```


### Redémarrer le terminal pour appliquer les modifications :
```bash
exec zsh
```


### Ne plus avoir à saisir de mot de passe sous Linux en utilisant l'outils visudo :
```bash
sudo visudo (il se rend directement dans /etc/sudoers cet outils corrige les fautes de frappes)
```


### Et sous la ligne "%sudo ALL=(ALL:ALL) ALL" créer cette ligne :
```bash
<nom_user> ALL=(ALL:ALL) NOPASSWD:ALL
```


### Définir bash comme terminal par défaut 
```bash
chsh -s /bin/bash
```
Puis se déco ou redémarrer après ou alors faire la commande `source ~/.bashrc`





---

<br>






# 🚷 FAIL2BAN


### Repérer une erreur dans la conf fail2an :
```bash
fail2ban-client -t
```


### Exemple d'un Fichier /etc/fail2ban/jail.conf :
```ini
[DEFAULT]
ignoreip = 89.158.245.50
bantime = 10m
findtime = 10m
maxretry = 5
backend = systemd
banaction = iptables-multiport

[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 1h
findtime = 10m
action = ufw[name=SSH, port=ssh, protocol=tcp]
```


### Vérifier le statut de la jail sshd
```bash
fail2ban-client status sshd
```


### Vérifier les logs fail2ban
```bash
cat /var/log/fail2ban.log
# ou
tail /var/log/fail2ban.log
```


### Vérifier les logs en temps réel
```bash
tail -f /var/log/fail2ban.log
```





---

<br>





# 🧱 UFW 


### réinitiliser ufw (retire toutes les règles)
```bash
ufw reset
```


### Bloquer toutes les connexions entrantes (apt fonctionnera encore..)
```bash
ufw default deny incoming
```


### Autoriser toutes les connexions sortantes
```bash
ufw default allow outgoing
```


### ouvrir un port avec ufw
```bash
ufw allow 2222/tcp
```


### Fermer un port avec ufw
```bash
ufw delete allow 22/tcp
```


### Activer ufw
```bash
ufw enable
```


### Désactiver UFW
```bash
systemctl stop ufw.service
systemctl disable ufw.service
```


### Désactiver l'IPv6 avec ufw en mettant IPV6=no
```bash
nano /etc/default/ufw
ufw disable  	
ufw enable
```


### Vérifier les règles ufw
```bash
ufw status verbose
```






---

<br>





# 📆 CRON


cron est l'exétuteur de tâches planifiées

### Afficher le fichier crontab 
```bash 
crontab -l
```


### Éditer le fichier crontab
```bash 
crontab -e
```



> [NOTE]
> cron utilise 5 positions (min, heure, jour du mois, mois, jour de la semaine)


### Exemples pour le fichier crontab
```ini
*/5 * * * * ~/duckdns/duck.sh >/dev/null 2>&1	# toutes les 5 minutes
*/30 * * * * ~/duckdns/duck.sh >/dev/null 2>&1	# toutes les 30 minutes
0 * * * * ~/duckdns/duck.sh >/dev/null 2>&1		# toutes les heures chaque jour	
0 3 * * * ~/duckdns/duck.sh >/dev/null 2>&1		# à une heure précise chaque jour
0 3,5,7 * * * ~/duckdns/duck.sh >/dev/null 2>&1	# à 3h, 5h et 7h chaque jour
```

### Autre exemple
```ini
0 3 1 * * apt update && apt upgrade -y && apt autoremove -y && apt autoclean
```


| Position | Valeurs possibles        | Signification                          |
|----------|--------------------------|----------------------------------------|
| 0        | 0-59                     | Minute (ici, à 00)                     |
| 3        | 0-23                     | Heure (ici, à 03:00)                   |
| 1        | 1-31                     | Jour du mois (ici, le 1er)             |
| *        | 1-12 ou *                | Mois (ici, tous les mois)              |
| *        | 0-7 (0 et 7 = Dimanche)  | Jour de la semaine (ici, tous les jours) |

> [HINT]
> Si une valeur est entrée dans la colonne "Jour du mois" (3ème colonne) et une autre dans "Jour de la semaine" (5ème colonne), cron exécute la tâche si l'une des deux conditions est remplie.
Ex : 0 3 1 * 5 → Exécuté le 1er du mois et tous les vendredis.






---

<br>





# 🕸️ APACHE2



### Utiliser le bon nom de domaine 
```bash
nano /etc/apache2/apache2.conf 
```


### Puis ajouter 
```bash
ServerName seemyresume.duckdns.org
```


### Vérifier la syntaxe (de tous les fichiers confs d'appache2..)
```bash
apache2ctl configtest
```

> [!TIP] Rappel des principaux fichiers à configurer :
> * /etc/apache2/sites-available/nom_fichier_site
> * /var/www/nom_dossier_site/index.html


### Donner les droits appropriés à www-data (utilisateur Apache et lisibles pour les autres utilisateurs)
```bash
sudo chown -R www-data:www-data /var/www/seemyresume
sudo chmod -R 755 /var/www/seemyresume
```



### certificat TLS : 
```sh
certbot --apache -d mon-site.fr
```






---

<br>





# 💿 GESTION DES DISQUES 



### Afficher les disques et partitions montées
```bash
lsblk
```


### Gérer les partitions
```sh
fdisk -l
```


### Voir l'espace utilisé sur les disques virtuels :
```bash
df -h 
```


### interface semi-graphique pour créer/supprimer des partitions
```sh
cfdisk /dev/sdb
```




##  Création d’un fichier swap

Le swap sert d’extension à la mémoire RAM.


### Crée un fichier vide de 1 Go pour servir de swap
```bash
fallocate -l 1G /swapfile
```


### limiter les droits pour la sécurité
```bash
chmod 0600 /swapfile
```


### Formate le fichier comme swap
```sh
mkswap /swapfile
```


### Active le swap
```sh
swapon /swapfile
```


### Affiche la mémoire et vérifie que le swap est actif
```bash
free -m
```


### Ajuste la *swappiness* (contrôle la fréquence d'utilisation du swap) 
```bash
cat /proc/sys/vm/swappiness
echo 1 > /proc/sys/vm/swappiness
```

* 60 = valeur par défaut (utilisation modérée)
* 1 = n’utiliser le swap qu’en dernier recours.





---

<br>






# ➡️⬅️ Installation et connexion iSCSI



### Installe le paquet client iSCSI sur Debian.

Ce service permet à la machine d'accéder à des volumes de stockage distants (targets iSCSI)
```bash
apt install open-iscsi
```

### Découvre les cibles iSCSI disponibles sur le serveur 10.0.0.1
```bash
iscsiadm -m discovery -t sendtargets -p 10.0.0.1
```
* `-m discovery` : mode de découverte
* `-t sendtargets` : méthode standard de découverte
* `-p 10.0.0.1` : IP du serveur cible iSCSI


### Se connecte à la cible iSCSI découverte.

Un nouveau disque apparaîtra dans `/dev/` (souvent `/dev/sdb`).
```bash
iscsiadm -m node --login
```

<br>


## Gestion et montage du disque iSCSI


### Liste les disques et partitions, le disque iSCSI devrait apparaître.
```bash
fdisk -l
```

### Créer un dossier de montage et monte la partition iSCSI.
```bash
mkdir /mnt/TOTO
mount /dev/sdb1 /mnt/TOTO/
```


### Installe le pilote NTFS pour lecture/écriture. (Utile depuis un Windows)
```bash
apt install ntfs-3g
```

### Monte et navigue dans le dossier monté
```bash
mount /dev/sdb1 /mnt/TOTO/
cd /mnt/TOTO/
```

### Démonter le disque
```bash
umount /mnt/TOTO
```

### Connexion iSCSI automatique au démarrage
```bash
iscsiadm -m node --op update -n node.startup -v automatic
systemctl enable open-iscsi
```





---

<br>








# 🔢 Cryptographie

### Vérifier ou Installer OpenSSL
```bash
openssl version
```
```bash
sudo apt update && sudo apt install openssl -y
```

### Chiffrer une chaîne de caractères en AES-256-CBC
Avec salt et sortie en Base64 et dérivation PBKDF2 (facultatif mais plus sécurisé)
```bash
echo 'TESTSECRET1234567' | openssl enc -aes-256-cbc -salt -pbkdf2 -base64 > aes-test.txt
```
* clé = PBKDF2(mot_de_passe, salt, iterations=10000, hash=SHA256)
* `-pbkdf2` permet de dériver la clé à partir du mot de passe (mécanisme plus sécurisé)

### Afficher la décomposition de clé
`-P` affiche : salt, key, iv
```bash
echo 'TESTSECRET1234567' | openssl enc -aes-256-cbc -salt -pbkdf2 -P
```

### Déchiffrement
```bash
echo 'CIPHERTEXT_BASE64' | openssl enc -aes-256-cbc -d -salt -pbkdf2 -base64
```
`-d` pour le déchiffrement

> [!IMPORTANT] 
> Le Base64 commence toujours par : `U2FsdGVkX1` 








---

<br>





##  DIVERS

```bash
apt install figlet
figlet pour le lol
```


```sh
apt install cmatrix
```



### Découvrir une commande Linux au hasard :
```sh
man (ls /usr/bin /usr/sbin | shuf -n1)
```

