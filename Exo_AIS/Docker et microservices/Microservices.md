# __DOCKER ET MICROSERVICES__

![alt text](<docker-logo.png>)

### Intro

- Créer, déployer et exécuter des applications dans des conteneurs.
- Simplifier le déploiement et la montée en charge (ou scalabilité).
- Isoler les applications sans avoir à créer de machines virtuelles complètes.

<br>

__Concepte de Docker__
- **Client Docker** : gère les conteneurs.
- **Démon Docker (service)** : héberge les conteneurs.
- Normalement, créer un compte Docker et **ne pas faire tourner Docker en root**.

<br>

__En pratique :__
  - Écrire un Dockerfile → ce qu’il y a dans ton conteneur.
  - docker build → crée une image.
  - docker run → lance un conteneur à partir de l’image.

<br>


## Installation rapide de Docker (Debian) 

Sur un shell root
```bash
wget https://raw.githubusercontent.com/ZeryAzery/HitThePrompt/refs/heads/main/Exo_AIS/Docker/Docker_Install_Debian.sh
chmod +x Docker_Install_Debian.sh
./Docker_Install_Debian.sh
```

Vérifier le contenu du script
```bash
curl https://raw.githubusercontent.com/ZeryAzery/HitThePrompt/refs/heads/main/Exo_AIS/Docker/Docker_Install_Debian.sh
```

<br>

## Installation de Docker (exemple Ubuntu/Debian)

```bash
apt-get update
apt-get install ca-certificates curl gnupg lsb-release
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
```
Pour Debian changer juste :
```bash
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
```


Ajouter le dépôt Docker
```bash
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
```


Mettre à jour la liste des paquets
```bash
apt-get update
```


Installer Docker
```bash
apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```


Vérifier la version
```bash
docker --version
```

<br>

## Le Dockerfile

Créer un dossier pour le projet Docker
```bash
mkdir ~/vulnapp-docker
cd ~/vulnapp-docker
```


Créer le fichier Dockerfile
```bash
nano Dockerfile
```


### Contenu du fichier

```dockerfile
FROM debian:latest

USER root

RUN apt update && \
    apt upgrade -y && \
    apt install -y wget git

RUN wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb

RUN apt update && \
    apt install -y dotnet-sdk-8.0 dotnet-runtime-8.0

EXPOSE 443

WORKDIR /app
RUN git clone https://github.com/Aif4thah/VulnerableLightApp.git
WORKDIR /app/VulnerableLightApp

CMD ["dotnet", "run", "--url=https://0.0.0.0:443"]
```



### Construire l’image Docker

```bash
docker build -t vulnapp-http:443 .
```


### Lancer le conteneur avec volume partagé

```bash
docker run --rm -it -p 443:443 -v /home/toto/shared:/shared vulnapp-http:443
```

* `--rm` → Supprime automatiquement le conteneur une fois qu’il s’arrête. (Pratique pour les tests ou les conteneurs temporaires)
* `-it` → interagir avec le conteneur comme sur une machine normale ( -i = interactive et -t = terminal
)
### Lancer le conteneur en arrière-plan (mode detached avec `-d`)

```bash
docker run -d --name vulnapp \
  -p 443:443 \
  -v /home/toto/shared:/shared \
  vulnapp-http:443
```

__Options utiles :__

* `--restart=always` → Redémarre le conteneur automatiquement à chaque reboot.
* `--restart=unless-stopped` → Redémarre sauf si tu l’as stoppé manuellement.

<br>

> [!NOTE]  
> * docker run -d → crée + démarre en arrière-plan
> * docker start → redémarre toujours en arrière-plan, même sans -d


### Vérifier que le conteneur tourne

```bash
docker ps
docker logs -f vulnapp
docker logs vulnapp
```


### Accéder à un shell dans le conteneur sans l’arrêter

```bash
docker exec -it vulnapp bash
```


### Tester l’application

```bash
curl -k https://localhost:443
curl -k https://192.168.0.15:443
```


### Dans le navigateur :

```
https://192.168.0.15/swagger
```


### Supprimer l’ancien conteneur (si existant)

```bash
docker stop vulnapp
docker rm vulnapp
```


### Voir les images Docker

```bash
docker images
```

<br>

## Suppression des conteneurs


Supprimer le conteneur en cours
```bash
docker rm -f vulnapp
```

