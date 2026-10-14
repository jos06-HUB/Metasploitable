# Projet Metasploitable — Labo de pentest personnel

## Contexte

Ce dépôt sert à documenter un entraînement personnel de pentest sur les VM **Metasploitable**
(1 et 3), volontairement vulnérables, publiées/distribuées par Rapid7 (créateurs de
Metasploit) et la communauté (VulnHub) dans le but exprès d'être attaquées à des fins
d'apprentissage. C'est l'équivalent d'un labo HackTheBox / TryHackMe / VulnHub, mais local.

- **Cibles** :
  - VM Metasploitable 3 (Ubuntu 14.04), gérée via Vagrant, réseau privé isolé (`172.28.128.3`).
  - VM Metasploitable 1 (Ubuntu 8.04), VM VirtualBox autonome importée depuis l'image VMware
    officielle VulnHub, même réseau privé isolé `vboxnet1` (`172.28.128.4`).
  - VM Metasploitable 2 (Ubuntu 8.04), VM VirtualBox autonome importée depuis l'image VMware
    officielle SourceForge, même réseau privé isolé `vboxnet1` (`172.28.128.5`).
- **Attaquant** : machine Kali locale.
- **Autorisation** : labo personnel auto-hébergé, usage éducatif exclusif. Aucune technique
  de ce dépôt ne doit être appliquée à une cible hors de ce réseau privé sans autorisation
  écrite explicite.

Chaque VM a son propre dossier, avec son plan d'entraînement et ses rapports d'exploitation
par service : [`ms3/parcours.md`](ms3/parcours.md) pour Metasploitable 3,
[`ms1/parcours.md`](ms1/parcours.md) pour Metasploitable 1, et
[`ms2/parcours.md`](ms2/parcours.md) pour Metasploitable 2 (services ciblés, méthodologie,
ordre de progression).

## Ce que Claude peut faire ici sans reposer la question

Dans le cadre de ce projet spécifiquement, il est normal et attendu de :

- Lancer et interpréter des scans (`nmap`, `gobuster`, `ffuf`, `enum4linux`, `smbmap`, etc.)
- Rechercher et expliquer des CVE / exploits connus pour les versions de services détectées
- Utiliser Metasploit (`msfconsole`, recherche de modules, exploitation, sessions meterpreter)
- Rédiger des payloads/exploits à la main pour s'entraîner (FTP, SMB, web, MySQL, Jetty...)
- Décrire des techniques de post-exploitation et d'élévation de privilèges sur la VM cible
- Aider à la rédaction de notes de lab / rapport de pentest au format attendu en entreprise

Tout cela reste strictement scopé aux cibles `172.28.128.3`, `172.28.128.4` et `172.28.128.5`
(ou toute IP de VM Metasploitable gérée via le Vagrantfile ou VirtualBox de ce projet). Pas de
scan ni d'exploitation d'IP/domaines hors de ce labo depuis ce projet.

## Méthodologie suivie (voir ms3/parcours.md, ms1/parcours.md et ms2/parcours.md)

Un service à la fois : reconnaissance (`nmap -sC -sV`) → énumération → réflexion avant de
chercher un exploit → tentative manuelle avant Metasploit → exploitation → post-exploitation.
Tout est noté dans un carnet de bord (commandes, résultats, hypothèses).

## Commandes utiles

Chaque VM a son script de démarrage dans son dossier :
```bash
./ms3/start.sh   # Metasploitable 3 — Vagrant, 172.28.128.3
./ms1/start.sh   # Metasploitable 1 — VirtualBox, 172.28.128.4 (console : msfadmin/msfadmin)
./ms2/start.sh   # Metasploitable 2 — VirtualBox, 172.28.128.5 (console : msfadmin/msfadmin)
```

```bash
./ms3/stop.sh    # MS3
./ms1/stop.sh    # MS1
./ms2/stop.sh    # MS2
```
