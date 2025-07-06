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

