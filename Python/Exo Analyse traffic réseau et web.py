# Importation des sockets nécessaires
import requests
import socket
import dns.resolver
from bs4 import BeautifulSoup

nmdom = "taisen.fr"
url = "https://taisen.fr/"

r = requests.get(url)
print("\nRequête GET :", r.status_code, r.reason)
print("IP du site :", socket.gethostbyname(nmdom))
print("DNS Utilisé :",dns.resolver.get_default_resolver().nameservers[0])

# Établi une connexion réseau IPv4 (AF_INET) et TCP (SOCK_STREAM)
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((nmdom, 443))
print("\nAdresse IP/Port src :", s.getsockname())
print("Adresse IP/Port dst :",s.getpeername())

# Afficher les Headers 
response = requests.get(url)
headers = {key: value for key, value in response.headers.items()}
print("\nHeaders_trouvés :\n", headers)
print("\nHeader Content-Type :", response.headers.get("Content-Type", "Inconnu"))

# Afficher les balises html
soup = BeautifulSoup(response.text, "html.parser")
balises = [tag.name for tag in soup.find_all()]
print("\nBalises_trouvées :\n",balises)