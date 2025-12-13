# __RETROUVER DES INCIDENTS DANS UN SIEM__

Ce brief consiste à retrouver dans un SIEM les logs des vulnérabilités exploitées dans [le module pentest](https://github.com/ZeryAzery/HitThePrompt/blob/main/Exo_AIS/Pentest/Pentest_Web.md)

<br>

![alt text](<splunk.png>)

Sur Splunk il est possible d'ajouter directement un fichier de log

![alt text](<ajoutdonnées.png>)

<br>

Pour retrouver des attaques dans Splunk, on peut utiliser cette requête Splunk
```s
source="2025-12-11_logfile.json" host="8b1e2fd8c559" sourcetype="_json"
(
    "' OR '1'='1"
    OR "appsettings.json"
    OR "/etc/passwd"
    OR "simplon.co;id"
)
```

![alt text](<Splunk_Request_Pattern.png>)

<br>

Cette recherche me permet de retrouver presque la plupart des attaques, mais dans un contexte de détection d'incidents réel un analyste SOC pourrait ne pas procéder comme ça. Car c'est admettre que le défenseur sait déjà ce que l'attaquant à utilisé.

<br>

Par exemple pour retrouver une possible utilisation de LFI + Path Traversal, on peut prendre le paramètre 'lang' et puis appliquer une regex en tant qu'argument de recherche :
```s
source="2025-12-12_logfile.json" host="8b1e2fd8c559" sourcetype="_json" | regex message="lang=([a-zA-Z0-9_.-]+|(\.\./)+[a-zA-Z0-9_.-]+)"
```

* Cette regex permet par exemple de détecter ce genre de cas :
    * lang=appsettings.json
    * lang=config.php
    * lang=../../etc/passwd
    * lang=../appsettings.json
    * lang=../../windows/win.ini
    * lang=../../../../../etc/shadow


### Log de l'injection SQL

![alt text](<SQLi_Splunk_Log.png>)

<br>


### Log de la LFI
```s
source="2025-12-12_logfile.json" host="8b1e2fd8c559" sourcetype="_json" | search message="*lang=*"
```

![alt text](<Log_LFI.png>)

<br>


### Log du Path Traversal

![alt text](<PathTraversal_Splunk_Log.png>)

<br>

### Log de la RCE

![alt text](<RCE_Splunk_Log.png>)



### Log de la XSS

```s
source="2025-12-11_logfile.json" host="8b1e2fd8c559" sourcetype="_json" | regex message="on[a-z]+=alert"
```
```s
source="2025-12-11_logfile.json" host="8b1e2fd8c559" sourcetype="_json" | regex message="<marquee"
```

![alt text](<Log_XSS.png>)