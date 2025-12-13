# Installer Github

---

<br>

```bash
# 1. Installer les dépendances
sudo apt update
sudo apt install curl -y

# 2. Ajouter la clé GPG officielle de GitHub CLI
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
  sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg

# 3. Ajouter le dépôt GitHub CLI
echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] \
  https://cli.github.com/packages stable main" | \
  sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

# 4. Installer GitHub CLI
sudo apt update
sudo apt install gh -y

# Vérifier l'installation
gh --version
```
