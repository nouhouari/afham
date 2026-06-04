# Compte-rendu — Revue de code Phase 5 (fiche mot / word-detail)

**VERDICT: À CORRIGER**

Portée revue : `models/lemma_detail.dart`, `daos/word_detail_dao.dart`,
`word_detail_sheet.dart`, `word_detail_screen.dart`, `root_family_screen.dart`,
`search_screen.dart`, `database_provider.dart`. Vérifié contre `tables.drift` et
`app_router.dart`. Revue en lecture seule (aucune modification).

Bilan SQL : les trois requêtes brutes du DAO référencent des colonnes/tables
réelles et les JOINs sont corrects (voir détail plus bas). Le bug bloquant est
côté présentation : la racine tapée n'est jamais affichée sur l'écran famille.

---

## Findings

| # | Sévérité | Fichier:ligne | Problème | Correction |
|---|----------|---------------|----------|------------|
| 1 | **blocker** | `root_family_screen.dart:132-141` + `daos/word_detail_dao.dart:114-158` + `models/lemma_detail.dart:108-151` | Le DESIGN review est **confirmé**. `RootFamilyScreen` ne reçoit qu'un `rootId`. Le sous-titre i18n `rootFamily.subtitle` = « Mots partageant la racine {root} » mais `{root}` est remplacé par un tiret cadratin littéral (`items.isNotEmpty ? '–' : ''`), jamais par la racine réelle. `lemmasByRoot` SELECT sur `lemmas/word_content/audio_clips` **sans JOIN `roots`**, et `RootFamilyItem` n'a ni `rootAr` ni `rootLatin`. La donnée n'existe nulle part dans le flux → l'utilisateur ne voit jamais la racine sur laquelle il a tapé. | Ajouter `JOIN roots r ON r.id = l.root_id` à `lemmasByRoot`, exposer `rootAr`/`rootLatin` (soit sur chaque `RootFamilyItem`, soit via une 2ᵉ petite requête `SELECT root_ar, latin FROM roots WHERE id = ?`, soit un nouveau modèle d'en-tête). Puis brancher `replaceAll('{root}', rootAr)`. Alternative pragmatique : passer `rootAr` en `extra`/query-param depuis `_RootBlock` (sheet) lors du `goNamed`, mais ça casse le deep-link direct `/root/:rootId`. |
| 2 | major | `daos/word_detail_dao.dart:165-183` (`wordOfDay`) | `dayIndex % count` avec `dayIndex = DateTime.now().day` (1-31). Le « mot du jour » ne couvre donc jamais que les ~31 premiers lemmas triés par `id` (`OFFSET index`). Au-delà de 31 lemmas, la majorité du corpus n'est jamais sélectionnable, et il n'y a aucune variation mois-à-mois (le 4 juin et le 4 juillet donnent le même mot). 3 requêtes séquentielles (`COUNT` → `id` → `getLemmaDetail` qui fait elle-même 2 requêtes) = 4 aller-retours DB. | Utiliser un index dérivé de l'époque complète, p.ex. `daysSinceEpoch % count` calculé côté UI, ou un hash de la date. Acceptable pour un MVP mais à noter comme limite fonctionnelle. |
| 3 | major | `word_detail_screen.dart` (fichier entier) vs `word_detail_sheet.dart` | Duplication massive de widgets (voir section Reuse). `WordDetailScreen` est routé via `/word/:lemmaId` (`app_router.dart:24-32`) mais **aucun appelant ne navigue vers `wordDetail`** : toutes les entrées (`search_screen.dart:358,617`, `root_family_screen.dart:194`) appellent `showWordDetailSheet`. L'écran est du code mort de facto (uniquement atteignable par deep-link manuel). | Soit supprimer `WordDetailScreen` et la route, soit le faire réutiliser les sous-widgets de `word_detail_sheet.dart` au lieu de les redéfinir. |
| 4 | minor | `root_family_screen.dart:124-142` | `_RootFamilyList` reçoit `rootId` mais ne l'utilise pas (le `SliverToBoxAdapter` d'en-tête n'affiche que le tiret). Paramètre mort tant que #1 n'est pas corrigé. | Sera consommé en corrigeant #1, sinon retirer le param. |
| 5 | minor | `word_detail_sheet.dart:73-76` | Message d'erreur « not found » en dur en anglais (`'Lemma #$lemmaId not found'`), alors que `word_detail_screen.dart:39-43` utilise `strings.error` localisé. Incohérence de localisation. | Utiliser une clé i18n (`strings.word.notFound` ou `strings.error`). |
| 6 | minor | `search_screen.dart:461-463` | `_SearchPrompt` n'a pas de constructeur `const` (et est instancié sans `const` l.281,283) alors qu'il renvoie `const SizedBox.shrink()`. Rebuilds inutiles. | Ajouter `const _SearchPrompt();` et préfixer les usages de `const`. |
| 7 | minor | `search_screen.dart:738-759` (`_PosLabel`) vs `word_detail_*` `_PosPill` | `_ResultCard` affiche le POS brut (`result.pos`, p.ex. « noun ») sans le `switch` de traduction présent dans `_PosPill` (sheet/screen). Incohérence d'affichage du POS entre la liste de recherche et la fiche. | Factoriser un seul widget POS partagé qui fait le mapping i18n. |
| 8 | nice-to-have | `word_detail_sheet.dart:642`, `word_detail_screen.dart:452`, `root_family_screen.dart:261`, `search_screen.dart:486,784` | 5 copies quasi-identiques d'un bouton audio `StreamBuilder<AudioPlaybackState>` (idle/loading/playing). Logique dupliquée 5×. | Extraire un `AudioPlayButton({required AudioClip? clip, required double size, ...})` partagé. |

---

## 1. Correctness (détail SQL)

- **`getLemmaDetail` (l.28-57)** : colonnes et JOINs corrects vs schéma.
  `LEFT JOIN roots`, `LEFT JOIN word_content … AND wc.lang_code = ?`,
  `LEFT JOIN audio_clips ON ac.id = l.audio_id` — tous valides. `COALESCE(r.id,0)`
  gère le cas lemma sans racine (`root_id` nullable, l.24-31 schéma) → `rootId=0`,
  et `hasRoot` (`lemma_detail.dart:79`) le filtre correctement. `langCode` défaut
  `'fr'` cohérent partout. Le `LEFT JOIN word_content` + `COALESCE(...,'')` est
  robuste si la langue demandée n'a pas de ligne. RAS. ✔
- **Sous-requête versets (l.63-78)** : `occurrences → surface_forms → verses`
  conforme aux FK du schéma (`occ.surface_form_id`, `occ.verse_id`,
  `sf.lemma_id`). `DISTINCT` + `ORDER BY surah,ayah` + `LIMIT 2` OK. Note : le
  `LIMIT 2` prend toujours les 2 premiers versets dans l'ordre sourate/ayah (pas
  les plus pertinents), comportement acceptable mais à documenter. ✔
