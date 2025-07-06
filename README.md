# 🔐 Pare-feu IPv6 avec ip6tables + Serveur Apache sous Docker

Ce projet académique a pour objectif de sécuriser une plateforme web conteneurisée via un pare-feu IPv6 basé sur `ip6tables`, le tout déployé sur une machine virtuelle Red Hat avec Docker.

---

## 📌 Objectifs

- Activer et configurer l’IPv6 sur une VM Red Hat
- Déployer un serveur Apache dans un conteneur Docker
- Créer un réseau Docker avec support IPv6
- Mettre en place un pare-feu avec `ip6tables`
- Contrôler et tester le trafic réseau autorisé (HTTP, SSH)

---

## ⚙️ Technologies utilisées

- 🐧 **Red Hat Enterprise Linux (RHEL)**
- 🐳 **Docker**
- 🌐 **IPv6**
- 🔥 **iptables (ip6tables)**
- 🌐 **Apache HTTP Server**

---

## 🛠️ Étapes principales

### 1. Configuration de l'IPv6

```bash
sudo ip -6 addr add 2001:db8::1/64 dev ens160
sudo ip -6 route add default via fe80::1 dev ens160
```
### 2. Configuration du pare-feu ip6tables
```bash
sudo ip6tables -P INPUT DROP
sudo ip6tables -P FORWARD DROP
sudo ip6tables -P OUTPUT ACCEPT

sudo ip6tables -A INPUT -i lo -j ACCEPT
sudo ip6tables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
sudo ip6tables -A INPUT -p tcp --dport 22 -j ACCEPT
sudo ip6tables -A INPUT -p tcp --dport 80 -j ACCEPT

sudo ip6tables-save | sudo tee /etc/ip6tables.rules
```
✅ À ce stade, seules les connexions SSH (22) et HTTP (80) sont autorisées.

### 3. Déploiement du serveur Apache avec Docker
```bash
# Démarrer Docker
sudo systemctl start docker

# Télécharger l’image Apache
sudo docker pull httpd

# Créer un réseau Docker IPv6
sudo docker network create --driver bridge --ipv6 --subnet=2001:db8:1::/64 ipv6net

# Lancer le conteneur Apache
sudo docker run -dit --name webserver \
  --network ipv6net \
  --ip6 2001:db8:1::2 \
  -p 80:80 httpd
```
## ✅ Tests
### Tester la connectivité IPv6 :
```bash
ping6 2001:db8::1
```

### Tester l’accès à la page web :
```bash
curl -6 http://[2001:db8:1::2]
````

### Tester les ports autorisés et bloqués :
```bash
telnet 2001:db8:1::2 80     # ✅ Autorisé
telnet 2001:db8:1::2 8080   # ❌ Bloqué
```

## 🧱 Architecture du projet

  - RHEL VM configurée avec une adresse IPv6
  - Règles ip6tables sur la VM pour filtrer le trafic
  - Serveur Apache dans un conteneur Docker
  - Accès autorisé uniquement via les ports définis

## 🗂 Structure du projet
```arduino
📁 ipv6-firewall-apache
 ┣ 📄 README.md
 ┣ 📄 rapport.md
 ┣ 🔧 firewall-rules.sh
 ┣ 🐳 setup-docker.sh
```
## 🧠 Auteur

  - 👨‍💻 Jasser Gorsia
  - 🏫 ENICarthage
  - 📅 Année académique : 2025


