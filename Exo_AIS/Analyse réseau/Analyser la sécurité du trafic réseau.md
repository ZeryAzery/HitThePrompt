# Analyser la sécurité du trafic réseau

## Rappels
* Quelle est votre adresse IP ? Quelle est sa classe (IPv4) ?
10.0.0.1 > Ip privée (Classe A)
* Quel est votre masque de sous-réseau ?
255.255.255.0
* Quelle est l'adresse de votre passerelle ?
10.0.0.254

## Quels sont les flags TCP ?
| Flag    | Nom complet               | Description                                                                |
| ------- | ------------------------- | -------------------------------------------------------------------------- |
| **SYN** | Synchronize               | Démarre une connexion TCP (étape 1 et 2 du 3-way handshake).               |
| **ACK** | Acknowledgment            | Accuse réception d’un paquet précédent.                                    |
| **FIN** | Finish                    | Demande la terminaison d’une connexion TCP.                                |
| **RST** | Reset                     | Réinitialise une connexion TCP (souvent en cas d’erreur ou de rejet).      |
| **PSH** | Push                      | Demande un envoi immédiat des données au niveau de l’application.          |
| **URG** | Urgent                    | Indique que certaines données sont urgentes et doivent être traitées vite. |
| **ECE** | ECN Echo                  | Utilisé pour la notification de congestion (ECN).                          |
| **CWR** | Congestion Window Reduced | Indique une réduction de la fenêtre de congestion.                         |
| **NS**  | Nonce Sum                 | Utilisé avec ECN pour plus de sécurité (très rarement utilisé).            |

### Exemples

 __Connexion TCP (3-way handshake) :__

- Client → Serveur : SYN
- Serveur → Client : SYN-ACK
- Client → Serveur : ACK

 __Fin de connexion :__

- Un côté envoie un FIN, l'autre répond avec ACK, puis renvoie aussi un FIN, et le premier répond avec ACK.


## Capturer le processus DORA du protocole DHCP
Pour capturer DORA, j'ai choisi le filtre Wireshark "udp.port == 67 || udp.port == 68"

![alt text](<capture_DORA.png>)

Il me manque le Deliver et le Offer car il connait déjà la MAC du PC ciblé.



## Qu’est ce que le DHCP Starvation / snooping ? Rogue DHCP ?

* Sécurité DHCP : Attaques et Défenses

### DHCP Starvation
Le but de cette attaque est d'épuiser toutes les adresses IP disponibles sur le serveur DHCP.
Un attaquant envoie des requêtes DHCP en masse avec des IPs aléatoires.
Le résultat est que les machines ne reçoivent plus d'adresses IP et créé un DoS (Denial of Service)


### Rogue DHCP

L'attaque "Rogue DHCP" consiste à installer un **faux serveur DHCP** sur le réseau,
L'attaquant répond en général plus vite que le serveur DHCP d'origine et délivre des informations différentes (IP, passerelle, DNS)
L'attaquant peut donc contrôler ou intercepter le trafic réseau, faire des redirection vers des serveurs malveillants (C2),
permet également de faire des attaques de type **Man-in-the-Middle (MitM)**.


### DHCP Snooping

Le DHCP Snooping est une technologie de sécurité de couche 2 et permet de protéger le réseau contre les attaques DHCP (Rogue DHCP, DHCP Starvation).
Le Snooping se fait principalement au niveau du switch avec la gestion des ports :
  - Le switch identifie les ports **de confiance (trusted)** (vers le vrai serveur DHCP).
  - Les autres ports sont **non-trusted** (vers les clients).
  - Les messages DHCP suspects sont bloqués sur les ports non-trusted.
Celà empêche les réponses de faux serveurs DHCP et crée une base IP ↔ MAC ↔ port qui est aussi utile contre d'autres attaques (ex : ARP spoofing).

## Que se passe t-il lors du « ipconfig /release » (windows) ? D’un point de vue sécurité quel peut etre l'enjeu ?

Le risque, au delà de la perte de connectivité est qu'un attaquant puis l'exploiter par les méthodes vues précedemment.

