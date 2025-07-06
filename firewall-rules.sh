#!/bin/bash

# Politique par défaut
ip6tables -P INPUT DROP
ip6tables -P FORWARD DROP
ip6tables -P OUTPUT ACCEPT

# Loopback
ip6tables -A INPUT -i lo -j ACCEPT

# Connexions établies
ip6tables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# SSH (port 22)
ip6tables -A INPUT -p tcp --dport 22 -j ACCEPT

# HTTP (port 80)
ip6tables -A INPUT -p tcp --dport 80 -j ACCEPT
