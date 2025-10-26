# NMAP



## Vérifier la version d'nmap
```nmap
	nmap --version
```


## Identie les machines active sur le réseau (Host Discovery)
```nmap
	nmap -sn <Plage IP> 
```


## Connaitre la version d'un système cible
```nmap 
	nmap -O <Ip cible>
```	


## Détecter les ports ouverts sur les hôtes actifs (potentiels services)
```nmap
	nmap -sS -p 1-65535 <IP cible>
```


## Détecter les services et applications en cours d'exécution sur les ports ouverts
```nmap
	nmap -sV <IP cible>
```


## Identifier les versions et vulnérabilités connues
```nmap
	nmap -sV --script vuln <IP cible>
```


## Tenter de comprendre la topologie réseau (parefeu, routeurs et segmentation)
```nmap
	nmap -sn --traceroute <IP cible>
```


## Extraire des informations détaillées sur les services, utilisateurs, partage réseau...
```nmap
	nmap --script=smb-enum-shares -p 445 <Ip cible>
```


* Rapport et analyse : Consolider les données collectées, identifier les vulnérabilités exploitables en fonction de leurs criticités et recommander les mesures correctives. 




---




## Scan SYN (demi-ouvert ou half-open scan)
```nmap
	nmap -sS -sV -O -p 1-1000 10.0.0.5
```



### Explications du scan SYN

* sS :		Scan SYN (demi-ouvert), typique des scans furtifs mais que Suricata détecte bien.
* sV :		Détection de version des services, ce qui génère plus de trafic identifiable.
* O :		Détection du système d'exploitation via fingerprinting.
* p 1-1000 :	Scanne les 1000 premiers ports, souvent surveillés par Suricata.



### ➡️ Comment Nmap effectue ses requête SYN aux ports de la cible :

| État     | Description |
|----------|-------------|
| SYN      | → Nmap envoie un paquet avec le flag SYN. |
| SYN-ACK  | → Si le port est ouvert, la cible répond avec SYN-ACK. |
| RST      | → Nmap envoie un RST (Reset) au lieu d’un ACK. |

Ça permet de détecter les ports ouverts sans établir une connexion complète, donc c’est plus furtif qu’un TCP connect scan (-sT), qui fait une vraie connexion (SYN → SYN-ACK → ACK).



## Autres options 
-A (Aggressive Scan, récolte des infos sur la cible)

* Détection du système d’exploitation (OS Detection)
* Détection des services (Version Detection)
* Traceroute (pour voir le chemin réseau jusqu'à la cible)
* Scripts Nmap (NSE) par défaut, qui explorent certaines vulnérabilités

Le -A combine plusieurs scans avancés pour donner un maximum d’infos sur la machine scannée.


---



```nmap
nmap -sS -p 1-65535 <IP_du_serveur> -Pn -T4
```

-sS : Scan SYN, plus rapide et discret qu'un scan TCP complet (-sT). Nécessite les privilèges root.
-Pn : Ne pas faire de ping (ignore la détection d’hôte). Utile si la cible ne répond pas aux pings ICMP.


### 🎯 -T signifie "Timing Template"

| Option | Nom | Description | 
|------- |---- |------------ |
| -T0 | Paranoid | Très lent, utilisé pour l’évasion (ex : IDS/IPS). |
| -T1 | Sneaky | Très lent aussi, pour rester discret. |
| -T2 | Polite | Un peu plus rapide, mais toujours lent. |
| -T3 | Normal | Valeur par défaut. |
| -T4 | Aggressive | Beaucoup plus rapide, bon compromis pour les scans de prod. |
| -T5 | Insane | Ultra rapide, mais risque de rater des infos (et d’être détecté). |

Plus la valeur est haute, plus les le délais est réduit entre les paquets envoyés et plus le nombre de connexions simultanées augmentent

* Cette option après la commande permet de générer un fichier au format txt (-oN → « Output Normal » suivi du nom du fichier)
-oN resultat_scan.txt


