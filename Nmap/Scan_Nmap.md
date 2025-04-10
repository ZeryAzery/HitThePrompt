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
### Rapport et analyse : Consolider les données collectées, identifier les vulnérabilités exploitables en fonction de leurs criticités et recommander les mesures correctives. 

======================================================================================================

## Scan SYN (demi-ouvert ou half-open scan)
```nmap
	nmap -sS -sV -O -p 1-1000 10.0.0.5
```
### Explications du scan SYN

* sS :		Scan SYN (demi-ouvert), typique des scans furtifs mais que Suricata détecte bien.
* sV :		Détection de version des services, ce qui génère plus de trafic identifiable.
* O :		Détection du système d'exploitation via fingerprinting.
* p 1-1000 :	Scanne les 1000 premiers ports, souvent surveillés par Suricata.

### Comment Nmap effectue ses requête SYN aux ports de la cible :

| État     | Description |
|----------|-------------|
| SYN      | → Nmap envoie un paquet avec le flag SYN. |
| SYN-ACK  | → Si le port est ouvert, la cible répond avec SYN-ACK. |
| RST      | → Nmap envoie un RST (Reset) au lieu d’un ACK. |

➡️ Ça permet de détecter les ports ouverts sans établir une connexion complète, donc c’est plus furtif qu’un TCP connect scan (-sT), qui fait une vraie connexion (SYN → SYN-ACK → ACK).

## Autres options 
-A (Aggressive Scan, récolte des infos sur la cible)

* Détection du système d’exploitation (OS Detection)
* Détection des services (Version Detection)
* Traceroute (pour voir le chemin réseau jusqu'à la cible)
* Scripts Nmap (NSE) par défaut, qui explorent certaines vulnérabilités

➡️ En gros, -A combine plusieurs scans avancés pour donner un max d’infos sur la machine scannée.

-----------------------------------------------------------------------------------------------------


