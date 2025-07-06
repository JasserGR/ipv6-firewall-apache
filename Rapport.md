**Mise en place d'un firewall open source (iptables IPv6) et test sur une plateforme web Apache sous Linux Red Hat avec Docker**

---

## **1. Introduction**

Dans ce projet, nous avons mis en place un pare-feu IPv6 en utilisant `iptables`, testé sa configuration sur une plateforme web hébergée sur Apache, et utilisé Docker pour faciliter le déploiement. L'objectif était de contrôler le trafic entrant et sortant tout en garantissant l'accessibilité du serveur web via IPv6.

---

## **2. Configuration de l'environnement**

### **Vérification et activation de l'IPv6**

* Vérifier l'état d'IPv6 :

  ```bash
  sudo sysctl -p
  ```

  ✅ Résultat obtenu :

  ```
  net.ipv6.conf.all.disable_ipv6 = 0
  net.ipv6.conf.default.disable_ipv6 = 0
  ```

* Identifier l'interface réseau principale :

  ```bash
  ip a
  ```

  ✅ Interface détectée : `ens160`

* Attribuer une adresse IPv6 statique :

  ```bash
  sudo ip -6 addr add 2001:db8::1/64 dev ens160
  ```

* Ajouter une route par défaut pour IPv6 :

  ```bash
  sudo ip -6 route add default via fe80::1 dev ens160
  ```

---

## **3. Configuration du pare-feu avec iptables**

### **Définition des règles de filtrage**

* Vérifier les règles actuelles :

  ```bash
  sudo ip6tables -L -v -n
  ```

* Réinitialiser les règles existantes :

  ```bash
  sudo ip6tables -F
  ```

* Définir les politiques par défaut :

  ```bash
  sudo ip6tables -P INPUT DROP
  sudo ip6tables -P FORWARD DROP
  sudo ip6tables -P OUTPUT ACCEPT
  ```

* Autoriser le trafic sur l'interface locale :

  ```bash
  sudo ip6tables -A INPUT -i lo -j ACCEPT
  ```

* Autoriser les connexions établies :

  ```bash
  sudo ip6tables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
  ```

* Autoriser l'accès SSH :

  ```bash
  sudo ip6tables -A INPUT -p tcp --dport 22 -j ACCEPT
  ```

* Autoriser l'accès au serveur Apache :

  ```bash
  sudo ip6tables -A INPUT -p tcp --dport 80 -j ACCEPT
  ```

* Sauvegarder les règles du pare-feu :

  ```bash
  sudo ip6tables-save | sudo tee /etc/ip6tables.rules
  ```

✅ À ce stade, seules les connexions SSH et HTTP sont autorisées.

---

## **4. Déploiement du serveur Apache avec Docker**

### **Lancement du serveur web**

* Démarrer Docker :

  ```bash
  sudo systemctl start docker
  ```

* Télécharger l'image Apache :

  ```bash
  sudo docker pull httpd
  ```

* Créer un réseau IPv6 pour Docker :

  ```bash
  sudo docker network create --driver bridge --ipv6 --subnet=2001:db8:1::/64 ipv6net
  ```

* Lancer le conteneur Apache avec IPv6 activé :

  ```bash
  sudo docker run -dit --name webserver --network ipv6net --ip6 2001:db8:1::2 -p 80:80 httpd
  ```

* Vérifier que le conteneur tourne :

  ```bash
  sudo docker ps
  ```

✅ Le serveur web Apache est maintenant fonctionnel dans un conteneur Docker.

---

## **5. Tests et validation**

### **Vérifications du fonctionnement du pare-feu et du serveur**

* Tester la connectivité IPv6 :

  ```bash
  ping6 -c 4 2001:db8::1
  ```

* Vérifier l'accès au serveur web :

  ```bash
  curl -6 http://[2001:db8:1::1]
  ```

  ✅ Résultat obtenu :

  ```
  <html>
  <body>
  <h1>It works!</h1>
  </body>
  </html>
  ```

* Vérifier les restrictions du pare-feu :

  ```bash
  telnet 2001:db8:1::1 22  # SSH (autorisé)
  telnet 2001:db8:1::1 8080  # Doit être bloqué
  ```

---

## **6. Conclusion**

En résumé, nous avons mis en place un pare-feu IPv6 avec `iptables` et testé son efficacité sur un serveur web Apache exécuté dans un conteneur Docker. La configuration a permis de restreindre l'accès aux services essentiels tout en assurant une accessibilité contrôlée via IPv6.

