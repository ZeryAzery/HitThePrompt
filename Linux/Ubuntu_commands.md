# Ubuntu Desktop

## Additions invité VirtualBox

```bash
apt update
sudo  apt upgrade 
reboot
apt install make gcc dkms linux-source linux-headers-$(uname -r)
#Insérer le disque des addons
cd /media/axel/VBox_GAs_7.1.6
sudo  ./VBoxLinuxAdditions.run
reboot
```

## Renommer la machine

```bash
sudo hostnamectl set-hostname nouveau_nom
```

## Installation des outils

```bash
sudo apt search net-tools
sudo apt install net-tools
sudo apt install binutils
sudo apt install wireshark
sudo apt install gparted
```

## Config réseau statique

```bash
sudo nano /etc/netplan/01-network-manager-all.yaml
```

```yaml
#Puis ajuster en fonction de votre réseau :
network:
  version: 2
  renderer: NetworkManager
  ethernets:
    enp0s3:
      dhcp4: false
      addresses:
        - 192.168.1.100/24
      gateway4: 192.168.1.1
      nameservers:
        addresses:
          - 8.8.8.8
          - 1.1.1.1
```

```bash
#enregistrer et fermer nano
sudo netplan apply
```

## Config réseau DHCP

```bash
sudo nano /etc/netplan/nano 01-network-manager-all.yaml
```

```yaml
#Puis ajouter avec nano:
network:
  version: 2
  renderer: NetworkManager
```

#enregistrer et fermer nano
```bash
sudo netplan apply
```
## Installer Github

```bash
# 1. Installer les dépendances
sudo apt update
sudo apt install curl -y

# 2. Ajouter la clé GPG officielle de GitHub CLI
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
  sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg

# 3. Ajouter le dépôt GitHub CLI
echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] \
  https://cli.github.com/packages stable main" | \
  sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

# 4. Installer GitHub CLI
sudo apt update
sudo apt install gh -y

# Vérifier l'installation
gh --version
```

## Télécharger VulnerableLightApp sur Github
```bash
gitclone https://github.com/Aif4thah/VulnerableLightApp.git
```

## Installer Dotnet 8.0
```bash
mkdir -p /opt/dotnet
wget https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.100/dotnet-sdk-8.0.100-linux-x64.tar.gz
tar -zxf dotnet-sdk-8.0.100-linux-x64.tar.gz
rm dotnet-sdk-8.0.100-linux-x64.tar.gz
wget https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.16/dotnet-runtime-8.0.16-linux-x64.tar.gz
tar -zxf dotnet-runtime-8.0.16-linux-x64.tar.gz
rm dotnet-runtime-8.0.16-linux-x64.tar.gz
# Ajouter .NET au PATH
ln -s /opt/dotnet/dotnet /usr/bin/dotnet
# Vérifier que tout fonctionne
dotnet --version
```

## Lnacer VulnerableLightA
```bash
dotnet run --url = https://10.0.0.3:3000
```