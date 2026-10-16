# Write-up — MySQL 5.0.51a (Metasploitable 2, port 3306)

> 🚧 **Réservé par josa — write-up à venir.** Service pris dans le lot josa pour MS2, pas
> encore traité. Ne pas prendre côté jules.

Cible : `192.168.56.101` (réseau josa `vboxnet0`) · Kali/LHOST : `192.168.56.1`.

Approche prévue (voir `ms2/parcours.md` §11) : identifiants faibles (`root:root` ou vide),
puis lecture de fichiers via `LOAD_FILE` si privilège `FILE` accordé. Comparer avec MySQL
MS1 (déjà traité par josa).
