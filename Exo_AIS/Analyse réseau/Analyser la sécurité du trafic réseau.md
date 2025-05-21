# Analyser la sécurité du trafic réseau

## Rappels
* Quelle est votre adresse IP ? Quelle est sa classe (IPv4) ?
10.0.0.1 > Ip privée (Classe A)
* Quel est votre masque de sous-réseau ?
255.255.255.0
* Quelle est l'adresse de votre passerelle ?
10.0.0.254

## __0. Quels sont les flags TCP ?__
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


## __1. Capturer le processus DORA du protocole DHCP__
Pour capturer DORA, j'ai choisi le filtre Wireshark "udp.port == 67 || udp.port == 68"

![alt text](<capture_DORA.png>)

Il me manque le Deliver et le Offer car il connait déjà la MAC du PC ciblé.



## __2. Qu’est ce que le DHCP Starvation / snooping ? Rogue DHCP ?__

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

## __3. Que se passe t-il lors du « ipconfig /release » (windows) ? D’un point de vue sécurité quel peut etre l'enjeu ?__

Le risque, au delà de la perte de connectivité est qu'un attaquant puis l'exploiter par les méthodes vues précedemment.

## __4. Quelle fonctionnalité propose CISCO pour se prémunir des attaques DHCP ?__

Le protocole s'appelle "DAI" Dynamic ARP Inspection comme vu avant il permet de bloquer des ports ou des VLANs entier.

## __5. Capturer une requête DNS et sa réponse__

Utiliser simplement le filtre "dns" pour voir les requêtes

![alt text](<DNS_Query.png>)


## __6. Qu’est-ce que le DNS Spoofing ? Comment s’en protéger ?__

L'empoisonnement DNS est une attaque où un l'attaquant falsifie les réponses d’un serveur DNS pour rediriger un utilisateur vers un faux site web, tout en lui faisant croire qu’il accède au site légitime. Cela permet de voler des données sensibles ou d’infecter l’utilisateur avec un malware.
Pour s'en protéger on peut  :
- Utiliser le protocole DNSSEC (ajoute une signature numérique aux réponses DNS)
- Utiliser des serveurs DNS fiable (ex. : Cloudflare, Google DNS qui intègrent des mécanismes de validation).
- Utiliser DNS-over-HTTPS (DoH) ou DNS-over-TLS (DoT) pour empêcher l’interception et la modification des requêtes.
- Mettre à jour régulièrement les systèmes pour corriger les failles de sécurité des OS et des logiciels réseau.
- Éffectuer un filtrage réseau et pare-feu pour Bloquer les communications DNS suspectes ou non autorisées.
- Utiliser un SIEM ou NIDS pour surveiller le réseau et détecter des comportements anormaux.

## __7. Qu’est-ce que DNS Sec ? DNS over TLS / HTTPS ?__

DNSSEC ajoute une signature numérique aux réponses DNS et DNS over TLS permet d'ajouter une couche de chiffrement.

## __8. Dans quels cas trouve-t-on du DNS sur TCP ?__

Le DNS utilise principalement UDP sur le port 53, car les requêtes sont en général petites et rapides.

Voici les cas où DNS peut utiliser TCP :
- Si la réponse est trop volumineuse pour UDP (dépasse 512 octets ou 1232 avec EDNS0), le serveur force l’usage de TCP pour renvoyer la réponse complète.
- Certains serveurs DNS peuvent forcer l’usage de TCP pour limiter les attaques par amplification via UDP.
- Lors de transferts de zones entre serveurs DNS (surtout AXFR) TCP  est obligatoirement utilisé pour garantir la fiabilité de la transmission.
- Lors de requêtes récursives complexes, certains résolveurs peuvent basculer en TCP si la requête ou la chaîne de résolution est trop complexe.

## __9. Capturer un flux HTTP__

Pour capturer un flux HTTP j'utilise le filtre "tcp.port == 80"

![alt text](<Flux_HTTP.png>)

* __Il est possible d'utiliser différents filtres à la fois comme ceci :__
```wireshark
ip.addr == 10.0.0.3  || tcp.port == 80
```

## __10. Qu’est-ce que le HTTP Smuggling ? Donner un exemple de CVE__

Le HTTP request smuggling est une vulnérabilité qui permet à un attaquant de manipuler les requêtes échangées entre un client et un serveur intermédiaire, souvent un proxy ou un load balancer en exploitant les incohérences dans le traitement des requêtes HTTP.
Ça permet de :
- d’injecter des requêtes malveillantes
- de contourner des contrôles de sécurité
- de voler des sessions ou de faire du cache poisoning.

La CVE-2025-4600 utilisait le smuggling request dans la QoS Google Cloud Classic en raison d'une gestion incorrecte des requêtes HTTP d'encodage en blocs.

## __11. Comment mettre en place la confidentialité et l'authenticité pour HTTP ?__

## __12. Qu’est-ce qu’une PKI ?__

Une "Public Key Infrastructure" (infrastructure à clé publique), consiste en une paire de clés (publique et privée). 
Elle permet de gérer des certificats numériques en garantissant la sécurité des échanges via le chiffrement asymétrique.
Voici ces principaux composants :
- __Autorité de certification (CA)__ : Délivre et signe les certificats numériques.
- __Autorité d'enregistrement (RA)__ : Vérifie l’identité des entités avant que la CA délivre un certificat.
- __Certificat numérique__           : Fichier contenant une clé publique + l’identité du propriétaire, signé par une CA.
- __Liste de révocation (CRL) / OCSP__ :   Permet de vérifier si un certificat est encore valide ou a été révoqué.

Les PKI sont courament utilisées avec le HTTPS (certificats SSL/TLS), Authentification (cartes à puce, certificats utilisateurs),
Signature électronique, VPN, messagerie sécurisée, etc.

## __13. Capturer un mot de passe HTTP ou FTP ou Telnet (mettre en place les services si nécessaire)__

Trouver la rquête POST et aller dans "HTML Form URL Encoded: application/x-www-form-urlencoded"
Puis rechercher la mention "Form item" 4 et 5; Ici une authentification avec l'identifiant et le mdp "glpi" :

![alt text](<capture_Mdp_HTTP.png>)

Suivre Flux HTTP![alt text](<Suivre Flux HTTP.png>)

## __14. Comment mettre en place la confidentialité pour ce service ?__
## __15. Capturer un handshake TLS__
## __16. Qu’est-ce qu’une autorité de certification (AC) racine ? Qu'est qu'une AC intermediaire ?__
## __17. Connectez-vous sur https://taisen.fr et affichez la chaine de confiance du certificat__
## __18. Capturer une authentification Kerberos (mettre en place le service si nécessaire)__
## __19. Capturer une authentification RDP (mettre en place le service si nécessaire)__
## __20. Quelles sont les attaques connues sur NetLM ?__
## __21. Capturer une authentification WinRM (Vous pouvez utiliser EvilWinRM si nécessaire côté client.)__
## __22. Capturer une authentification SSH ou SFTP (mettre en place le service si nécessaire)__
## __23. Intercepter un fichier au travers du protocole SMB__
## __24. Comment proteger l'authenticité et la confidentialité d'un partage SMB ?__

