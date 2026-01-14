# 🈹 Aide au Scripting Bash 

<br>

### Encapsuler une variable
Header="Authorization: Bearer <Token>>"
echo $Header

<br>


### utiliser -eux pour avoir des infos sur les erreurs dans les scripts
```sh
#!/bin/bash -eux
```

<br>

### Opérateur logique OR `||` 
exécutera la commande à droite seulement si la commande à gauche échoue
```sh
grep -qxF "alias ll='ls -la'" ~/.bashrc || echo "alias ll='ls -la'" >> ~/.bashrc
```

<br>


### Créer des arguments dans un script

$0 = nom du script (script.sh)

$1 = -a

$2 = 1

$3 = --test

$# = nombre d’arguments (ici 3)

"$@" = tous les arguments



Ou parser proprement avec getopts :
while getopts "ab:" opt; do
case $opt in
a) echo "Option -a";;
b) echo "Option -b avec valeur $OPTARG";;
esac
done
	



