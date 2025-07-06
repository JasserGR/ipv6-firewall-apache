#!/bin/bash

# Démarrer Docker
sudo systemctl start docker

# Créer le réseau IPv6
sudo docker network create --driver bridge --ipv6 --subnet=2001:db8:1::/64 ipv6net

# Lancer le conteneur Apache
sudo docker run -dit --name webserver --network ipv6net --ip6 2001:db8:1::2 -p 80:80 httpd