- **`lemmasByRoot` (l.118-140)** : SQL valide, `ORDER BY frequency DESC` OK.
  Manque seulement le JOIN `roots` (finding #1). ✔ (sauf #1)
- **`wordOfDay` (l.165-183)** : pas de crash — `getSingle` est sûr car `COUNT`
  renvoie toujours 1 ligne et l'`OFFSET` est borné par `index < count`. Le défaut
  fonctionnel est la couverture limitée (finding #2). `count==0` géré (l.172). ✔
- **Null-safety** : `readNullable` utilisé partout pour l'audio ; `hasAudio`
  vérifie les 4 champs. Le `clip!.id` (sheet l.647, screen l.457, etc.) est sûr
  car gardé par `if (clip == null) return …` au-dessus. ✔
- **Router** : `int.tryParse(...) ?? 0` (app_router l.29,37) → un id invalide
  donne `0` ; `getLemmaDetail(0)` renvoie `null` → branche « not found » correcte.
  `lemmasByRoot(0)` renvoie liste vide → état vide. Pas de crash. ✔

## 2. Reuse / duplication (quantifié)

`word_detail_screen.dart` (492 l.) et `word_detail_sheet.dart` (687 l.)
redéfinissent **les mêmes sous-widgets** avec des noms différents :

| Sheet | Screen | Duplication |
|-------|--------|-------------|
| `_HeaderBlock` (l.245-303) | `_HeaderBlock` (l.120-173) | ~identique |
| `_FactBlock` (l.307-331) | `_FactBlock` (l.175-198) | identique |
| `_RootBlock` (l.335-405, tappable) | `_RootChip` (l.200-244, non tappable) | ~80% |
| `_GemBlock`+`_MemoBlock`+`_HighlightBox` (l.409-511) | `_GemBox`+`_MemoBox`+`_BoxedBlock` (l.246-334) | ~identique |
| `_VersesBlock` (l.515-575) | `_VersesSection` (l.336-395) | identique |
| `_PosPill` (l.579-615) | `_PosPill` (l.397-428) | identique |
| `_SheetAudioButton` (l.619-686) | `_AudioButton` (l.430-491) | identique |

Soit **~7 paires de widgets dupliqués**, ≈ 350 lignes redondantes. Le commentaire
`word_detail_screen.dart:117-118` (« mirror _SheetContent sub-widgets … reuses the
same widgets ») est trompeur : rien n'est réutilisé, tout est recopié. De plus
`WordDetailScreen` est non routé en pratique (finding #3). **Recommandation** :
extraire un `word_detail_blocks.dart` partagé (header, fact, gem/memo box, verses,
pos, audio button) consommé par les deux ; ou supprimer purement l'écran.

Le bouton audio est dupliqué **5×** au total à travers les 3 écrans (finding #8).

## 3. Efficiency

- N+1 : aucun dans les listes (une requête `lemmasByRoot` / `searchLemmas`).
  `wordOfDay` fait 4 requêtes séquentielles (finding #2) mais hors boucle.
- `Translations.of(context)` appelé de façon répétée dans plusieurs widgets
  (p.ex. sheet `_SheetContent` l.201,216 le rappelle au lieu de réutiliser une
  variable locale `strings`). Mineur — lookup `InheritedWidget` O(1).
- `const` manquant : finding #6.
- Listes : `SliverList.separated`/`ListView.separated` sans `key` sur les items
  (root_family l.152-153, search l.581-582). Acceptable ici (listes courtes,
  identité par `lemmaId` via `==`), mais ajouter `ValueKey(item.lemmaId)` serait
  plus sûr si les listes deviennent réordonnables.

## 4. Riverpod

- `appDatabaseProvider` `@Riverpod(keepAlive: true)` + `ref.onDispose(db.close)`
  correct (database_provider l.17-22).
- `lemmaDetail`/`rootFamilyItems`/`wordOfDay`/`searchResults` : family providers
  `Future`, `ref.watch(appDatabaseProvider)` correct.
- `searchResults` (l.61-67) `watch`e `searchQueryProvider` → recalcul à chaque
  frappe sans debounce. Acceptable pour FTS local mais un debounce léger
  améliorerait le ressenti. Non bloquant.
- UI : `ref.watch` pour les async (sheet l.45, screen l.24, root_family l.24),
  `ref.read(...notifier)` pour les mutations (search l.121,144). Correct.
- `wordOfDay`/`lemmaDetail` ne sont pas `keepAlive` → ré-exécutés si le widget se
  démonte/remonte. OK pour ce flux. La provider family `wordOfDay(dayOfMonth)`
  est recréée si la date change (auto-dispose des anciennes), correct.

## 5. Consistency (loading/empty/error)

- Loading : sheet `_SheetLoading` (centré, spinner), screen spinner centré,
  root_family spinner centré, search `_LoadingState`, + skeleton dédié pour le
  mot du jour. Cohérent. ✔
- Empty : root_family `_EmptyState` (icône+texte i18n) ✔ ; search `_NoResults` +
  `_EmptyHome` ✔. Sheet : « not found » non localisé (finding #5).
- Error : screen/root_family/search affichent un état d'erreur stylé ; sheet aussi
  mais avec `e.toString()` brut. Les `catch (_) {}` autour de `playClip`
  (sheet l.678, screen l.485, root_family l.289, search l.513,810) avalent
  silencieusement les erreurs audio — voulu en dev, mais aucune remontée
  utilisateur en prod si un pack manque. À surveiller.

---

## À corriger pour passer le gate (must-fix)

1. **#1 (blocker)** — afficher la racine réelle sur l'écran famille (JOIN `roots`
   + champ `rootAr` + `replaceAll('{root}', rootAr)`).
2. **#3 (major)** — trancher sur `WordDetailScreen` : le faire réutiliser les
   sous-widgets partagés, ou le supprimer avec sa route (actuellement code mort
   + ~350 lignes dupliquées).
3. **#2 (major)** — corriger/documenter la logique `wordOfDay` (couverture limitée
   à ~31 lemmas, pas de variation mensuelle).

## Nice-to-have / defer

- #5 localiser le message « not found » du sheet.
- #6 `const` sur `_SearchPrompt`.
- #7 mapping i18n du POS partagé entre liste et fiche.
- #8 extraire un `AudioPlayButton` partagé (dédupliquer 5 copies).
- Debounce sur la recherche ; `ValueKey` sur les items de liste ; remontée
  utilisateur en cas d'échec audio en prod.

## Sous-section Reuse / simplification (synthèse)

~350 lignes dupliquées entre `word_detail_screen.dart` et `word_detail_sheet.dart`
(7 paires de widgets), + bouton audio recopié 5× à travers les écrans. Extraire
`word_detail_blocks.dart` (header / fact / highlight-box / verses / pos /
audio-button) ramènerait les deux fichiers à un assemblage mince, et permettrait
de supprimer le doute « screen vs sheet ».

---

## Résolution (gate, 2026-06-04)

Périmètre approuvé : *stabiliser + corrections rapides et sûres ; différer le reste*.

**Corrigé immédiatement :**
- **#1 (blocker)** ✅ — `lemmasByRoot` fait désormais `LEFT JOIN roots`, `RootFamilyItem`
  porte un champ `rootAr`, et `root_family_screen.dart` affiche `items.first.rootAr`
  dans le sous-titre. La racine tapée s'affiche. (Aucun codegen requis : modèle écrit
  à la main + SQL `customSelect`.)
- **Lints** ✅ — imports `app_router` inutilisés retirés (`search_screen`,
  `word_detail_sheet`) ; 3 `unnecessary_underscores` corrigés. `flutter analyze` = 0 issue.

**Différé (suivi dans `docs/PLAN.md` → Phase 5.1 / dette) :**
- **#3 (major)** — supprimer/mutualiser `WordDetailScreen` (code mort + ~350 l. dupliquées)
  → extraire `word_detail_blocks.dart`. Refactor, hors périmètre « stabiliser ».
- **#2 (major)** — couverture `wordOfDay` (limitée à ~31 lemmas, pas de variation mensuelle).
  Impact négligeable sur le seed de 20 lemmas ; à corriger quand le corpus grossit.
- **#5–#8 + #4** — « not found » non localisé, `const _SearchPrompt`, POS i18n partagé,
  `AudioPlayButton` partagé, debounce recherche, `ValueKey` listes.

**État du gate :** À CORRIGER → **blocker levé** ; les majors/mineurs restants sont
consignés comme dette Phase 5.1. Le checkpoint Phase 5 passe avec dette documentée.
