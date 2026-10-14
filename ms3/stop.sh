#!/bin/bash
# Éteint Metasploitable 3 (Ubuntu 14.04, Vagrant) — cible 172.28.128.3
set -e
cd ~/Téléchargements/metasploitable3
vagrant halt ub1404
