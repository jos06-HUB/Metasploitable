#!/bin/bash
# Démarre Metasploitable 1 (Ubuntu 8.04, VirtualBox autonome) — cible 172.28.128.4
# Console nécessaire au premier démarrage : login msfadmin / msfadmin
set -e
VBoxManage startvm "Metasploitable1" --type gui
