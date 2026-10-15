# Règles pour un write-up exploitable (source du rapport)

Un write-up `.md` (dans `ms1/<jules|josa>/`, `ms2/<jules|josa>/`, `ms3/<jules|josa>/`) est
la **matière première** du rapport HTML
— c'est de là que le rapport reprend son contenu. S'il est mal rédigé, le rapport hérite des
mêmes trous. Ces règles définissent ce qui rend un write-up "exploitable" : directement
réutilisable pour le rapport, sans qu'on ait à deviner ou à revérifier après coup.

**Référence à suivre : [`ms2/jules/vsftpd.md`](ms2/jules/vsftpd.md).** Ce write-up montre à
chaque étape la méthode utilisée en pratique, explique le "pourquoi", et surtout : **aucune
information n'y sort de nulle part.** Chaque fait (CVE, chemin de module, mécanisme de la
faille) est précédé de la commande qui a permis de l'obtenir. C'est le modèle à reproduire
pour chaque nouveau service.

---

## Règle n°1 — Aucune info ne sort de nulle part

Chaque fait affirmé dans le write-up doit être **précédé de la commande qui l'a produit**,
avec sa vraie sortie. Interdit :

```markdown
❌ CVE-2011-2523. Backdoor dans vsftpd 2.3.4.
```

Obligatoire :

```markdown
✅ msfconsole -q -x "info exploit/unix/ftp/vsftpd_234_backdoor; exit"
   → References: https://nvd.nist.gov/vuln/detail/CVE-2011-2523
   → Donc : CVE-2011-2523.
```

Si une information est connue "par cœur" (formation, expérience) plutôt que trouvée en
direct dans la session, **le dire explicitement** plutôt que de la présenter comme déduite
d'une commande qu'on n'a pas réellement tapée. Exemple vécu : le chemin du module
`vsftpd_234_backdoor` était d'abord connu de mémoire — corrigé en montrant la vraie commande
(`search vsftpd` dans `msfconsole`) qui permet de le retrouver soi-même.

## Règle n°2 — Respecter l'ordre logique de la démarche

L'ordre des étapes doit suivre une vraie dépendance, pas un ordre arbitraire :

1. **Reconnaissance** — identifier le service et sa version exacte (`nmap -sV`)
2. **Existence d'une faille connue** — question indépendante de tout outil
   (`searchsploit <produit> <version>`), la plus légère/rapide à vérifier en premier
3. **Module d'exploitation** — une fois confirmé qu'une faille existe, chercher le module
   spécifique à l'outil choisi (`search <produit>` dans `msfconsole`)
4. **CVE et mécanisme** — obtenir la référence précise (`info <module>`) et expliquer
   *pourquoi* la faille fonctionne, pas juste *qu'elle* existe
5. **Exploitation** — commande(s) réellement exécutée(s), avec la vraie sortie
6. **Preuve d'accès** — vérification explicite du résultat (`id`, `whoami`, etc.)

Ne pas inverser ces étapes pour "faire joli" — si `searchsploit` est passé avant
`msfconsole search` dans la vraie session, le write-up doit le refléter dans cet ordre.

## Règle n°3 — Commandes copier-coller réellement testées

- Toute commande affichée doit avoir été **exécutée telle quelle**, pas une version
  "nettoyée" après coup qui n'a jamais tourné réellement.
- Vérifier la portabilité shell : pas de syntaxe bash-only (`/dev/tcp/...`) si le lecteur
  travaille en zsh — préférer `nc`, ou préciser explicitement la dépendance à bash.
- Si une commande a échoué puis a été corrigée (ex. mauvais payload, mauvais flag), montrer
  l'échec réel et la correction plutôt que de ne garder que la version finale qui marche —
  ça fait partie de la démarche et ça évite qu'un lecteur retombe dans le même piège sans
  prévenir.

## Règle n°4 — Expliquer le mécanisme, pas juste citer la CVE

Un numéro de CVE seul ne suffit pas. Expliquer **comment** la faille fonctionne concrètement
(ex. "le code injecté vérifie si le username contient `:)`, puis ouvre un shell sur le port
6200") — assez pour qu'un lecteur comprenne la cause racine, pas juste qu'il y a un problème.

## Règle n°5 — Pas de dramatisation inutile

Réserver les alertes (`⚠️`, mentions de "piège") aux comportements **réellement surprenants**
— un outil qui se comporte différemment de sa documentation, une config qui ment sur ce
qu'elle fait réellement. Ne pas qualifier de "piège" ce qui est juste l'usage normal d'un
outil (ex. régler `LHOST` pour un payload reverse n'est pas un piège, c'est comment
Metasploit fonctionne tout le temps). Une note factuelle neutre suffit dans ce cas.

## Règle n°6 — Résultat final vérifiable

Terminer par une preuve d'accès explicite et sans ambiguïté (`id`, `uname -a`, `hostname`
exécutés **dans la session obtenue**, pas en local par erreur — vérifier qu'on est bien
`sessions -i <id>` avant de taper une commande).

---

## Checklist avant de considérer un write-up terminé

- [ ] Chaque CVE/chemin de module est précédé de la commande qui l'a trouvé
- [ ] L'ordre des étapes suit la vraie chronologie de la démarche
- [ ] Toutes les commandes affichées ont réellement été exécutées (pas de "version propre"
      jamais testée)
- [ ] Le mécanisme de la faille est expliqué, pas juste nommé
- [ ] Aucun "piège"/"⚠️" sur un comportement normal d'un outil
- [ ] Preuve d'accès finale claire et vérifiée (pas d'exécution locale confondue avec la
      cible)
- [ ] Relu en se demandant : *"si je recolle ça dans le rapport HTML, est-ce que chaque
      phrase est justifiée par ce qui précède ?"*
