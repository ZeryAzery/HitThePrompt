# Diskpart

Diskpart est l'outils de partitionnement des disques de Windows en CLI.

```batch
# Ouvrir diskpart (dans un terminal)
diskpart
# Lister les diques 
lis dis
# Sélectionner un disque
sel dis
# Lister les volumes
lis vol
# Sélectionner un volume
sel vol
# Assigner une à un volume
ass letter D
# créer une partition primaire de 40Go (exprimé en Mo)
crea par prim size=40000
```

Le formatage ne s'effectue pas dans Diskpart
```batch
# Formater un disque au format NTFS 
exit
format G: /FS:ntfs

