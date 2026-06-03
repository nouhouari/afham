// Pure utility functions for normalising Arabic text before indexing or
// comparison. All functions are stateless and take / return [String], making
// them trivially unit-testable without any Flutter dependencies.
//
// The normalisation is tuned for *Uthmani Quranic* text, which carries more
// than the usual harakat: superscript (dagger) alef, small high/low Quranic
// annotation signs, honorific signs, etc. All of these are stripped so that a
// user typing a bare, unvocalised form still matches the stored search key.

/// True when [r] is a combining mark / sign that should be removed entirely.
bool _isStrippable(int r) {
  return (r >= 0x0610 && r <= 0x061A) || // Arabic honorific signs (ﷺ marks…)
      (r >= 0x064B && r <= 0x065F) || // harakat + extended combining marks
      r == 0x0670 || // superscript (dagger) alef  ٰ
      (r >= 0x06D6 && r <= 0x06DC) || // small high Quranic annotation signs
      (r >= 0x06DF && r <= 0x06E8) || // more Quranic annotation signs
      (r >= 0x06EA && r <= 0x06ED) || // more Quranic annotation signs
      r == 0x0640; // tatweel / kashida
}

/// Letter-form unifications applied after marks are stripped. Returns the
/// replacement code point, or `null` to keep the rune unchanged.
int? _unify(int r) {
  switch (r) {
    case 0x0622: // آ alef madda
    case 0x0623: // أ alef hamza above
    case 0x0625: // إ alef hamza below
    case 0x0671: // ٱ alef wasla
      return 0x0627; // ا plain alef
    case 0x0649: // ى alef maqsura
      return 0x064A; // ي ya
    case 0x0629: // ة teh marbuta
      return 0x0647; // ه ha
    case 0x0624: // ؤ waw with hamza
      return 0x0648; // و waw
    case 0x0626: // ئ ya with hamza
      return 0x064A; // ي ya
    default:
      return null;
  }
}

/// Normalises [input] for search-key generation or tolerant matching.
///
/// Steps applied (in order), per rune:
/// 1. Drop combining marks & Quranic annotation signs (harakat, dagger alef,
///    small high/low signs, honorifics, tatweel).
/// 2. Unify letter forms: أ إ آ ٱ → ا · ى → ي · ة → ه · ؤ → و · ئ → ي
///
/// Standalone hamza (ء) is intentionally kept. The result is a bare-consonant
/// string suitable for FTS5 indexing and for comparing user input against
/// stored search keys.
String normalizeArabic(String input) {
  final buffer = StringBuffer();
  for (final rune in input.runes) {
    if (_isStrippable(rune)) continue;
    final unified = _unify(rune);
    buffer.writeCharCode(unified ?? rune);
  }
  return buffer.toString();
}

/// Convenience: normalise and then lower-case the result.
/// Useful for mixed Arabic/Latin search keys.
String normalizeForSearch(String input) => normalizeArabic(input).toLowerCase();
