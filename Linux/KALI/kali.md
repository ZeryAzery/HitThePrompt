<h1 align="center">KALI LINUX</h1>

### Vérifier quel shell est utilisé
```sh
echo $0
```


### Modifier le fichier history

```sh
sudo nano $HOME/.zsh_history
```

### Rechercher dans le fichier history
```sh
sudo cat $HOME/.zsh_history | grep kerbrute
```


### Afficher les 20 dernières ligne du fichier .zsh_history
```sh
sudo tail -n 20 .zsh_history
```


### clear l'history
```sh
fc -c

# ou si fonctionne pas
: >~/.zsh_history\n

# actualiser pour que ça prenne effet
exec zsh
```



---

<br>




### Fixer l'autocomplétion pour les chemins des dossier/fichiers

→ si message `(eval):1: _python-argcomplete: function definition file not found`

```sh
sudo activate-global-python-argcomplete
exec zsh
```


### Désactiver l'autocomplétion pour les anciennes commandes

```sh
sudo nano -c $HOME/.zshrc
```
Commenter la partie du fichier  (ligne 248 àce moment): "# enable auto-suggestions based on the history"

![](img/fix.png)


Puis actualiser avec:
```sh
exec zsh
```



---

<br>




### Dézippé un fichier dans un dossier (créé le dossier si inexistant)
```sh
sudo unzip 20260108151307_BloodHound.zip -d BH_extract
```


### Vider un fichier
```sh
: > krbhash_bernie_pate.txt
```


### Copier un fichier de Linux vers Windows
```sh
scp -P 1111 administrateur@10.0.0.1:/C:/Users/Administrateur/Desktop/20260108151307_BloodHound.zip .
```


### Copier un dossier de Linux vers windows
```sh
scp -r <dossier> t.petit@192.168.34.60:/c/Users/t.petit/
```


---

<br>



### Créer un fichier et y écrire une ligne simple
```sh
echo "texte à copier" > /home/toto/Bureau/fichier_simple.txt
```

### Créer un fichier et y écrire un texte multi-ligne (here-document)

* Le `'EOF'` avec simple quote évite les interprétations (`$`, `*` ...)
* Est Idéal pour blocs longs / multi-lignes

```sh
cat <<'EOF' > /chemin/répertoire/fichier_avec_lignes.txt
<texte> 
EOF
```

### Créer un fichier et écrire un hash brut (sans interprétation du shell)

* La méthode avec printf semble la plus sûre pour écrire des hashs Kerberos / AS-REP / NTLM en texte brut...
* simple quote autour du texte (pour ne pas interpréter les `$` comme des variable ou les `*` comme des wildcards)
* `'%s'` pour préciser une chaîne de caractères

```sh
printf '%s' '$krb5asrep$23$bertie_pate@TOTO-DOMAIN.NOOB:Hash$$$de$*ùses%*$:MORTSù:!£' > TOTOestTENTÉparleCRACK♥.txt
```


### Vérifier le nombre de lignes d'un fichier
```sh
wc -l totoshit.txt
```



---

<br>



### Télécharger un fichier
```sh
cd ~/Bureau
wget https://github.com/ropnop/kerbrute/archive/refs/heads/master.zip -O Kerbrute-master.zip

```
`-O` et pas -o (lowercase o = log file)
```sh
unzip Kerbrute-master.zip
```

### Ajouter un binaire au PATH (et le renommer avec un nom plus simple)

```sh
cd ~/kerbrute-master 					                # être dans le bon répertoire
chmod 700 kerbrute_linux_amd64 				            # rendre le bin exécutable
sudo mv kerbrute_linux_amd64 /usr/local/bin/kerbrute 	# le mettre dans bin
```



---

<br>




### Cloner le repo est préférable
sur Kali git est installé par défaut, c'est mieux de passer par là pour télécharger !
```sh
cd ~/Bureau
git clone https://github.com/ropnop/kerbrute.git
```

<br>

### Compiler le code source Go pour le transformer en binaire

Le Git clone télécharge le code source de kerbrute  (codé en Go), il faut le compiler.

Vérifier que Go est installé
```sh
go version
```

Si pas installé
```sh
sudo apt update
sudo apt install golang -y
```

Compiler 
```sh
cd ~/Bureau/kerbrute-master
go build -o kerbrute
```

### Ajouter kerbrute au Path
```sh
sudo mv kerbrute /usr/local/bin/
```



---

<br>




### Installer krbrelayx
```sh
cd /opt
git clone https://github.com/dirkjanm/krbrelayx.git
```

Vérifier si python est installé
```sh
python3 --version
```

Si absent
```sh
sudo apt update
sudo apt install python3 python3-pip -y
```

Dépendances Python pour krbrelayx
```sh
sudo apt install python3-impacket -y
```

Exécuter krbrelayx directement avec Python (recommandé)
```sh
chmod +x krbrelayx.py
python3 krbrelayx.py --help
```

Exemple krbrelayx
```sh
python3 krbrelayx.py -d example.local --dc-ip 192.168.1.10 -t ldap://192.168.1.20
```

<br>

### Créer un wrapper (créer une commande système krbrelayx qui appelle Python)
```sh
sudo nano /usr/local/bin/krbrelayx
```
Contenu du fichier ("$@" sert à l'interprétation des )
```sh
#!/bin/bash
python3 /opt/krbrelayx/krbrelayx.py "$@"
```
donner les droits au script
```sh
sudo chmod +x /usr/local/bin/krbrelayx
```
Plus qu'à taper krbrelayx dans le shell
```sh
krbrelayx --help
```



---

<br>




### Installer Docker Compose

```sh
sudo apt install -y docker.io
sudo systemctl enable docker --now
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
docker-compose --version
```



---

<br>



### Afficher les partages SMB avec NMAP
```sh
nmap --script smb-enum-shares -p 445 <IP>
```


### Afficher les partages SMB d'un hôte
```sh
smbclient //<IP> -N
```


### Se connecter au partage SMB (si pas de password...)
```sh
smbclient //<IP>/nom_partage
```

Se souvenir que les printers ont souvent leurs pages web sur http 80 et peuvent contenir pas mal d'infos et permettre des mouvements latéraux.


### brutforce un login SMB avec hydra
```sh
hydra -L usernames.txt -P rockyou.txt smb://<IP>
```

### Se connecter au partage SMB avec password
```sh
smbclient //<IP>/nom_partage -U <username>
```



### create fake login web page avec setoolkit (social engineeering tool kit) pour récolter des logins
```sh
sudo setoolkit
```
De nombreuses options disponible, pour créer des pages web avec des templates, clonage de sites, importer ces propres fichiers, choisir "Website Attack Vectors". Pour créer une fausse page web de connexion Google par exemple choisir "Web Templates" puis choisir l'IP pour host la page (il est bien indiqué que la méthode de requête login est sur POST sinon il faudra sauvegardé le HTML et changer la méthode (comme indiqué...). Une fois connecté les informations rentrées sur la fake page apparaîteront dansle terminal setoolkit.


### Utiliser ZAP pour scanner les vuln d'une page web











