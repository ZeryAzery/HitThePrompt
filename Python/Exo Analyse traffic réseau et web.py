# Importation des sockets nécessaires
import requests
import socket
import dns.resolver
from bs4 import BeautifulSoup
import ssl
import subprocess

dom = "taisen.fr"
url = "https://taisen.fr/"

# Effectue une requête GET
req = requests.get(url)
print("\nRequête GET :", req.status_code, req.reason)
print("IP du site :", socket.gethostbyname(dom))
print("DNS Utilisé :",dns.resolver.get_default_resolver().nameservers[0])

# Établi une connexion réseau IPv4 (AF_INET) et TCP (SOCK_STREAM)
soc = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
soc.connect((dom, 443))
print("\nAdresse IP/Port src :", soc.getsockname())
print("Adresse IP/Port dst :",soc.getpeername())

# Afficher les Headers 
headers = {key: value for key, value in req.headers.items()}
print("\nHeaders_trouvés :\n", headers)
print("\nHeader Content-Type :", req.headers.get("Content-Type", "Inconnu"))

# Afficher les balises html
soup = BeautifulSoup(req.text, "html.parser")
h1 = soup.find("h1")
balises = [tag.name for tag in soup.find_all()]
print("\nBalises_trouvées :\n",balises)
print("\nBalise h1 :", h1.text)

# Afficher le certificat
cert = ssl.get_server_certificate((dom, 443))
print("\nClé publique du certificat :\n\n", cert)

# Afficher le nom de l'autorité qui a signé le certificat
context = ssl.create_default_context()
with socket.create_connection((dom, 443)) as sock:
    with context.wrap_socket(sock, server_hostname=dom) as ssock:
        cert = ssock.getpeercert()
        print("Autorité de certification :", cert.get('issuer'))

# Subprocess tracert
print("\nUn intant exécution de tracert...")
result = subprocess.run(["tracert", dom], capture_output=True, text=True)
if result.returncode == 0:
    print(result.stdout)
else:
    print("Erreur lors de l'exécution de tracert")
