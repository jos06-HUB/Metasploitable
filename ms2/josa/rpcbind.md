# Write-up — rpcbind (Metasploitable 2, port 111)

> 🚧 **Réservé par josa — write-up à venir.** Service pris dans le lot josa pour MS2, pas
> encore traité. Ne pas prendre côté jules.

Cible : `192.168.56.101` (réseau josa `vboxnet0`) · Kali/LHOST : `192.168.56.1`.

Approche prévue (voir `ms2/parcours.md` §19) : énumération RPC pure (`rpcinfo -p`), révèle les
services RPC dynamiques (mountd, nlockmgr, status) et leurs ports réels — prérequis pour NFS.
