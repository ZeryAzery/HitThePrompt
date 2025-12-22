# __Installer VulnerableLightApp__



![alt text](<LogoVLA.png>)

Cette application permet l'apprentissage d'exploitation de vulnérabilités [retrouver le projet complet sur GitHub ici](https://github.com/Aif4thah/VulnerableLightApp) 


## Télécharger VulnerableLightApp
```bash
git clone https://github.com/Aif4thah/VulnerableLightApp.git
```

---


<br>


## Installer Dotnet 8.0
```bash
mkdir -p /opt/dotnet
cd /opt/dotnet
wget https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.100/dotnet-sdk-8.0.100-linux-x64.tar.gz
tar -zxf dotnet-sdk-8.0.100-linux-x64.tar.gz
rm dotnet-sdk-8.0.100-linux-x64.tar.gz
wget https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.16/dotnet-runtime-8.0.16-linux-x64.tar.gz
tar -zxf dotnet-runtime-8.0.16-linux-x64.tar.gz
rm dotnet-runtime-8.0.16-linux-x64.tar.gz
# Ajouter .NET au PATH
ln -s /opt/dotnet/dotnet /usr/bin/dotnet
# Vérifier 
dotnet --version
```

---


<br>


## Lancer VulnerableLightApp
```bash
# En HTTPS
dotnet run --url=https://<IP>:3000
# En HTTP
dotnet run --url=http://<IP>:4000
# Lancer le processus en arrère plan
dotnet run --url=https://<IP>:3000 &
# Vérifier les processus lancés en arrère plan
jobs
```

<br>

## Sur une barre d'URL
* https://<IP>:3000/swagger
* http://<IP>:4000/swagger

<br>

## Log Path
VulnerableLightApp/bin/Debug/net8.0/Logs/