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
