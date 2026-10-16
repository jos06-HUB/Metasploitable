# Write-up — Web Apache + applis (Metasploitable 2, port 80)

> 🚧 **Réservé par josa — write-up à venir.** Service pris dans le lot josa pour MS2, pas
> encore traité. Ne pas prendre côté jules.

Cible : `192.168.56.101` (réseau josa `vboxnet0`) · Kali/LHOST : `192.168.56.1`.

Approche prévue (voir `ms2/parcours.md` §16) : plusieurs applis vulnérables empilées (DVWA,
Mutillidae, phpMyAdmin, TWiki). Énumération (`gobuster`/`ffuf`) puis techniques propres à
chaque appli (injections SQL, upload, LFI). À découper éventuellement en sous-cibles.
