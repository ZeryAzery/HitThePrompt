# PfSense commands

Il peut être utile d'intéragir directement avec le Shell de PfSense pour pouvoir débugguer certaines situations. Utiliser la touche "8" pour avoir accès à la console.

## Afficher les infos des interfaces
```sh
ifconfig
```

## Désactiver le Pare-feu (Permet de récupérer l'accès à la page web)
```sh
pfctl -d
```

## Réactiver le Pare-feu
```sh
pfctl -e
```

## Afficher les paquets qui traversent une interface
```sh
tcpdump -i nom_interface
```

## Afficher les paquets qui traversent une interface et une IP cible
```sh
tcpdump -i nom_interface host 192.168.100.10
```