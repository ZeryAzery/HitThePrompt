# Python Basics

## Ajouter ces variables d'envirronements à "Path" après avoir installé Python (utiliser "sysdm.cpl" par exemple):
![alt text](<var env python-1.png>)
C:\Users\Ton_Username\AppData\Local\Programs\Python\Python313\
C:\Users\Ton_Username\AppData\Local\Programs\Python\Python313\Scripts\

## Afficher l'aide Python et lancer un script depuis powershell
```powershell
pip -h
.\python.exe test.py
```
Les espaces sont interprétés dans Python faire attention à l'indentation.
1 tabulation vaut 4 espaces.

## Installer des modules Python (Terminal Powershell)
```powershell
pip3 install cryptography
pip3 install requests
pip3 install socket
pip3 install dnspython
pip3 install beautifulsoup4 # extraire et stocker les balises HTML
pip3 install lxml # parser correctement du HTML

```

## Mettre à jour Python
```powershell
python.exe -m pip install --upgrade pip
```

## Importer un module (Terminal Python)
```python
import cryptography     # Manipuler des certificats et clés cryptographiques
import requests         # Éffectuer des requêtes HTTP
import socket           # Gérer les connexions réseau bas niveau
import dns.resolver     # Permet de résoudre des noms de domaine (DNS)
from bs4 import BeautifulSoup  # Parser et manipuler du HTML
import ssl              # Travailler avec des connexions sécurisées (SSL/TLS)
import subprocess       # Éffectuer des commandes du système hôte
```

## Caractère d'échappement \n (saut de ligne)
```python 
print("aa\naa")
```
## Vérifier le type de variable
```python
type(a)
```

## Afficher les méthodes et propriété d'une variable
```python
fruits = ["pomme", "banane", "cerise"]
dir(fruits)
# __len__
```
## les boucles

### for

```python
fruits = ["pomme", "banane", "cerise"]

for i in range(fruits.__len__())
    print(fruits[i])

print("\n")
fruits.reverse()

for f in fruits
    print(f)
```
### while

```python
i = 0
while i < 10:
    print(i)
    i = i + 1
```

## les conditions

### if, else
```python
fruits = ["pomme", "banane", "cerise"]

x = 5
if x = 2:
    print("x est plus grand que 2")
else:
    print("x est plus petit ou égal à 2")
```

```python
fruits = ["pomme", "banane", "cerise"]

if fruits.counts("peche"):
    print("trouvé")
else:
    print("Pas trouvé")
```

```python
fruits = ["pomme", "banane", "cerise"]

x = 5

if x = 2:
    print("x est plus grand que 2")
else:
    print("x estplus petit ou égal à 2")
```
### if, elif, else
```python
fruits = ["pomme", "banane", "cerise"]

if fruits.counts("peche"):
    print("trouvé")

elif fruits.count("pomme"):
    print("trouvé (elif)")

else:
    print("Pas trouvé")
```
### try except
```python
print("[*] avant mon erreur")
try:
    1/0
    except Exception as Err:
        print("[!!] erreur :", type(Err).__name__)

print("[*] après mon erreur")
```


## Les fonctions 

```python
def multiply(nb):
    #print(nb*2)
    return nb*2

i = 3

a = multiply(i)
print("a :", a)
print("i :", i)
```
## Les dictionnaires 
Un dictionnaire contient une clé et une valeur, ici il y a 2 cléfs (kiwi et orange)

```python
dico = {
    "kiwi" : "en été",
    "orange" : "en hiver"
}

print(type(dico))

for key, value in dico.items():
        if key == "kiwi":
            print(f"{key}: {value} : c'est bien un kiwi ")
        else:
            print(f"{key}: {value} ")
```
