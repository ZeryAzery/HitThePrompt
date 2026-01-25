# Conf de base 

```shell
enable
conf t
hostname S1
line console 0
password cisco
login
exit
ena sec class
service password-encryption
no ip domain-lookup 
no cdp run 
banner motd "This is a secure system. Authorized Access Only!"
exit
wr 	
```

Régler horloge
```shell
sh clo
clo se 13:37:00 14 MARCH 2025
```

------------------------------------------------------------------------------------------



<br>


* `?` pour savoir les commandes disponibles
* `do` avant la commande permet d'exécuter une commande sans faire exit
* `wr` = `copy running-config startup-config` ?
* `no cdp run`  		> protocole Cisco qui permet aux équipements réseau d’échanger des infos sur leurs voisins
* `no ip domain-looku` 	> évite recherche DNS en cas d'erreur de frappe



<br>


------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------


<br>


# Interface routeur/switch

```shell
int g0/0
ip ad 10.1.1.1 255.255.255.0
desc LAN to S2
no sh
exit
ex
wr
```
```shell
sh ru
```

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------


<br>


# 🏁 RIPv2 


Configurer une route statique
```shell
ip route 10.1.1.0 255.255.255.0 g0/2 (nom interface ou adresse IP interface ?)
```
Afficher les routes statiques
```shell
do show running-config | include ^ip route
```
Routage RIPv2
```shell
router rip
version 2
no auto-summary
network 192.168.0.0
network 209.165.200.224
exit
```
• Afficher les routes rip
```shell
show ip route rip
```

<br>


------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

# 🚧 VLAN 

```shell
vlan 10 
name EMPLOYES 
vlan 20 
name ETUDIANTS 
vlan 30 
name INVITES 
vlan 99 
name MANAGEMENT 
```

