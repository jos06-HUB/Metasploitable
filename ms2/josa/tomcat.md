# Write-up — Tomcat (Metasploitable 2, port 8180)

> 🚧 **Réservé par josa — write-up à venir.** Service pris dans le lot josa pour MS2, pas
> encore traité. Ne pas prendre côté jules.

Cible : `192.168.56.101` (réseau josa `vboxnet0`) · Kali/LHOST : `192.168.56.1`.

Approche prévue (voir `ms2/parcours.md` §13) : identifiants manager faibles (`tomcat:tomcat`),
déploiement d'un WAR malveillant → shell. Mêmes techniques que Tomcat MS1 (déjà traité par
josa).