## Quelle fonctionnalité propose CISCO pour se prémunir des attaques DHCP ?

Le protocole s'appelle "DAI" Dynamic ARP Inspection comme vu avant il permet de bloquer des ports ou des VLANs entier.

## Capturer une requête DNS et sa réponse

Utiliser simplement le filtre "dns" pour voir les requêtes

![alt text](<DNS_Query.png>)


## Qu’est-ce que le DNS Spoofing ? Comment s’en protéger ?

L'empoisonnement DNS est une attaque où un l'attaquant falsifie les réponses d’un serveur DNS pour rediriger un utilisateur vers un faux site web, tout en lui faisant croire qu’il accède au site légitime. Cela permet de voler des données sensibles ou d’infecter l’utilisateur avec un malware.
Pour s'en protéger on peut  :
- Utiliser le protocole DNSSEC (ajoute une signature numérique aux réponses DNS)
- Utiliser des serveurs DNS fiable (ex. : Cloudflare, Google DNS qui intègrent des mécanismes de validation).
- Utiliser DNS-over-HTTPS (DoH) ou DNS-over-TLS (DoT) pour empêcher l’interception et la modification des requêtes.
- Mettre à jour régulièrement les systèmes pour corriger les failles de sécurité des OS et des logiciels réseau.
- Éffectuer un filtrage réseau et pare-feu pour Bloquer les communications DNS suspectes ou non autorisées.
- Utiliser un SIEM ou NIDS pour surveiller le réseau et détecter des comportements anormaux.

## Qu’est-ce que DNS Sec ? DNS over TLS / HTTPS ?

DNSSEC ajoute une signature numérique aux réponses DNS et DNS over TLS permet d'ajouter une couche de chiffrement.

## Dans quels cas trouve-t-on du DNS sur TCP ?

Le DNS utilise principalement UDP sur le port 53, car les requêtes sont en général petites et rapides.

Voici les cas où DNS peut utiliser TCP :
- Si la réponse est trop volumineuse pour UDP (dépasse 512 octets ou 1232 avec EDNS0), le serveur force l’usage de TCP pour renvoyer la réponse complète.
- Certains serveurs DNS peuvent forcer l’usage de TCP pour limiter les attaques par amplification via UDP.
- Lors de transferts de zones entre serveurs DNS (surtout AXFR) TCP  est obligatoirement utilisé pour garantir la fiabilité de la transmission.
- Lors de requêtes récursives complexes, certains résolveurs peuvent basculer en TCP si la requête ou la chaîne de résolution est trop complexe.

## Capturer un flux HTTP

Pour capturer un flux HTTP j'utilise le filtre "tcp.port == 80"

![alt text](<Flux_HTTP.png>)

* __Il est possible d'utiliser différents filtres à la fois comme ceci :__
```wireshark
ip.addr == 10.0.0.3  || tcp.port == 80
```

## Qu’est-ce que le HTTP Smuggling ? Donner un exemple de CVE
## Comment mettre en place la confidentialité et l'authenticité pour HTTP ?
## Qu’est-ce qu’une PKI ?
## Capturer un mot de passe HTTP ou FTP ou Telnet (mettre en place les services si nécessaire)
## Comment mettre en place la confidentialité pour ce service ?
## Capturer un handshake TLS
## Qu’est-ce qu’une autorité de certification (AC) racine ? Qu'est qu'une AC intermediaire ?
## Connectez-vous sur https://taisen.fr et affichez la chaine de confiance du certificat
## Capturer une authentification Kerberos (mettre en place le service si nécessaire)
## Capturer une authentification RDP (mettre en place le service si nécessaire)
## Quelles sont les attaques connues sur NetLM ?
## Capturer une authentification WinRM (Vous pouvez utiliser EvilWinRM si nécessaire côté client.)
## Capturer une authentification SSH ou SFTP (mettre en place le service si nécessaire)
## Intercepter un fichier au travers du protocole SMB
## Comment proteger l'authenticité et la confidentialité d'un partage SMB ?