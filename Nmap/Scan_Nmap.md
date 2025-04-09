# NMAP

1) Identie les machines active sur le réseau (Host Discovery)
```nmap
    nmap -sn <Plage IP> 
```
2) Détecter les ports ouverts sur les hôtes actifs (identie donc de potentiels services)
```nmap
	nmap -sS -p 1-65535 <IP cible>
```
3) Détecter les services (services et applications en cours d'exécution sur les ports ouverts)
```nmap
	nmap -sV <IP cible>
```
4) Identifier les versions et vulnérabilités (tente de découvrir les vulnérabilité connues
```nmap
	nmap -sV --script vuln <IP cible>
```
5) Tenter de comprendre la topologie réseau (parefeu, routeurs et segmentation)
```nmap
	nmap -sn --traceroute <IP cible>
```
6) Extraire des informations détaillées sur les services, utilisateurs, partage réseau...
```nmap
	nmap --script=smb-enum-shares -p 445 <Ip cible>
```
7) Rapport et analyse : Consolider les données collectées, identifier les vulnérabilités exploitables
   en fonction de leurs criticités et recommander les mesures correctives. 


-----------------------------------------------------------------------------------------------------

Pour tester les logs produits par Suricata dans le fichier eve.json (pendant le scan),
j'utilise tail -f /var/log/suricata/eve.json sur la machine Suricata,
et je fais un scan d'une autre machine (ici un windows en 192.168.20.100)

```nmap
	nmap -sS -sV -O -p 1-1000 10.0.0.5
```

-sS : Scan SYN (demi-ouvert), typique des scans furtifs mais que Suricata détecte bien.
Aussi appelé half-open scan. Il fonctionne en envoyant une requête SYN aux ports de la cible :

SYN → Nmap envoie un paquet avec le flag SYN.

SYN-ACK → Si le port est ouvert, la cible répond avec SYN-ACK.

RST → Nmap envoie un RST (Reset) au lieu d’un ACK, pour ne pas établir complètement la connexion.

➡️ Ça permet de détecter les ports ouverts sans établir une connexion complète, donc c’est plus furtif qu’un TCP connect scan (-sT), qui fait une vraie connexion (SYN → SYN-ACK → ACK).


-sV : 		Détection de version des services, ce qui génère plus de trafic identifiable.
-O : 		Détection du système d'exploitation via fingerprinting.
-p 1-1000 :	Scanne les 1000 premiers ports, souvent surveillés par Suricata.

-A (Aggressive Scan, récolte des infos sur la cible)

✔ Détection du système d’exploitation (OS Detection)
✔ Détection des services (Version Detection)
✔ Traceroute (pour voir le chemin réseau jusqu'à la cible)
✔ Scripts Nmap (NSE) par défaut, qui explorent certaines vulnérabilités

➡️ En gros, -A combine plusieurs scans avancés pour donner un max d’infos sur la machine scannée.

-----------------------------------------------------------------------------------------------------

Vérifier la version d'nmap
	nmap --version

Connaitre la version d'un système cible 
	nmap -O <Ip cible>