Supprimer un conteneur avec son ID
```bash
docker rm <ID>
```
Supprimer les conteneurs sans les images (?)
```bash
docker container prune -f
```

Supprimer toutes les images Docker
```bash
docker rmi -f $(docker images -aq)
```

Supprimer seulement les images “vulnapp” en filtrant par nom
```bash
docker rmi -f $(docker images vulnapp-* -q)
```

<br>

## Vérifier le partage entre l'hôte et le conteneur  

__Pour le partage de fichier ajouter au Dockerfile :__
```dockerfile
VOLUME ["/shared"]
```

<br>

* __Depuis la machine hôte__
```bash
echo "hello from host" > /home/toto/shared/test.txt
```

Puis vérifier dans le conteneur (`cat`doit retourner "hello from host):
```bash
docker exec -it vulnapp bash
cat /shared/test.txt
```


<br>

* __Depuis le conteneur__
```bash
echo "hello from container" > /shared/test2.txt
```

Puis vérifier de nouveau dans l'hôte (`cat`doit retourner "hello from host"):
```bash
cat /home/toto/shared/test2.txt
```


<br>

## Utiliser le volume partagé avec l'hôte 

* le but est de conserver les logs même une fois le container détruit.
* le chemin des logs se modifie via les fichiers de configuration de l'application


Créer un dossier destiné à accueillir les logs du conteneur
```bash
mkdir -p /home/toto/shared/logs
```

### Monter ce dossier dans le conteneur avec `-v`

Stopper/supprimer l’ancien conteneur si besoin
```bash
docker rm -f vulnapp
docker run -d --name vulnapp \
  -p 443:443 \
  -v /home/toto/shared/logs:/app/logs \
  vulnapp-http:443
```

<br>

* `docker run` → Crée et lance un nouveau conteneur.
* `-d` → Détaché (detached mode), le conteneur tourne en arrière-plan.
* `--name vulnapp` → Donne un nom au conteneur (vulnapp) pour le gérer facilement.
* `-p 443:443` → Mappe le port 443 de l’hôte vers le port 443 du conteneur (HTTPS).
* `-v /home/toto/shared/logs:/app/logs` → Monte le dossier logs de l’hôte dans le conteneur à /app/logs. Tout ce qui est écrit ici sera persistant.
* `vulnapp-http:443` → Nom et tag de l’image Docker à utiliser pour créer le conteneur.

<br>

### Vérifier que le volume partagé fonctionne pour les logs

Dans le conteneur, créer un fichier de test dans le dossier des logs monté
```bash
docker exec -it vulnapp bash
echo "log de test depuis le conteneur" > /app/logs/test.log
```

Sur l’hôte, regarder si le fichier apparaît dans le dossier logs
```bash
ls -l /home/toto/shared/logs
cat /home/toto/shared/logs/test.log
```

Si test.log est présent le volume partagé fonctionne 

![alt text](<shared_host-container.png>)

<br>

* La fabrication des logs se fait avec le fichier nlog.config, j'ai recréé le fichier nlog.config en local en indiquant le chemin `/home/toto/shared/logs`
* Ensuite je viens modifier le fichier Dockerfile pour qu'il écrase son fichier nlog.config et le remplace par celui qui a le chemin de la machine hôte

<br>

Utiliser le docker file pour modifier le fichier de log
```dockerfile
FROM debian:latest

USER root

RUN apt update && \
    apt upgrade -y && \
    apt install -y wget git

RUN wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb

RUN apt update && \
    apt install -y dotnet-sdk-8.0 dotnet-runtime-8.0

RUN mkdir -p /shared/logs

VOLUME ["/shared"]

EXPOSE 443

WORKDIR /app
RUN git clone https://github.com/Aif4thah/VulnerableLightApp.git
WORKDIR /app/VulnerableLightApp

# Copier un nlog.config modifié pour que les logs aillent dans /shared/logs
COPY nlog.config /app/VulnerableLightApp/nlog.config

CMD ["dotnet", "run", "--url=https://0.0.0.0:443"]
```

<br>

Fichier nlog.config avec le chemin de la machine hôte :
```xml
<?xml version="1.0" encoding="utf-8" ?>
<nlog xmlns="http://www.nlog-project.org/schemas/NLog.xsd"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

  <targets>
    <target name="allfile" xsi:type="File"
            fileName="/shared/logs/${shortdate}_logfile.txt"/>

    <!-- Chemin dans le conteneur, monté vers l’hôte -->        
    <target name="jsonfile" xsi:type="File"
            fileName="/shared/logs/${shortdate}_logfile.json">
            <!-- Logs JSON partagés avec l’hôte -->

      <layout xsi:type="JsonLayout">
        <attribute name="time" layout="${longdate}" />
        <attribute name="level" layout="${level:upperCase=true}" />
        <attribute name="message" layout="${message}" />
        <attribute name="exception" layout="${exception:format=ToString,Data}" />
      </layout>
    </target>
    <target name="logconsole" xsi:type="Console" />
  </targets>

  <rules>
    <logger name="*" minlevel="Info" writeTo="jsonfile,logconsole" />
    <logger name="System.*" finalMinLevel="Warn" />
    <logger name="Microsoft.*" finalMinLevel="Warn" />
    <logger name="Microsoft.Hosting.Lifetime*" finalMinLevel="Info" />
  </rules>
</nlog>
```


### Reconstruire l’image et lancer le conteneur
```sh
docker build -t vulnapp-http:443 .
docker run -d --name vulnapp -p 443:443 -v /home/toto/shared:/shared vulnapp-http:443
```


### Regarder les logs en direct : 
```sh
tail -f /home/toto/shared/logs/2025-10-09_logfile.json
```


![alt text](<collected_log_on_local.png>)

<br>

## Appliquer les bonnes pratiques de sécurité issues du Guide docker ANSSI



### 1. Image

- Utiliser une image de base minimale (`debian:slim`, `alpine`) plutôt que `debian:latest`.
- Fixer une version d’image (`debian:12-slim`) → éviter `latest` qui peut changer sans prévenir.
- Supprimer les paquets inutiles (pas d’éditeurs ou outils réseau superflus).


### 2. Utilisateur

- Éviter `USER root`.
- Créer un utilisateur dédié dans le Dockerfile :

```dockerfile
RUN useradd -m appuser
USER appuser
```

###  3. Réduction de surface

- N’exposer que les ports strictement nécessaires (`EXPOSE 443` si HTTPS uniquement).
- Définir un `WORKDIR` dédié à l’application.
- Utiliser `COPY` plutôt que `ADD` (plus prévisible et sécurisé).


### 4. Volumes et persistance

- Monter les logs ou données sensibles sur des volumes **maîtrisés**.
- Monter en lecture seule (`:ro`) sauf si l’écriture est indispensable.
- Séparer les volumes de logs et de données applicatives pour limiter les risques.


### 5. Droits et capacités

- Par défaut, un conteneur a beaucoup de Linux capabilities, les réduire avec `--cap-drop ALL`
- Ajouter uniquement celles nécessaires si besoin avec `--cap-add`
- Rendre le système de fichiers du conteneur immuable avec `--read-only` (hors volumes).

__Exemple au lancement du conteneur :__
```bash
docker run --cap-drop ALL --read-only ...
```

### 6. Intégrité

- Scanner régulièrement les images pour vérifier les vulnéranilités avec des outils comme`docker scan` et `trivy`
- Signer et vérifier les images si possible avant exécution (cosign, notary).
- Maintenir les images de base à jour afin de réduire les vulnérabilités.

### 7. Ressources

- Limiter les ressources du conteneur (empêcher une saturation du host en limitant l’utilisation mémoire et CPU) 
```bash
docker run --memory="512m" --cpus="1.0" ...
```
- Définir des quotas de stockage avec `--storage-opt`
- Restreindre et contrôler l’usage réseau via Cgroups ou network policies

<br>

## Exemple dockerfile/run pour VLA, en appliquant les bonnes pratiques ANSSI


### Docker file

```dockerfile
FROM debian:12-slim

# Étape root : installer dépendances
USER root

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y wget git ca-certificates && \
    wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y dotnet-sdk-8.0 dotnet-runtime-8.0 && \
    rm -rf /var/lib/apt/lists/*

# Créer un utilisateur non root
RUN useradd -m appuser

# Créer les dossiers nécessaires
RUN mkdir -p /shared/logs && chown -R appuser:appuser /shared

WORKDIR /app
RUN git clone https://github.com/Aif4thah/VulnerableLightApp.git && \
    chown -R appuser:appuser /app

# Copier config sécurisée
COPY --chown=appuser:appuser nlog.config /app/VulnerableLightApp/nlog.config

# Utiliser l’utilisateur non-root
USER appuser

VOLUME ["/shared"]
EXPOSE 443

WORKDIR /app/VulnerableLightApp
CMD ["dotnet", "run", "--url=https://0.0.0.0:443"]
```


### Docker run

```sh
docker run -d --name vulnapp \
  -p 443:443 \
  -v /home/toto/shared:/shared \
  --read-only \                # le conteneur est en lecture seule
  --tmpfs /tmp \               # répertoire temporaire en mémoire (sinon beaucoup d'applis plantent)
  --cap-drop ALL \             # supprime toutes les capacités Linux
  --security-opt no-new-privileges:true \  # interdit l'élévation de privilèges
  --memory="512m" \            # limite RAM
  --cpus="1.0" \               # limite CPU
  vulnapp-http:443
```
 __J'arrive pas à le faire fonctionner avec le read only...__


### Lancer le conteneur en direct pour voir les erreurs 

```sh
docker run --rm --name vulnapp \
  -p 443:443 \
  -v /home/toto/shared:/shared \
  --tmpfs /tmp \
  --tmpfs /home/appuser/.dotnet \
  --cap-drop ALL \
  --security-opt=no-new-privileges:true \
  --memory=512m \
  --cpus=1.0 \
  vulnapp-http:443
  ```
* option `--no-cache` permet de s'assurer de ne pas avoir le cache du build précédent
```sh
docker build --no-cache -t vulnapp-http:443 .
```


## Afficher les métriques et relever la consomation des containers

```sh
docker stats vulnapp
```

![alt text](<container_stat.png>)




-----------------------------------------------------------------------


<br>


# __DOCKER COMPOSE__

![alt text](<dockercompose-shema.png>)

- Docker Compose permet de décrire et lancer plusieurs containers en même temps via un seul fichier (docker-compose.yml).
- Il permet de définir les containers, leurs volumes, ports et dépendances, et ensuite une seule commande `docker-compose up` démarre tout.

<br>

Créer le dossier pour Docker Compose
```sh
mkdir ~/vla-compose
cd ~/vla-compose
```



Créer le fichier yml pour Docker Compose
```sh
touch docker-compose.yml
nano docker-compose.yml
```


## Contenu du fichier docker-compose.yml (ici pour 2 containers)

```yml
version: "3.9"

services:
  vla-api:
    build: .
    container_name: vulnapp # il est possible de retirer cette ligne pour laisser dockercompose choisir le  nom pour éviter les conflits
    ports:
      - "443:443"
    volumes:
      - logs-data:/shared/logs
    tmpfs:
      - /tmp
      - /home/appuser/.dotnet
    cap_drop:
      - ALL
    security_opt:
      - no-new-privileges:true
    deploy:
      resources:
        limits:
          memory: 512m
          cpus: "1.0"
    restart: unless-stopped

  logs-storage:
    image: busybox
    container_name: vla-logs
    command: ["sh", "-c", "while true; do sleep 3600; done"]
    volumes:
      - logs-data:/shared/logs
    restart: unless-stopped

volumes:
  logs-data:
```
__Explication :__

- image: busybox → pas besoin de Dockerfile, c’est une image toute prête.
- volumes: - logs-data:/logs → on crée un volume nommé logs-data où l’API pourra écrire ses logs.
- command: tail -f /dev/null → on laisse le container tourner “vide” juste pour que le volume existe et soit accessible.
- logs-data correspond au volume du deuxième container, et /shared/logs est le chemin où ton application écrit ses logs.

<br>

### Lancer le fichier dockercompose :

- Ici le fichier dockercompose utilise le fichier docker qui lui utilise aussi le fichier nlog
- Ces fichiers doivent aussi se trouver dans le dossier vla-compose, ou il faut indiquer correctement le chemin du fichier dans le docker compose et dans le dockerfile... 

```sh
docker compose up -d
```
![alt text](<docker-compose.png>)



### Pour vérifier que les logs sont bien transmit sur le conteneur vla-logs :

```sh
curl -k https://localhost:443
docker exec -it vla-logs ls /shared/logs
docker exec -it vla-logs tail /shared/logs/2025-10-10_logfile.json
# ou en direct
docker exec -it vla-logs tail -f  /shared/logs/2025-10-10_logfile.json
```




-----------------------------------------------------------------------


<br>

# __TERRAFORM__

![alt text](<terralogo.png>)


## Intro

__Terraform est un outil d’Infrastructure as Code (IaC)__

- Il permet de décrire, déployer et gérer des infrastructures, il peut gérer :
  - Des VMs
  - Des conteneurs (docker...)
  - Des bases de données
  - Des réseaux et Firewall
  - Des services cloud (AWS, Azure, GCP)


- En environnement professionnel
  - Automatiser la création et la gestion d’infrastructures sur différents fournisseurs (AWS, Azure, GCP, VMware, etc.).
  - Standardiser et versionner l’infrastructure comme du code (Git).
  - Faciliter la collaboration entre équipes grâce à des workflows reproductibles.
  - Éviter les erreurs manuelles et garantir la cohérence entre environnements (dev, test, prod).
  -nécessite un provider (Docker, AWS, Azure...)

<br>

__Concepte de Terraform__

- Décrire → écrire les fichiers `example.tf` (l’état souhaité de ton infra).
- Planifier → terraform plan (voir les changements à appliquer).
- Appliquer → terraform apply (crée/modifie/supprime l’infra).

<br>

## Installer Terraform 

- Terraform est développé par HashiCorp. Comme Debian ne fournit pas Terraform directement dans ses dépôts officiels, il faut ajouter le dépôt de HashiCorp
- Le paquet doit être signé pour prouver à `apt`qu’il vient bien de l’éditeur officiel (HashiCorp) et pas d’un pirate.
- La clé GPG est ce qui permet de vérifier cette signature. Sans elle, Debian refuserait d’installer le paquet.

<br>

```sh
apt update
apt install -y gnupg curl
```

Importer la clé GPG officielle et la stocker déarmorisée
```sh
curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
```


Ajouter le dépôt HashiCorp pour Debian bookworm 
```sh
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com bookworm main" > /etc/apt/sources.list.d/hashicorp.list
```


Installer Terraform 
```sh
apt update
apt install -y terraform
# vérifier l'installation
terraform -v
```


Créer un dossier pour ce test 
```sh
mkdir ~/terraform-docker
cd ~/terraform-docker
```


Créer un premier fichier de configuration
```sh
nano main.tf
```


### Fichier Terraform `.tf`

```t
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.0"
    }
  }
}

provider "docker" {}

resource "docker_container" "hello" {
  name  = "hello-tf"
  image = "nginx:latest"
  ports {
    internal = 80
    external = 8080
  }
}
```


### Explications

__1er Bloc `terraform { ... }`__

- Indique le provider Terraform à utiliser : ici docker
- Pour gérer Docker, Terraform a besoin du *plugin kreuzwerker/docker*
- On précise une version pour éviter les surprises 

<br>

__2em Bloc `provider "docker" {}`__

- Connecte Terraform au  Docker local (via le socket Unix /var/run/docker.sock)
- Pas besoin de config si ton Docker tourne sur la même machine que Terraform.

<br>

__3em Bloc `resource "docker_container" "hello" { ... }`__

- `resource` → ici on définit un conteneur Docker comme ressource gérée par Terraform.
- `"docker_container"` → type de ressource.
- `"hello"` → nom logique dans Terraform (utile pour référence interne).
- `name` = "hello-tf" → nom réel du conteneur Docker.
- `image` = "nginx:latest" → image Docker à utiliser. Terraform va la télécharger si elle n’existe pas.
- `ports { internal = 80, external = 8080 }` → mappe le port 80 du conteneur sur le port 8080 de la machine hôte.


<br>

## Exécuter Terraform

###  Télécharger les providers (Docker dans ce cas)
* À refaire seulement si changegement de provider ou changement de dossier.
```sh
terraform init
```


### Applique les changements (crée ou met à jour les conteneurs) :

* Terraform fera seulement les changements nécessaires
* À faire après chaque modif du fichier .tf*
```sh
terraform apply -auto-approve
```



### Détruire ce que Terraform a créé

* Supprime uniquement les ressources du .tf
```sh
terraform destroy -auto-approve
```
