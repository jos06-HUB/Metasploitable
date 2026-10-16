# Write-up — distccd (Metasploitable 2, port 3632)

> 🚧 **Réservé par josa — write-up à venir.** Service pris dans le lot josa pour MS2, pas
> encore traité. Ne pas prendre côté jules.

Cible : `192.168.56.101` (réseau josa `vboxnet0`) · Kali/LHOST : `192.168.56.1`.

Approche prévue (voir `ms2/parcours.md` §6) : CVE-2004-2687 — ici `--allow 0.0.0.0/0` (contre
une whitelist restrictive sur MS1), donc RCE direct sans obstacle ACL.
`exploit/unix/misc/distcc_exec`. Comparer la config à celle de MS1.
