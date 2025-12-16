#!/bin/bash
set -e

VERT="\033[0;32m"
JAUNE="\033[0;33m"
ROUGE="\033[0;31m"
RESET="\033[0m"

# Fonction exécutée si une commande échoue
erreur() {
    printf "${ROUGE}L'installation a échouée lors de la commande : '%s'${RESET}\n" "$BASH_COMMAND"
    exit 1
}
trap erreur ERR

# Vérification root
if [ "$(id -u)" -ne 0 ]; then
  printf "${ROUGE}Ce script doit être exécuté en root${RESET}\n"
  exit 1
fi

printf "${JAUNE}Mise à jour des dépôts${RESET}\n"
apt-get update

printf "${JAUNE}Installation des dépendances${RESET}\n"
apt-get install -y ca-certificates curl gnupg lsb-release

printf "${JAUNE}Création du dossier keyrings${RESET}\n"
install -m 0755 -d /etc/apt/keyrings

printf "${JAUNE}Téléchargement de la clé GPG Docker${RESET}\n"
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

printf "${JAUNE}Ajout du dépôt Docker${RESET}\n"
cat > /etc/apt/sources.list.d/docker.list <<EOF
deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(lsb_release -cs) stable
EOF

printf "${JAUNE}Mise à jour des dépôts avec Docker${RESET}\n"
apt-get update

printf "${JAUNE}Installation de Docker${RESET}\n"
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

printf "${JAUNE}Vérification Docker${RESET}\n"
docker --version
systemctl status docker --no-pager

printf "${VERT}Installation terminée${RESET}\n"
