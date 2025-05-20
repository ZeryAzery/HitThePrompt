# WIRESHARK 

## FILTRES PCAP 

|        Quoi ?               |       Filtre à appliquer       |
|-----------------------------|----------------------------------|
|     Filtrer un réseau	       |    ip.addr == 192.168.50.0/24   |
|  Conversation to or from     |     ip.addr == 10.0.0.1           |
|          Port filter         |         tcp.port == 80            |
| Filtrer un flux TCP/IP       |     frame matches "nfl"           |
| Filtrer DHCP DORA            | udp.port == 67 || udp.port == 68
|          dhcp               |        dhcp                    |
|          dns                  |           dns                  |
| Filtrer entre 2 IPs          | host 10.0.0.1 and host 10.0.0.3   |


---

* __Il est possible d'utiliser différents filtres à la fois comme ceci :__
```wireshark
ip.addr ==10.0.0.3  || tcp.port == 80
```