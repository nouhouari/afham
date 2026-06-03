import 'package:flutter/material.dart';

/// Bayan design-system tokens exposed as a [ThemeExtension].
///
/// Daftar (light):
///   - surface background : #F5F0E8  (ivoire/papier)
///   - primary (encre)    : #7A5C3E  (brun-chaud)
///   - accent (or mat)    : #9A7B3F  — bordures/filets only (3.4:1, not text-safe on light)
///   - secondary (vert)   : #3D6B52  — Astuce Mémo block
///   - highlight          : #EDE3CE  — fond Pépite block
///
/// Sakīna (dark):
///   - surface background : #16241D  (vert-nuit)
///   - primary (or)       : #C9A24B  — text-safe on dark (6.7:1)
///   - accent             : #C9A24B  — same as primary in dark; or discret
///   - secondary          : #3D7A58  — Astuce Mémo block
///   - highlight          : #1F3329  — fond Pépite block
///   - on-surface text    : #ECE6D6  (ivoire)
@immutable
class BayanTokens extends ThemeExtension<BayanTokens> {
  const BayanTokens({
    required this.accent,
    required this.arabicTextColor,
    required this.highlightBackground,
    required this.memoBackground,
    required this.appBackground,
    required this.arabicHero,
    required this.arabicBody,
    required this.arabicCaption,
  });

  /// Gold accent — used for borders/backgrounds in Pépite block; text-safe only on dark.
  final Color accent;

  /// Primary text colour for Arabic script blocks (adapts per theme).
  final Color arabicTextColor;

  /// Tinted background for the Pépite (gem) block.
  final Color highlightBackground;

  /// Tinted background for the Astuce Mémo block.
  final Color memoBackground;

  /// App-level background (behind scaffolds).
  final Color appBackground;

  /// 44 px Amiri style for the hero Arabic word in the detail sheet.
  final TextStyle arabicHero;

  /// 22 px Amiri style for Arabic words in list tiles / family view.
  final TextStyle arabicBody;

  /// 14 px Amiri style for secondary Arabic text (roots, labels).
  final TextStyle arabicCaption;

  // ---------------------------------------------------------------------------
  // Predefined instances
  // ---------------------------------------------------------------------------

  static const BayanTokens daftar = BayanTokens(
    accent: Color(0xFF9A7B3F),
    arabicTextColor: Color(0xFF3B2E1E),
    highlightBackground: Color(0xFFEDE3CE),
    memoBackground: Color(0xFFD9EBE1),
    appBackground: Color(0xFFF5F0E8),
    arabicHero: TextStyle(
      fontFamily: 'Amiri',
      fontSize: 44,
      fontWeight: FontWeight.w700,
      color: Color(0xFF3B2E1E),
      height: 1.4,
    ),
    arabicBody: TextStyle(
      fontFamily: 'Amiri',
      fontSize: 22,
      fontWeight: FontWeight.w400,
      color: Color(0xFF3B2E1E),
      height: 1.5,
    ),
    arabicCaption: TextStyle(
      fontFamily: 'Amiri',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Color(0xFF7A5C3E),
      height: 1.4,
    ),
  );

  static const BayanTokens sakina = BayanTokens(
    accent: Color(0xFFC9A24B),
    arabicTextColor: Color(0xFFECE6D6),
    highlightBackground: Color(0xFF1F3329),
    memoBackground: Color(0xFF1A3028),
    appBackground: Color(0xFF16241D),
    arabicHero: TextStyle(
      fontFamily: 'Amiri',
      fontSize: 44,
      fontWeight: FontWeight.w700,
      color: Color(0xFFECE6D6),
      height: 1.4,
    ),
    arabicBody: TextStyle(
      fontFamily: 'Amiri',
      fontSize: 22,
      fontWeight: FontWeight.w400,
      color: Color(0xFFECE6D6),
      height: 1.5,
    ),
    arabicCaption: TextStyle(
      fontFamily: 'Amiri',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Color(0xFFC9A24B),
      height: 1.4,
    ),
  );

  // ---------------------------------------------------------------------------
  // ThemeExtension contract
  // ---------------------------------------------------------------------------

  @override
  BayanTokens copyWith({
    Color? accent,
    Color? arabicTextColor,
    Color? highlightBackground,
    Color? memoBackground,
    Color? appBackground,
    TextStyle? arabicHero,
    TextStyle? arabicBody,
    TextStyle? arabicCaption,
  }) {
    return BayanTokens(
      accent: accent ?? this.accent,
      arabicTextColor: arabicTextColor ?? this.arabicTextColor,
      highlightBackground: highlightBackground ?? this.highlightBackground,
      memoBackground: memoBackground ?? this.memoBackground,
      appBackground: appBackground ?? this.appBackground,
      arabicHero: arabicHero ?? this.arabicHero,
      arabicBody: arabicBody ?? this.arabicBody,
      arabicCaption: arabicCaption ?? this.arabicCaption,
    );
  }

  @override
  BayanTokens lerp(BayanTokens? other, double t) {
    if (other == null) return this;
    return BayanTokens(
      accent: Color.lerp(accent, other.accent, t)!,
      arabicTextColor: Color.lerp(arabicTextColor, other.arabicTextColor, t)!,
      highlightBackground: Color.lerp(
        highlightBackground,
        other.highlightBackground,
        t,
      )!,
      memoBackground: Color.lerp(memoBackground, other.memoBackground, t)!,
      appBackground: Color.lerp(appBackground, other.appBackground, t)!,
      arabicHero: TextStyle.lerp(arabicHero, other.arabicHero, t)!,
      arabicBody: TextStyle.lerp(arabicBody, other.arabicBody, t)!,
      arabicCaption: TextStyle.lerp(arabicCaption, other.arabicCaption, t)!,
    );
  }
}
