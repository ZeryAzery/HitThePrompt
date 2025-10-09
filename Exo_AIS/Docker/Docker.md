# Docker / Microservices

- Redéployer des applications plus facilement.


## Orchestrateurs (Infrastructure as Code et fichiers plats)

- Terraform
- Kubernetes


## Concepts Docker

- **Client Docker** : gère les conteneurs.
- **Démon Docker (service)** : héberge les conteneurs.
- Normalement, créer un compte Docker et **ne pas faire tourner Docker en root**.

## Vérifications et commandes de base

```bash
docker --version
docker run name-apk
```

## Installation Docker (exemple Ubuntu/Debian)

```bash
apt-get update
apt-get install ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
```

### Créer un dossier pour ton projet Docker

```bash
mkdir ~/vulnapp-docker
cd ~/vulnapp-docker
```

### Créer le fichier Dockerfile

```bash
nano Dockerfile
```

### Contenu du fichier

```bash
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

VOLUME ["/shared"]

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
docker run --rm -it -p 443:443 -v /home/axel/shared:/shared vulnapp-http:443
```

### Lancer le conteneur en arrière-plan (mode detached)

```bash
docker run -d --name vulnapp \
  -p 443:443 \
  -v /home/axel/shared:/shared \
  vulnapp-http:443
```

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

### Supprimer le conteneur en cours
```bash
docker rm -f vulnapp
```
### Supprimer un conteneur avec son ID

```bash
docker rm <ID>
```
### Supprimer les conteneurs sans les images (?)
```bash
docker container prune -f
```

### Supprimer toutes les images Docker

```bash
docker rmi -f $(docker images -aq)
```

### Supprimer seulement les images “vulnapp” en filtrant par nom

```bash
docker rmi -f $(docker images vulnapp-* -q)
```

## Vérifier que le partage fonctionne entre l'hôte et le conteneur  

* depuis la machine hôte
```bash
echo "hello from host" > /home/axel/shared/test.txt
```

* Puis vérifier dans le conteneur :
```bash
docker exec -it vulnapp bash
cat /shared/test.txt
```
* __Si `cat`retourne bien "hello from host" c'est ok__

* Depuis le conteneur
```bash
echo "hello from container" > /shared/test2.txt
```

* Puis vérifier de nouveau dans l'hôte :

```bash
cat /home/axel/shared/test2.txt
```
* __Si `cat`retourne bien "hello from host" c'est ok__



## Utiliser le volume partagé avec l'hôte afin d'y stocker les journeaux d'évenements


* le but est de conserver les logs même une fois le container détruit.
* le chemin des logs se modifie via les fichiers de configuration de l'application


### Créer un dossier destiné à accueillir les logs du conteneur

```bash
mkdir -p /home/axel/shared/logs
```

### Monter ce dossier dans le conteneur (stopper/supprimer l’ancien conteneur si besoin)

```bash
docker rm -f vulnapp

docker run -d --name vulnapp \
  -p 443:443 \
  -v /home/axel/shared/logs:/app/logs \
  vulnapp-http:443
```
`docker run` → Crée et lance un nouveau conteneur.

`-d` → Détaché (detached mode), le conteneur tourne en arrière-plan.

`--name vulnapp` → Donne un nom au conteneur (vulnapp) pour le gérer facilement.

`-p 443:443` → Mappe le port 443 de l’hôte vers le port 443 du conteneur (HTTPS).

`-v /home/axel/shared/logs:/app/logs` → Monte le dossier logs de l’hôte dans le conteneur à /app/logs. Tout ce qui est écrit ici sera persistant.

`vulnapp-http:443` → Nom et tag de l’image Docker à utiliser pour créer le conteneur.

### Vérifier que le volume partagé fonctionne pour les logs

* Dans le conteneur, créer un fichier de test dans le dossier des logs monté
```bash
docker exec -it vulnapp bash

echo "log de test depuis le conteneur" > /app/logs/test.log
```

* Sur l’hôte, regarder si le fichier apparaît dans le dossier logs
```bash
ls -l /home/axel/shared/logs
cat /home/axel/shared/logs/test.log
```
* Si  test.log est présent le volume partagé fonctionne 


La fabrication des logs se fait avec le fichier nlog.config, j'ai recréé le fichier nlog.config en local en indiquant le chemin `/home/axel/shared/logs`

Ensuite je viens modifier le fichier Dockerfile pour qu'il écrase son fichier nlog.config et le remplace par celui qui a le chemin de la machine hôte

Utiliser le docker file pour modifier le fichier de log

```
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

Fichier nlog.config avec le chemin de la machine hôte :
```
<?xml version="1.0" encoding="utf-8" ?>
<nlog xmlns="http://www.nlog-project.org/schemas/NLog.xsd"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

  <targets>
    <target name="allfile" xsi:type="File"
            fileName="/shared/logs/${shortdate}_logfile.txt"/>
    <target name="jsonfile" xsi:type="File"
            fileName="/shared/logs/${shortdate}_logfile.json">
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
docker run -d --name vulnapp -p 443:443 -v /home/axel/shared:/shared vulnapp-http:443
```


### Regarder les logs en direct : 
```sh
tail -f /home/axel/shared/logs/2025-10-09_logfile.json
```
![alt text](<host_logs_registerd.mp4>)
![alt text](<collected_log_on_local.png>)
