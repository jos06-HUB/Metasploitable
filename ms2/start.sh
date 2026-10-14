#!/bin/bash
# Démarre Metasploitable 2 (Ubuntu 8.04, VirtualBox autonome) — cible 172.28.128.5
# Console nécessaire au premier démarrage : login msfadmin / msfadmin
set -e
VBoxManage startvm "Metasploitable2" --type gui
