# Prompt de génération du contenu pédagogique — Af'ham / Bayan

Ce document contient **le prompt de référence** à donner à un LLM pour générer,
**lemme par lemme**, le contenu pédagogique de l'application (une fiche par lemme
coranique). La sortie est un **JSON strict** conforme à `docs/content_schema.json`
et importable tel quel par `lib/data/seed/json_seed_importer.dart`.

- Périmètre cible : **~3 400 lemmes** (couverture quasi-complète par lemme).
- Double contenu **FR + EN** obligatoire pour chaque lemme.
- 100 % offline : aucune URL, aucun appel réseau dans la donnée produite.
- Exactitude > volume : **ne jamais inventer** un verset, une racine ou une référence.

---

## 1. Procédure de génération réelle (plus tard)

Le run complet est **séparé** de cette phase. Marche à suivre :

1. Préparer une **liste d'entrée** des lemmes à traiter (lemme arabe vocalisé +
   racine connue + référence(s) verset attestée(s)). Source recommandée : un
   corpus morphologique vérifié (ex. Quranic Arabic Corpus) — **pas** la mémoire
   du modèle, pour garantir l'exactitude des versets.
2. Traiter par **lots de 20 à 50 lemmes** (limite de contexte + facilité de revue).
   Pour chaque lot, envoyer le **SYSTEM PROMPT** (§2) suivi du **USER PROMPT** (§3)
   contenant la liste du lot.
3. Le modèle renvoie **un seul objet** `{"lemmas": [ ... ]}` (voir §4 — format de
   sortie). Concaténer les lots dans un fichier `assets/db/seed/lemmas.json`
   (même structure, tableau `lemmas` fusionné).
4. **Valider** le fichier contre `docs/content_schema.json` (n'importe quel
   validateur JSON Schema draft 2020-12, ex. `ajv`, `python -m jsonschema`,
   `check-jsonschema`).
5. Brancher le fichier dans `pubspec.yaml` (`assets/db/seed/`) et lancer l'app :
   l'importeur (`json_seed_importer.dart`) charge le JSON au premier lancement si
   la base est vide. Il est **idempotent** (relançable sans doublon).

Modèle conseillé : un modèle fort en arabe classique et en exégèse, **température
basse (0–0.3)** pour la sobriété et la cohérence de translittération.

---

## 2. SYSTEM PROMPT (à coller tel quel)

```
Tu es un lexicographe du Coran et pédagogue trilingue (arabe classique, français,
anglais). Ta mission : produire, pour chaque lemme coranique fourni, une fiche
pédagogique CONCISE, EXACTE et SOBRE, destinée à des lecteurs francophones et
anglophones qui déchiffrent l'arabe sans le comprendre.

RÈGLES ABSOLUES
1. Exactitude. N'invente JAMAIS un verset, une racine, une forme de surface ou une
   référence (sourate:ayah). Si une information n'est pas attestée, ne la produis
   pas — n'extrapole pas. Mieux vaut une fiche plus courte qu'une fiche fausse.
2. Versets. N'utilise QUE des formes de surface réellement présentes dans le Coran,
   avec leur(s) référence(s) exacte(s) au format "sourate:ayah" (ex. "2:255").
   La forme de surface doit être vocalisée (avec harakat) telle qu'elle apparaît
   dans le texte coranique.
3. Sobriété. Pas de prose dévotionnelle longue, pas d'emphase, pas d'emojis. Ton
   factuel et respectueux. Chaque champ a une longueur BORNÉE (voir contraintes).
4. Translittération latine cohérente, sans signes diacritiques exotiques : utilise
   un schéma ASCII simple et régulier (a, i, u, aa, ee/ii, oo/uu, ', kh, sh, dh,
   th, gh ; hamza = '). La racine se note lettre-par-lettre séparée par des tirets,
   ex. "r-h-m", "s-l-m". Reste cohérent d'une fiche à l'autre.
5. Français correct : accents et orthographe IMPÉRATIFS (Miséricorde, piété,
   crainte révérencielle, prière…). L'anglais : orthographe britannique ou
   américaine, mais cohérente.
6. Tafsir COURT : 1 à 2 phrases d'explication contextuelle. Tu peux citer un
   exégète classique (Ibn Kathir, at-Tabari, ar-Razi…) SANS inventer de citation
   littérale ; reste sur le sens reconnu.
7. Gem (pépite) : UNE idée linguistique ou spirituelle marquante (lien de racine,
   nuance sémantique, écho coranique). Une à deux phrases.
8. Mnemonic (astuce mémo) : PRIORITÉ à une connexion avec le Darija / l'arabe
   dialectal maghrébin pour le public francophone (ex. "sber" = patiente !,
   "wqaya" = protection). Si aucun lien dialectal honnête n'existe, fournis une
   mnémotechnique universelle (proximité sonore, image mentale). N'invente pas de
   faux cognat ; si tu n'es pas sûr d'un lien étymologique, présente-le comme une
   simple aide mémoire sonore, pas comme un fait étymologique.
9. Sortie = JSON STRICT et VALIDE uniquement. Aucun texte hors du JSON, aucun
   commentaire, aucun bloc Markdown autour. Respecte EXACTEMENT le schéma fourni.

LANGUES
- "content" contient TOUJOURS deux entrées : "fr" et "en", chacune complète
  (translation, tafsir, gem, mnemonic). La mnémo FR privilégie le Darija ; la
  mnémo EN privilégie un cognat anglais/sémitique ou une image mémorisable.
```

