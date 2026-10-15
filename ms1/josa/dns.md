# Write-up — DNS (ISC BIND 9.4.2) : tentative de transfert de zone (Metasploitable 1, port 53)

Cible : `192.168.56.102` · Résultat : **transfert de zone refusé, aucune zone exploitable
trouvée** — service qui ne donne rien ici, documenté honnêtement plutôt que de s'acharner.

> **Note réseau.** Je suis sur `vboxnet0` (cible `192.168.56.102`). Côté coéquipier (réseau
> `172.28.128.x`), remplacer l'IP — démarche identique.

---

## 1. Recon

🖥 Kali :
```bash
nmap -sC -sV -p 53 192.168.56.102
```
Sortie :
```
53/tcp open  domain  ISC BIND 9.4.2
| dns-nsid:
|_  bind.version: 9.4.2
```
→ **ISC BIND 9.4.2** confirmé.

## 2. Tentative de transfert de zone (AXFR)

🖥 Kali — technique visée par le parcours : transfert de zone sur le FQDN déjà identifié lors
de l'énumération Samba (`samba-enum.md`, `smb-os-discovery` → `metasploitable.localdomain`) :
```bash
dig axfr @192.168.56.102 metasploitable.localdomain
```
Sortie :
```
; Transfer failed.
```
**Échec.** Avant de conclure trop vite, vérification que la zone existe réellement sur ce
serveur (un AXFR peut échouer soit parce que le transfert est restreint, soit parce que la
zone elle-même n'existe pas sur ce serveur) :
```bash
dig @192.168.56.102 metasploitable.localdomain SOA +short
```
```
(aucune réponse)
```
```bash
dig @192.168.56.102 localdomain SOA
```
```
;; ->>HEADER<<- opcode: QUERY, status: SERVFAIL, ...
```
→ **`SERVFAIL`**, et aucun enregistrement `SOA` renvoyé pour `metasploitable.localdomain` : ce
serveur BIND n'héberge pas réellement la zone `metasploitable.localdomain` comme zone
autoritaire — c'est probablement un résolveur BIND minimal/par défaut, sans zone personnalisée
configurée pour ce domaine. Le transfert échoue donc parce qu'**il n'y a rien à transférer**,
pas (seulement) à cause d'une restriction d'accès.

## 3. Autres pistes vérifiées

```bash
dig @192.168.56.102 version.bind CHAOS TXT +short
```
```
"9.4.2"
```
→ La divulgation de version via la classe CHAOS fonctionne (confirme la version lue par
`nmap`), mais c'est une fuite d'information mineure, pas une faille exploitable en soi.

## 4. Conclusion

Contrairement à distcc/Tomcat/TikiWiki/TWiki/Samba/MySQL/PostgreSQL/AJP13, ce service **ne
donne rien d'exploitable** avec les techniques standards testées (transfert de zone, requêtes
SOA). Conformément à la règle du jeu du labo ("accepter qu'un service peut ne rien donner, ne
pas s'acharner, noter l'hypothèse et passer au suivant"), on s'arrête ici plutôt que de forcer
une conclusion. Hypothèse retenue : le service BIND de cette VM est configuré en résolveur
minimal, sans zone de test volontairement exposée (contrairement à d'autres labos où une zone
AXFR ouverte est délibérément présente).

---

## Remédiation

(Préventif malgré l'absence de faille confirmée ici — bonnes pratiques génériques pour BIND.)

- Si une zone est un jour configurée sur ce serveur, restreindre les transferts de zone
  (`allow-transfer`) aux seuls serveurs secondaires légitimes.
- Désactiver la divulgation de version (`version "non disponible";` dans `named.conf` au lieu
  de la vraie chaîne de version), pour ne pas faciliter le ciblage de CVE connues par version.
- Mettre à jour BIND : la 9.4.2 (2008) est très ancienne et hors support, même si aucune faille
  directement exploitable n'a été trouvée via cette approche précise.

## Sources

- Session réelle (ce write-up) — `nmap`, `dig axfr`, vérifications `SOA`/`SERVFAIL`,
  confirmation CHAOS `version.bind`.

**Suite du parcours MS1 :** SMTP — Postfix (port 25), énumération d'utilisateurs via
`VRFY`/`EXPN`.
