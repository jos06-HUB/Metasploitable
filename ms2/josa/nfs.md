# Write-up — NFS root export (Metasploitable 2, port 2049)

> 🚧 **Réservé par josa — write-up à venir.** Service pris dans le lot josa pour MS2, pas
> encore traité. Ne pas prendre côté jules.

Cible : `192.168.56.101` (réseau josa `vboxnet0`) · Kali/LHOST : `192.168.56.1`.

Approche prévue (voir `ms2/parcours.md` §9) : export `/` en `rw,no_root_squash`
(`showmount -e`), montage depuis Kali, lecture/écriture directe du filesystem cible — dépôt
d'une clé SSH dans `/root/.ssh/` pour un accès root sans exploit.
