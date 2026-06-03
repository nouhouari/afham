// Theme-invariant layout tokens for Bayan.
//
// Spacing and corner radii do NOT change between the Daftar (light) and
// Sakīna (dark) themes, so they live here as plain constants rather than in
// the [BayanTokens] ThemeExtension (which is reserved for values that differ
// per theme, e.g. colours and shadows).

/// 4-based spacing scale.
abstract final class Spacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

/// Corner radii.
abstract final class Radii {
  /// Result cards, Mot-du-jour card, generic surfaces.
  static const double card = 12;

  /// Chips / small pills (e.g. root letters).
  static const double chip = 8;

  /// Top corners of the detail bottom sheet (0.55 → 0.92 draggable).
  static const double sheet = 24;

  /// Fully rounded (audio button, pill toggles).
  static const double pill = 999;
}