__• MODE ACCESS__  (Le port en mode access laisse passer le traffic d'un VLAN)

```shell
int fa 0/11
switchport access vlan 10

int fa 0/18
sw ac vl 20

int range Gi 0/1-2
switchport mode trunk
switchport trunk native vlan 99

sh vl br

VLAN NATIF:
int ra g0/1–2
switchport trunk native vlan 84 (sw tr na vl 84)
sh ru
```

***Le VLAN 1 apparaîtra tjrs sur les interfaces non taguées***
Le VLAN 1 (natif) est souvent déplacé pour des raisons de sécurité (il n'a pas de trame 802.1Q)



__• MODE TRUNK__  (Le port Trunk laisse passer le traffic de plusieurs VLANs)

SWITCH ( -> sur le port connecté au routeur ! ):

```shell
int ra g0/1-2
switchport mode trunk 			(sw mo tr)
switchport trunk allowed vlan 10,20,30	(sw tr al vl 10,20,30) 
ex
ex
wr
```
***Le protocole DTP négocie automatiquement l'autre côté des liens trunk.***
show interface trunk (sh int tr)


ROUTEUR (sur l'interface reliée au switch):

```shell
int g0/0.10
encapsulation dot1Q 10
ip ad 192.168.10.1 255.255.255.0

int g0/0.20
encapsulation dot1Q 20
ip ad 192.168.20.1 255.255.255.0


do sh vl
do sh in tr
```

Pour faire passer le service DHCP entre les vlans faire (si le serveur dhcp est en 192.168.20.11) :
interface g0/0/1.10
ip helper-address 192.168.20.11


⚠️ Pour adresser une IP sur une interface physique quand un routeur avec le vlan 1 (natif) est éteint (car ce sont les SVIs portent les adresses)
il faut utiliser la commande "no switchport" sur l'interface sur laquelle on souhaite adresser une IP.



-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------


<br>


 # 🔁 LACP 


Aggrégation de liens (EtherChannel) 

• PAgP > protocole Cisco EtherChannel
• LACP > version standard ouverte d’EtherChannel (IEEE - 802.3ad)

• Travailler sur les liens éteints pour éviter « err-disabled » 

SWITCH-1
```shell
int ra fa0/3-4
shutdown
channel-group 2 mode active (LACP)
no sh
int port-channel 2
sw tr enc dot1q -----------> (sur les switchs L3 faire l'encap pour pouvoir passer en trunk)
switchport mode trunk
do wr
```

SWITCH-2
```shell
int ra fa0/3-4
shutdown
channel-group 2 mode desirable (PAgP)
no sh
int port-channel 2
switchport mode trunk
do wr
```
SWITCH-3
```shell
int ra fa0/3-4
shutdown
channel-group 2 mode on (?)
no sh
int port-channel 2
switchport mode trunk
do wr
```

Vérifier le fonctionnement de Port Channel 2
```shell
do sh eth sum
```

Définir S1 en pont racine Spanning-Tree
spanning-tree vlan 1 root primary 


<br>


-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------


<br>


# 📗 VTP 


Pour que les swiths récupèrent les infos vlans


Switch serveur

```shell
en
conf t
vtp mode server
vtp domain ?
vtp domain AIS.LAB
vtp domain password AIS
vtp version 2

vlan 10
name vlan10

VLAN 20
name vlan20
```

etc......



Switch client

```shell
en
conf t
vtp mode client
vtp domain AIS.LAB
vtp password AIS
```

Si un switch ne prend pas les VLANs avec le vtp faire un delete vlan.dat


-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------


<br>


# 🛣️ Routage Inter-VLANs


Switch client
```shell
int f0/1
sw mo ac
sw ac vl 10
sw voice vlan 40

int f0/2
sw mo ac
sw ac vl 20
sw voice vlan 40
do wr
```

Switch L3 serveur (Une SVI par vlan)
```shell
in vl 10
ip ad 10.10.0.1 255.255.255.0

in vl 20
ip ad 10.20.0.1 255.255.255.0

in vl 30
ip ad 10.30.0.1 255.255.255.0

in vl 40
ip ad 10.40.0.1 255.255.255.0

ip routing (pour switch L3)
```

-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------


<br>


# ⛔ Spanning Tree Protocol 


- Les trames du STP sont appelées BPDU (Bridge Protocol Data Unit) et sont envoyées aux autres switchs
- Ce protocole empêche les boucles de broadcast qui peuvent créer des tempêtes
- Il faut élire un "Pont Racine" (Switch maître)


Configuration du port racine
```shell
spanning-tree vlan 1,10,20,30,40 root primary
# ou
spanning-tree vlan 1 priority 24576 ( entre 0 et 61440 )
```

Vérifier
```shell
show spanning-tree
```

Config port fast
```shell
int f0/1
spanning-tree portfast (à faire sur les endpoints seulements) 
```

Configuration via la priorité
```shell
spanning-tree bpduguard enable
```



-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------


<br>


# 🙋‍♀️ DHCP 


Serveur DHCP
```shell
ip dhcp pool Client-VLAN110
network 10.10.0.0 255.255.255.0
dns-server 8.8.8.8
default routeur 10.10.0.1
```

Exclusion DHCP
```shell
ipdhcp excluded-address[1rst address] [last address]
```

Relais DHCP
```shell
int vl 10
ip helper-address 10.0.0.1 (adresse du DHCP...)
```



-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------


<br>


# 🏁 OSPF 


Protocole de routage dynamique
déclarer mask en wildcard (ici 255.255.255.252 = 0.0.0.3 ( /30 )



À déclarer sur chaque routeur d'une même zone (ou area 0 est une zone définie):
```shell
en
conf t
router ospf 1
network 192.168.35.0 0.0.0.255 area 0
network 192.168.36.0 0.0.0.255 area 0
network 192.168.37.0 0.0.0.255 area 0
network 192.168.38.0 0.0.0.255 area 0
do wr
```


Pour vérifier :
```shell
show ip ospf
show ip ospf neighbor
show ip route ospf
```


```shell
Passive-interface g0/0
```

Passive-interface : 
* Permet d'éviter du trafic OSPF inutile, à faire uniquement sur une interface de routeur non connectée directement à un routeur participant au processus OSPF
* Dans l'exemple du dessus si l'interface g0/0 est connectée à un LAN le traffic OSPF ne sera pas redistribué inutilement vers le LAN



Redistribution des routes OSPF vers BGP
```
router bgp 100
redistribute ospf 1
```

le `1` correspond à l'Id du process OSF souhaité



-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------



<br>


# 🚢 BGP  

AS = Autonomous System (forme un ensemble de routeurs pour un même AS)
Ce numéro identifie un réseau BGP.

Puis indiquer l'IP du routeur de l'autre coté et son as
Puis indiquer les réseau voisin du routeur


Routeur 1
```shell
router bgp 100 
neighbor 192.168.41.253 remote-as 300  
network 192.168.13.0 
network 192.168.15.0 
network 192.168.16.0
```


Routeur 2
```shell
router bgp 300 
neighbor 192.168.41.254 remote-as 100  
network 192.168.35.0 
network 192.168.38.0 
network 192.168.32.0
do wr
```


Pour vérifier :
```shell
show ip bgp 
```

Redistribution des routes BGP vers OSPF
```shell
router ospf 1
redistribute bgp 100 subnets
```



-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------


<br>


# ⤵️ NAT 


NAT DYNAIQUE AVEC SURCHARGE
```shell
ip nat outside
ip nat inside 
acecess-list 1 permit  172.16.0.128 0.0.0.15
ip nat inside source list 1 interface f0/1 overload
```

PORT FORWARDING (D-NAT)
```shell
ip nat outside
ip nat inside 
acces-list 2 permit tcp any any eq 80
ip nat inside source static tcp 192.168.10.1 80 9.9.9.34 80
```

Pour vérifier
```shell
show ip nat translation
```



-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------



<br>


# ⤴️ HSRP 

- Protocole de redondance et de clustering 
- Le HSRP permet de faire apparaitre pour l'utilisateur une seule passerelle alors qu'il y au moins deux routeurs (ou plus) qui servent de backup. La priorité la plus haute définit le routeur actif.

<br>

- hsrp → version cisco
- vrrp → version ouverte / stormshield
- carp → pfsense ?
- fgcp → Fortinet

<br>

- Active  → routeur qui gère le trafic (celui avec la plus haute priorité).
- Standby → routeur prêt à prendre le relais immédiatement si l’actif tombe.
- Listen  → les autres routeurs du groupe HSRP (s’il y en a plus de deux). Ils écoutent les messages HSRP mais ne sont ni actifs ni standby.

<br>

-  "preempt" permet de redevenir actif si le routeur reprend le dessus.



### Exemple pour 3 routeurs :


• Routeur 1 (actif pour LAN interne)
```shell
interface GigabitEthernet0/0/0
 ip address 172.30.128.1 255.255.255.0
 standby 1 ip 172.30.128.254
 standby 1 priority 120
 standby 1 preempt
 standby 1 description HSRP-LAN
 no shutdown
```

• Routeur 2 (standby)
```shell
interface GigabitEthernet0/0/0
 ip address 172.30.128.2 255.255.255.0
 standby 1 ip 172.30.128.254
 standby 1 priority 110
 standby 1 preempt
 standby 1 description HSRP-LAN
 no shutdown
```

• Routeur 3 (stanby / en écoute / backup)
```shell
interface GigabitEthernet0/0/0
 ip address 172.30.128.3 255.255.255.0
 standby 1 ip 172.30.128.254
 standby 1 priority 100
 standby 1 preempt
 standby 1 description HSRP-LAN
 no shutdown
```

Vérifier si HSRP est bien activé
```shell
show standby
show standby brief
```


-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------



<br>



# QoS



Lancer une connexion ftp
```shell
ftp 172.20.0.2 # (user : cisco, password : cisco)
```


Télécharger le fichier binaire
```shell
get c1841-advipservicesk9-mz.124-15.T1.bin
```

Vérifier une vitesse de transfert
```shell
show interfaces fa 0/1
```

### Déclarer les classes de flux
```shell
conf t
class-map match-all prio-sur-interface
match input-interface fa1/0
ex
```


Vérifier la déclaration de la classe
```shell
show class-map
```


### Déclarer une politique de QoS
```shell
conf t
policy-map ma-politique-qos
class prio-sur-interface
set ip dscp cs7
ex
ex
do wr
```

- Si la politique "ma-politique-qos" n'existait pas encore, elle est créée. Si elle existait, les commandes "class" vont la compléter 
- Une priorité sur champ DSCP est définie pour les paquets de la classe "prio-sur-interface" avec le code "cs7", équivalent à un DSCP de "111000" et donc une priorité haute de "7"


### Appliquer la politique de QoS sur une interface
```shell
conf t
in f0/1
service-policy output ma-politique-qos
ex
ex
do wr
```

Vérifier
```shell
show policy-map
```

vérifier priorisation en sortie d'interface fa0/1 a changé  (n'est plus en mode "FIFO", mais en mode "class-based queueing")
```shell
show interfaces fa0/1
```

<br>

* Débit relevé avant QoS
	* 5 minute input rate 1525 bits/sec, 36 packets/sec 
	* 5 minute output rate 493 bits/sec, 11 packets/sec
* Débit relevé après QoS
	*
	*

<br>

### __QoS en fonction du protocole__


### Déclaration de la classe de flux
```shell
class-map match-all prio-sur-ftp
match protocol ftp
```

### Elargissement de la politique de QoS
```shell
policy-map ma-politique-qos
class prio-sur-ftp
set ip dscp cs1
```


### Réserver 10% de la bande passante au trafic FTP
```shell
policy-map autre-politique
class prio-sur-ftp
bandwidth percent 10
```


<br>


### Liste des codes DSCP Cisco par défaut

| Code DSCP | Description                                             | Binaire |
|-----------|---------------------------------------------------------|---------|
| af11      | Match packets with AF11 dscp                            | 001010  |
| af12      | Match packets with AF12 dscp                            | 001100  |
| af13      | Match packets with AF13 dscp                            | 001110  |
| af21      | Match packets with AF21 dscp                            | 010010  |
| af22      | Match packets with AF22 dscp                            | 010100  |
| af23      | Match packets with AF23 dscp                            | 010110  |
| af31      | Match packets with AF31 dscp                            | 011010  |
| af32      | Match packets with AF32 dscp                            | 011100  |
| af33      | Match packets with AF33 dscp                            | 011110  |
| af41      | Match packets with AF41 dscp                            | 100010  |
| af42      | Match packets with AF42 dscp                            | 100100  |
| af43      | Match packets with AF43 dscp                            | 100110  |
| cs1       | Match packets with CS1 (precedence 1) dscp              | 001000  |
| cs2       | Match packets with CS2 (precedence 2) dscp              | 010000  |
| cs3       | Match packets with CS3 (precedence 3) dscp              | 011000  |
| cs4       | Match packets with CS4 (precedence 4) dscp              | 100000  |
| cs5       | Match packets with CS5 (precedence 5) dscp              | 101000  |
| cs6       | Match packets with CS6 (precedence 6) dscp              | 110000  |
| cs7       | Match packets with CS7 (precedence 7) dscp              | 111000  |
| default   | Match packets with default dscp                         | 000000  |
| ef        | Match packets with EF dscp                              | 101110  |



<br>

* Usage : `match [clause] [paramètre]`
* Exemple : `match protocol http`

<br>


### Clauses de classement de flux 

| Clause              | Description                                                                 |
|---------------------|------------------------------------------------------------------------------|
| access-group        | Flux correspondant à un ACL (depuis un réseau, une IP, vers un port applicatif, etc.) |
| any                 | Tous les paquets                                                             |
| class-map           | Flux appartenant déjà à une certaine autre classe                             |
| cos                 | Flux doté d'un certain champ CoS IEEE 802.1Q                                 |
| destination-address | Flux avec une certaine adresse MAC de destination                            |
| input-interface     | Flux entré par une certaine interface                                        |
| ip                  | Flux doté d'une certaine adresse IP                                          |
| precedence          | Flux doté d'une certaine précédence (champ sur 3 bits) en IPv4 et IPv6       |
| protocol            | Flux correspondant à un protocole donné                                      |
| qos-group           | Flux appartenant à un certain groupe de QoS (de 0 à 1023)                    |


<br>

- Évite la latence, la congestion
- voip, rdp, appli métier, stockage et save par réseau, smb, visio, mises à jour
- Outils de benchmark de capacité de charge réseau
- Outils de répartitions des ≠ flux utilisés (extension de supervision, sflow,  netflow...) È


-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------



<br>


#  🔧 Commandes de réinitialisation


Mode usine switch/routeur:
```shell
erase startup-config
```

Mode usine switch/routeur: (ne sais pas la différence)
```shell
write erase
```

Réinitialiser une interface:
```shell
default int gi 0/1
```

Supprimmer un VLAN
```shell
no vlan 10
```

Supprimer toutes les VLANs
```shell
delete vlan.dat
```

Supprimer adresse interface
```shell
in g0/0
no ip address
```

Supprimer une route
```shell
no ip route 192.168.11.0 255.255.255.0 209.165.200.225
```

Supprimer toutes les routes (⚠️Static et dynamique)
```shell
clear ip route * fonctionne pas...
```

Pour supprimer complètement le STP il faut le supprimer sur tout les VLANs (même le VLAN 1)

Désactiver STP sur tout le switch
```shell
no spanning-tree mode 
```

Désactiver STP sur un VLAN
```shell
no spanning-tree vlan <ID_VLAN>
```

désactiver un port channel
```shell
no int po 2
```



<br>


-----------------------------------------------------------------------------------------------
Trunk couche de nv 2
Routage couche de nv3