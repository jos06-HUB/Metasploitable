#!/bin/bash
# Éteint Metasploitable 1 (Ubuntu 8.04, VirtualBox autonome) — cible 172.28.128.4
set -e
VBoxManage controlvm "Metasploitable1" poweroff
