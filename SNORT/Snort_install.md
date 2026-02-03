# Installation de Snort 3  (Debian)

> Cette procédure a été testée et validée sur Debian 12.4.0

## Mise à jour du système
```bash
apt update && apt upgrade -y
```

## Installation des dépendances requises
```bash
apt install -y \
build-essential \
cmake \
git \
pkg-config \
autoconf automake libtool m4 \
libpcap-dev \
libpcre2-dev \
libdumbnet-dev \
libhwloc-dev \
luajit libluajit-5.1-dev \
libssl-dev \
zlib1g-dev \
liblzma-dev \
libsqlite3-dev \
uuid-dev \
libnetfilter-queue-dev \
libmnl-dev \
libunwind-dev \
libfl-dev \
bison flex gawk
```

## Installation de libdaq

> libdaq (Data Acquisition Library) est une bibliothèque essentielle pour Snort, elle gère l'acquisition des paquets réseau et agit comme interface entre Snort et les méthodes utilisées pour capturer le trafic réseau.

```bash
cd
git clone https://github.com/snort3/libdaq.git
cd libdaq
./bootstrap
./configure --prefix=/usr/local
make -j$(nproc)
make install
ldconfig
```

Vérification de l'installation libdaq
```bash
pkg-config --modversion libdaq
```

## Installation de Snort 3

Récupération des sources
```bash
cd
git clone https://github.com/snort3/snort3.git
cd snort3
```

Configuration CMake
```bash
./configure_cmake.sh --prefix=/usr/local
```

Compilation et installation
```bash
cd build
make -j$(nproc)
make install
ldconfig
```

## Test de fonctionnement 

Afficher la version de Snort
```bash
snort -V
```

Tester le fichier de configuration
```bash
snort -c /usr/local/etc/snort/snort.lua -T
```