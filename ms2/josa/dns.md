# Write-up — DNS BIND 9.4.2 (Metasploitable 2, port 53)

> 🚧 **Réservé par josa — write-up à venir.** Service pris dans le lot josa pour MS2, pas
> encore traité. Ne pas prendre côté jules.

Cible : `192.168.56.101` (réseau josa `vboxnet0`) · Kali/LHOST : `192.168.56.1`.

Approche prévue (voir `ms2/parcours.md` §17) : énumération DNS, transfert de zone
(`dig axfr @192.168.56.101 metasploitable.localdomain`), + `searchsploit bind 9.4.2` pour
DoS/RCE connus. Sur MS1 la DNS n'avait rien donné — vérifier si MS2 diffère.
