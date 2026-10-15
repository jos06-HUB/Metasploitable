# Règles — Captures d'écran du rapport

Ce document couvre tout ce qui concerne les images du rapport : nommage des fichiers, et le
fichier `images.md` qui documente chaque capture. Pour la structure générale du rapport et
des pages HTML, voir [`REGLES.md`](REGLES.md). Pour la qualité des write-ups sources, voir
[`regle_writup.md`](../regle_writup.md).

---

## 1. Nommage des fichiers

Format : `NN-description-courte.png`.

**Pas de liste figée de noms à respecter** — le nombre de captures varie selon le service
(certains ont une étape de diagnostic en plus, d'autres vont droit à l'exploitation). La
règle est simple et s'applique à n'importe quel service :

- **`NN`** = position de la figure dans la page, dans l'ordre d'apparition (`01`, `02`,
  `03`...) — doit correspondre exactement au nombre affiché dans `<strong class="idx">` du
  `<figcaption>`.
- **`description-courte`** = 2-4 mots en minuscules, tirets, qui résument ce que montre
  *cette* capture précise (`recon-nmap`, `searchsploit`, `diagnostic-acl`,
  `exploit-msfconsole`, `session-root`...) — pas une case à cocher dans une liste prédéfinie.

Exemple réel (`vsftpd.html`, 4 captures) :
```
01-recon-nmap.png
02-searchsploit.png
03-exploit-msfconsole.png
04-session-root.png
```

Un service avec une étape de diagnostic en plus (ex. `distcc`) aurait simplement une capture
de plus, insérée à sa place chronologique, et toutes les suivantes renumérotées en
conséquence.

**Chaque capture doit montrer la commande tapée ET son résultat** — pas juste un bout de
sortie sans contexte. Capturer le terminal en entier (prompt visible), pas un recadrage trop
serré.

## 2. `images.md` — obligatoire dans chaque `images/<service>/`

Avant de prendre les captures (ou juste après), créer `images.md` dans le dossier
`images/<service>/` qui documente **chaque** image : son nom, la commande exacte qui produit
ce qu'elle montre, et — si nécessaire pour que le prof voie direct ce qu'il faut regarder —
quelle partie encadrer en rouge sur l'image avant de l'enregistrer.

Format, une section par capture :

```markdown
## 01-recon-nmap.png

Commande :
```bash
nmap -sV -p 21 172.28.128.5
```

Encadrer en rouge : la ligne de version (`vsftpd 2.3.4`)

## 02-searchsploit.png

Commande :
```bash
searchsploit vsftpd 2.3.4
```

Encadrer en rouge : aucun (résultat déjà court et lisible en entier)
```

- La commande listée ici doit être **identique** à celle qui apparaît dans le write-up
  source (`ms*/<prénom>/<service>.md`) — pas une approximation.
- "Encadrer en rouge" sert uniquement quand le résultat pertinent est noyé dans une sortie
  plus longue (ex. une ligne au milieu d'un scan nmap complet, un `uid=0` au milieu d'une
  sortie `id` plus verbeuse). Si toute la sortie capturée est déjà courte et pertinente,
  écrire "aucun" plutôt que d'encadrer par réflexe.
- `images.md` sert de checklist avant de commencer à prendre les captures : si une commande
  manque de contexte pour savoir quoi capturer exactement, c'est que le write-up source n'est
  pas assez précis — corriger le write-up d'abord (voir `regle_writup.md`).

## 3. Exemple de référence

Dossier complet à dupliquer comme modèle : [`images/vsftpd/`](images/vsftpd/) (4 captures +
son `images.md`).

## 4. Ce qu'on évite

- Pas de capture d'écran floue/illisible — retake plutôt que de mettre une image où le texte
  ne se lit pas.
