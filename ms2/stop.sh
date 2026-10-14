#!/bin/bash
# Éteint Metasploitable 2 (Ubuntu 8.04, VirtualBox autonome) — cible 172.28.128.5
set -e
VBoxManage controlvm "Metasploitable2" poweroff
