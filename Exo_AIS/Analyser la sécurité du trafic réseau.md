# Analyser la sécurité du trafic réseau

## Rappels
Quelle est votre adresse IP ? Quelle est sa classe (IPv4) ?
10.0.0.1 > Ip privée (Classe A)
Quel est votre masque de sous-réseau ?
255.255.255.0
Quelle est l'adresse de votre passerelle ?
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

### 🧠 Exemples pratiques :
* __Connexion TCP (3-way handshake) :__

- Client → Serveur : SYN
- Serveur → Client : SYN-ACK
- Client → Serveur : ACK

* __Fin de connexion :__

- Un côté envoie un FIN, l'autre répond avec ACK, puis renvoie aussi un FIN, et le premier répond avec ACK.

## Capturer le processus DORA du protocole DHCP

Pour capturer DORA, j'ai utilisé le filtre "udp.port == 67 || udp.port == 68"
![alt text](<capture_DORA.png>)
## Qu’est ce que le DHCP Starvation / snooping ? Rogue DHCP ?
## Que ce passe lors du « ipconfig /release » (windows) ? D’un point de vue sécurité quel peut etre l'enjeu ?
## Quelle fonctionnalité propose CISCO pour se prémunir des attaques DHCP ?
## Capturer une requête DNS et sa réponse
## Qu’est-ce que le DNS Spoofing ? Comment s’en protéger ?
## Qu’est-ce que DNS Sec ? DNS over TLS / HTTPS ?
## Dans quels cas trouve-t-on du DNS sur TCP ?
## Capturer un flux HTTP
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