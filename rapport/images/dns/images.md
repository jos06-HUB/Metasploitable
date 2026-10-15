# Captures — DNS ISC BIND 9.4.2 (port 53, transfert de zone)

Consignes de capture pour `services/dns.html` (à construire). Commandes identiques à
`ms1/josa/dns.md`.

> IP de ce poste (josa, réseau `vboxnet0`) : cible `192.168.56.102`.
> (Le coéquipier est sur `172.28.128.x` — ses captures à lui utiliseront ses propres IP.)

## 01-recon-nmap.png

Commande :
```bash
nmap -sC -sV -p 53 192.168.56.102
```

Encadré en rouge : `53/tcp open domain ISC BIND 9.4.2`.

## 02-axfr-echec.png

Les trois commandes à la suite :
```bash
dig axfr @192.168.56.102 metasploitable.localdomain
dig @192.168.56.102 metasploitable.localdomain SOA +short
dig @192.168.56.102 localdomain SOA
```

Encadré en rouge : `; Transfer failed.` et `status: SERVFAIL` — preuve qu'aucune zone n'est
réellement hébergée (pas juste une restriction d'accès).

## 03-version-chaos.png

Commande :
```bash
dig @192.168.56.102 version.bind CHAOS TXT +short
```

Encadré en rouge : `"9.4.2"` — fuite mineure de version, notée mais pas exploitable en soi.