---

## 3. USER PROMPT (gabarit par lot)

```
Génère le contenu pour les lemmes ci-dessous. Renvoie UN SEUL objet JSON de la
forme {"lemmas": [ ... ]}, un élément par lemme, dans l'ordre fourni, conforme au
schéma. Chaque lemme contient : root, lemma_ar, latin, pos, frequency,
surface_forms (1..n, chacune avec ses verses attestés), content.fr et content.en.

LEMMES À TRAITER (lot {N}) :
1. lemme_ar="رَحْمَة"  racine="ر-ح-م"  formes attestées connues=["رَحْمَةً (7:56)", "رَحْمَتُ (7:156)"]
2. lemme_ar="..."      racine="..."     formes attestées connues=[...]
...

CONTRAINTES DE LONGUEUR (caractères, indicatif — ne pas dépasser) :
- translation : <= 90      (courte, peut lister 2-3 sens séparés par virgule)
- tafsir      : <= 320     (1 à 2 phrases)
- gem         : <= 280     (1 à 2 phrases)
- mnemonic    : <= 220     (1 phrase, priorité Darija en FR)
- latin (lemme) : <= 40    ; root latin : lettres séparées par '-'
- surface_forms : 1 à 5 formes réelles ; latin de chaque forme <= 40
- verses : au moins 1 par fiche au global ; ref "sourate:ayah" exacte
```

---

## 4. Format de sortie attendu (exemple d'UN lemme)

> C'est exactement le format consommé par l'importeur. Voir
> `assets/db/seed/lemmas.sample.json` pour 5 exemples complets réels.

```json
{
  "lemmas": [
    {
      "root": { "ar": "ر-ح-م", "latin": "r-h-m" },
      "lemma_ar": "رَحْمَة",
      "latin": "rahma",
      "pos": "noun",
      "frequency": 79,
      "surface_forms": [
        {
          "text_ar": "رَحْمَةً",
          "latin": "rahmatan",
          "verses": [
            {
              "surah": 7,
              "ayah": 56,
              "text_uthmani": "إِنَّ رَحْمَتَ ٱللَّهِ قَرِيبٌ مِّنَ ٱلْمُحْسِنِينَ",
              "text_simple": "إن رحمت الله قريب من المحسنين"
            }
          ]
        }
      ],
      "content": {
        "fr": {
          "translation": "Miséricorde, bienveillance",
          "tafsir": "Ar-Rahma désigne la bienveillance active de Dieu envers Sa création ; la Basmala l'invoque sous deux formes, ar-Rahmān (étendue) et ar-Rahīm (constante).",
          "gem": "رَحْمَة partage sa racine ر-ح-م avec رَحِم (l'utérus) : la miséricorde divine évoque la tendresse maternelle.",
          "mnemonic": "Pense à « rhem » / « rahma » en Darija (pitié, tendresse) : la rahma enveloppe comme un sein maternel."
        },
        "en": {
          "translation": "Mercy, compassion",
          "tafsir": "Ar-Rahma is God's active compassion toward creation; the Basmala invokes it as ar-Rahmān (vast) and ar-Rahīm (enduring).",
          "gem": "رَحْمَة shares the root ر-ح-م with raḥim (womb): divine mercy echoes a mother's tenderness.",
          "mnemonic": "Rahma sounds like the Hebrew cognate raḥamim (mercy) — same Semitic root of womb-deep compassion."
        }
      }
    }
  ]
}
```

### Notes de mapping vers la base
- `root.ar` / `root.latin` → table `roots` (`root_ar`, `latin`) ;
  `root_normalized` est **calculé** à l'import (`normalizeArabic`).
- `lemma_ar`, `latin`, `pos`, `frequency` → table `lemmas` ;
  `search_key` est **calculé** à l'import.
- `surface_forms[].text_ar`, `latin` → table `surface_forms` ;
  `search_key` **calculé** à l'import. La FTS5 est alimentée par triggers.
- `surface_forms[].verses[]` → table `verses` (clé d'unicité `surah:ayah`) +
  `occurrences` (lien forme↔verset ; `position` par défaut 0 si non fourni).
- `content.fr` / `content.en` → table `word_content` (une ligne par langue).

### Champs optionnels tolérés par l'importeur
- `surface_forms[].verses[].position` (int, défaut 0).
- `surface_forms[].verses[].text_simple` (défaut : `normalizeArabic(text_uthmani)`).
- `pos` (défaut `"noun"`), `frequency` (défaut `0`).

---

## 5. Liste blanche `pos`
`noun`, `verb`, `adjective`, `adverb`, `particle`, `pronoun`, `proper_noun`,
`preposition`, `conjunction`, `interjection`.
