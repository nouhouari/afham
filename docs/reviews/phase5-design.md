# Compte-rendu — Revue design Phase 5 (fiche mot / word-detail)

**VERDICT: À CORRIGER**

Revue UX/visuelle (lecture seule) de l'incrément Phase 5 par l'agent
`ux-design-advisor`, contre la direction retenue en Phase 0 (sobre, épuré, premium,
spirituel — esprit Tarteel / Pillars) et les palettes verrouillées Daftar (clair) /
Sakīna (sombre) de `lib/core/theme/app_tokens.dart`.

Portée : `word_detail_sheet.dart`, `word_detail_screen.dart`, `search_screen.dart`,
`root_family_screen.dart`.

## Points forts

- **Hiérarchie de la fiche réussie** : le lemme arabe est clairement le héros ; les
  5 sections (traduction, racine, tafsir, pépite, astuce mémo) sont bien
  différenciées et scannables sans casser le flux de lecture.
- **Usage discipliné des tokens** : couleurs/typos passent par `BayanTokens` plutôt
  que des valeurs en dur ; thèmes clair et sombre tous deux honorés.
- **RTL / typographie arabe correcte** : directionnalité, interligne et alignement de
  l'arabe (Amiri) vs latin (Inter) sont bien gérés.
- **Flux recherche → fiche → famille de racine** fluide et rapide (bottom-sheet, pas
  de rupture de navigation).
- États loading / empty / error globalement présents et stylés.

## Issues

| # | Sévérité | Zone | Problème | Correction |
|---|----------|------|----------|------------|
| D1 | **blocker** | `root_family_screen.dart` (+ DAO/modèle) | L'écran famille n'affiche **jamais** la racine sur laquelle l'utilisateur a tapé : `RootFamilyItem` n'a pas de `rootAr` et le sous-titre injecte un tiret littéral. Casse silencieusement le flux « famille de mots », pourtant central au concept. | Remonter `rootAr` (JOIN `roots`) et l'afficher dans le sous-titre. (Identique au #1 du code review.) |
| D2 | major | boutons audio des cartes/tuiles (`search_screen` `_ResultCard`, `root_family` `_FamilyTile`, etc.) | Plusieurs déclencheurs audio sont des `GestureDetector` nus **sous la cible tactile minimale de 44pt**. Le bon patron existe déjà : l'`IconButton` (≥48pt) utilisé dans la fiche. | Porter tous les boutons audio à ≥44pt (réutiliser le patron de la fiche / futur `AudioPlayButton`). |
| D3 | major | thème clair (Daftar) | L'accent **or** (`#9A7B3F`) est utilisé comme couleur de **texte** sur fond clair, alors que le fichier de tokens lui-même note l'or comme non sûr pour le texte (~3,4:1 — échoue WCAG AA). | Réserver l'or au **décoratif** sur le clair ; pour le texte utiliser l'encre/`arabicTextColor`. Garder l'or-texte uniquement sur le sombre (Sakīna) où le contraste passe. |

## Règles verrouillées par cette revue (à appliquer aux phases suivantes)

1. Cibles tactiles ≥ 44pt pour tout contrôle interactif (audio inclus).
2. Or = décoratif sur le thème clair ; jamais comme couleur de texte sur Daftar.
3. Mutualiser les sous-widgets de détail entre `sheet` et `screen` (cf. duplication
   relevée par le code review).

## Note de nommage

Le brief indique **Af'ham (أَفْهَم)** ; le code/repo porte encore par endroits
**Bayan**. La direction produit est Af'ham (rebrand commit `a16d981`) — voir le suivi
du renommage résiduel dans `docs/PLAN.md`.

---

## Résolution (gate, 2026-06-04)

Périmètre approuvé : *stabiliser + corrections rapides et sûres ; différer le reste*.

**Corrigé immédiatement :**
- **D1 (blocker)** ✅ — racine remontée (`LEFT JOIN roots` + champ `rootAr`) et affichée
  dans le sous-titre de l'écran famille. Flux « famille de mots » réparé.

**Différé (suivi `docs/PLAN.md` → Phase 5.1 / polish accessibilité) :**
- **D2 (major)** — cibles tactiles audio ≥ 44pt (lié à l'extraction d'un `AudioPlayButton`
  partagé, #8 du code review).
- **D3 (major)** — retirer l'or-texte sur le thème clair (passer à l'encre). Touche
  plusieurs widgets et mérite une validation visuelle dédiée.

**État du gate :** À CORRIGER → **blocker levé** ; les deux majors d'accessibilité/contraste
sont consignés comme dette Phase 5.1 (passe de polish UI). Checkpoint Phase 5 passe avec
dette documentée. Les 3 « règles verrouillées » ci-dessus s'appliquent dès la Phase 5.1.

## Mise à jour — Phase 5.1 (2026-06-04)

Dette d'accessibilité **résolue** :
- **D2** ✅ — `AudioPlayButton` partagé (`lib/core/widgets/audio_play_button.dart`) garantit
  une cible tactile ≥ 44 pt sur toutes les surfaces (sheet, cartes résultat, mot-du-jour,
  tuiles famille). Les 4 anciens boutons `GestureDetector`/`IconButton` sont supprimés.
- **D3** ✅ — token `accentText` ajouté (encre `#7A5C3E` sur clair, or `#C9A24B` sur sombre) ;
  l'or n'est plus utilisé comme couleur de texte (racine, label Pépite, label Mot-du-jour,
  translittération de racine). L'or reste décoratif (bordures, icônes).

Les 3 règles verrouillées sont désormais respectées (≥44 pt ; or décoratif sur clair ;
sous-widgets de détail partagés — l'écran plein dupliqué a été supprimé). **Gate design : APPROUVÉ.**
Vérifié sur appareil (SM A245F) : accueil + fiche rendus correctement.
