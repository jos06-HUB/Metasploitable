# Write-up — Samba usermap_script (Metasploitable 2, ports 139/445)

> 🚧 **Réservé par josa — write-up à venir.** Service pris dans le lot josa pour MS2, pas
> encore traité. Ne pas prendre côté jules.

Cible : `192.168.56.101` (réseau josa `vboxnet0`) · Kali/LHOST : `192.168.56.1`.

Approche prévue (voir `ms2/parcours.md` §4) : CVE-2007-2447 — `username map script` mal
configuré permet d'injecter des commandes shell via le nom d'utilisateur.
`exploit/multi/samba/usermap_script`. Reconnaissance d'abord (`nmap -sC -sV -p 139,445`).
