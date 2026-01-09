# NMAP



Version d'nmap
```nmap
nmap --version
```


Machines active sur le réseau
```nmap
nmap -sn <Plage IP> 
```


Version d'un système cible
```nmap 
nmap -O <Ip cible>
```	


Range de ports ouverts sur les hôtes actifs (potentiels services)
```nmap
nmap -sS -p 1-65535 <IP cible>
```


Services et applications 
```nmap
nmap -sV <IP cible>
```


Versions et vulnérabilités connues
```nmap
nmap -sV --script vuln <IP cible>
```


Topologie réseau (parefeu, routeurs et segmentation)
```nmap
nmap -sn --traceroute <IP cible>
```


Extraire des infos de partage réseau
```nmap
nmap --script=smb-enum-shares -p 445 <Ip cible>
```


---

<br>

Rapport et analyse : Consolider les données collectées, identifier les vulnérabilités exploitables et leurs criticités. 


Générer un fichier au format txt (`-oN` → « Output Normal » suivi du nom du fichier)
```
-oN resultat_scan.txt
```

---


<br>



Scan SYN (demi-ouvert ou half-open scan)
```nmap
nmap -sS -sV -O -p 1-1000 10.0.0.5
```
```nmap
nmap -sS -p 1-65535 <IP_du_serveur> -Pn -T4
```

* `-sT`: scan TCP complet 
* `-sS` : Scan SYN, plus rapide et discret que -sT . Nécessite les privilèges root.
* `sV` : Détection de version des services, ce qui génère plus de trafic identifiable.
* `-O` :	Détection du système d'exploitation via fingerprinting.
* `-p 1-1000` : Scanne les 1000 premiers ports
* `-Pn` : Ne fait pas de ping (ignore la détection d’hôte). Utile si la cible ne répond pas aux pings ICMP.


<br>

```nmap
sudo nmap -A -p 3000 -T4 <IP>
```

`-A` → Aggressive Scan, récolte un maximum d'infos sur la cible :

* Système d’exploitation (OS Detection)
* Services (Version Detection)
* Traceroute (pour voir le chemin réseau jusqu'à la cible)
* Scripts Nmap (NSE) par défaut, qui explorent certaines vulnérabilités




<br>


### Comment Nmap effectue ses requête SYN aux ports de la cible :

| État     | Description |
|----------|-------------|
| SYN      | → Nmap envoie un paquet avec le flag SYN. |
| SYN-ACK  | → Si le port est ouvert, la cible répond avec SYN-ACK. |
| RST      | → Nmap envoie un RST (Reset) au lieu d’un ACK. |

Ça permet de détecter les ports ouverts sans établir une connexion complète, donc c’est plus furtif qu’un TCP connect scan (`-sT`), qui fait une vraie connexion (SYN → SYN-ACK → ACK).

<br>





---






### `-T` → "Timing Template"

| Option | Nom | Description | 
|------- |---- |------------ |
| -T0 | Paranoid | Très lent, utilisé pour l’évasion (ex : IDS/IPS). |
| -T1 | Sneaky | Très lent aussi, pour rester discret. |
| -T2 | Polite | Un peu plus rapide, mais toujours lent. |
| -T3 | Normal | Valeur par défaut. |
| -T4 | Aggressive | Beaucoup plus rapide, bon compromis pour les scans de prod. |
| -T5 | Insane | Ultra rapide, mais risque de rater des infos (et d’être détecté). |

Plus la valeur est haute, plus les le délais est réduit entre les paquets envoyés et plus le nombre de connexions simultanées augmentent



