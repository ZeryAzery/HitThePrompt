# Ubuntu Desktop

---


<br>

## Additions invité VirtualBox

```bash
sudo apt update
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

---


<br>


## Étendre LVM et système de fichiers

LVM = Logical Volume Manager (PV + VG + LV)

* PV (Physical Volume) : C’est la couche la plus basse. Il s’agit d’une partition ou d’un disque physique
* VG (Volume Group) : C’est un pool de stockage obtenu en regroupant un ou plusieurs PV. Le VG représente l’espace total disponible pour créer des volumes.
* LV (Logical Volume) : C’est l’équivalent d’une partition, mais créée à l’intérieur d’un volume group.


### Étendre PV LVM pour qu’il voit tout l’espace de /dev/sda3
```sh
sudo pvresize /dev/sda3
```


### Vérifier l'espace libre dans le VG
```sh
sudo vgs
```


### Étendre le volume logique pour utiliser tout l’espace libre du VG
```sh
sudo lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv
```


### Étendre le filesystem ext4
```sh
sudo resize2fs /dev/ubuntu-vg/ubuntu-lv
```

---


<br>


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

---


<br>


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


---


<br>


## Installation d'outils

```bash
sudo apt search net-tools
sudo apt install net-tools
sudo apt install binutils
sudo apt install wireshark
sudo apt install gparted
```






