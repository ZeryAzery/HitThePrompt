# WIRESHARK 

> [!IMPORTANT]  
> Les filtres de captures ne doivent pas être confondus avec les filtres d'affichage
 
## Filtres de captures

|        Quoi ?               |       Filtre à appliquer       |
|-----------------------------|----------------------------------|
|        Port filter          |          tcp port 443              |
| Filtrer un flux TCP/IP       |     frame matches "nfl"           |
|          dhcp               |        dhcp                    |
|          dns                  |           dns                  |
|      Filtrer entre 2 IPs      | host 10.0.0.1 and host 10.0.0.3   |
|         TLS Handshake       |           tls.handshake          | 
|       Filtrer rdp           |            rdp               |
 
---

## Filtres d'affichage

|        Quoi ?               |       Filtre à appliquer       |
|-----------------------------|----------------------------------|
|     Filtrer un réseau	       |    ip.addr == 192.168.50.0/24   |
|  Conversation to or from     |     ip.addr == 10.0.0.1           |
|          Port filter         |         tcp.port == 80            |
| Filtrer DHCP DORA            | udp.port == 67 || udp.port == 68  |
|         Filtrer kerberos    |  ip.addr == 10.0.0.50 and kerberos  | 
| Entre workstation et serveur | ip.src==192.168.0.0/16 and ip.dst==192.168.0.0/16 |
| filtrer sur un seul port    |          tcp.dstport == 445         |    

* __Il est possible d'utiliser différents filtres à la fois comme ceci :__
```wireshark
ip.addr ==10.0.0.3  || tcp.port == 80
```