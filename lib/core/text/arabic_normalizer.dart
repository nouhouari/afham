// Pure utility functions for normalising Arabic text before indexing or
// comparison. All functions are stateless and take / return [String], making
// them trivially unit-testable without any Flutter dependencies.
// ---------------------------------------------------------------------------
// Unicode ranges
// ---------------------------------------------------------------------------

/// Arabic harakat (diacritics): U+064B–U+0652 (tanwin, shadda, sukun…).
const _kHarakatRange = (start: 0x064B, end: 0x0652);

/// Tatweel / kashida: U+0640.
const int _kTatweel = 0x0640;

/// Alef variants → plain alef (U+0627).
const int _kAlef = 0x0627; // ا
const int _kAlefMadda = 0x0622; // آ
const int _kAlefHamzaAbove = 0x0623; // أ
const int _kAlefHamzaBelow = 0x0625; // إ

/// Alef maqsura → ya (U+064A).
const int _kAlefMaqsura = 0x0649; // ى
const int _kYa = 0x064A; // ي

/// Teh marbuta → ha (U+0647).
const int _kTehMarbuta = 0x0629; // ة
const int _kHa = 0x0647; // ه

// ---------------------------------------------------------------------------
// Public API
// ---------------------------------------------------------------------------

/// Normalises [input] for search-key generation or tolerant matching.
///
/// Steps applied (in order):
/// 1. Remove harakat (U+064B–U+0652).
/// 2. Remove tatweel / kashida (U+0640).
/// 3. Unify أ إ آ → ا
/// 4. Unify ى → ي
/// 5. Unify ة → ه
///
/// The result is a bare-consonant string suitable for FTS5 indexing and
/// for comparing user input against stored search keys.
String normalizeArabic(String input) {
  final buffer = StringBuffer();
  for (final rune in input.runes) {
    // 1 & 2 — strip harakat and tatweel
    if (rune >= _kHarakatRange.start && rune <= _kHarakatRange.end) continue;
    if (rune == _kTatweel) continue;

    // 3 — unify alef variants
    if (rune == _kAlefMadda ||
        rune == _kAlefHamzaAbove ||
        rune == _kAlefHamzaBelow) {
      buffer.writeCharCode(_kAlef);
      continue;
    }

    // 4 — alef maqsura → ya
    if (rune == _kAlefMaqsura) {
      buffer.writeCharCode(_kYa);
      continue;
    }

    // 5 — teh marbuta → ha
    if (rune == _kTehMarbuta) {
      buffer.writeCharCode(_kHa);
      continue;
    }

    buffer.writeCharCode(rune);
  }
  return buffer.toString();
}

/// Convenience: normalise and then lower-case the result.
/// Useful for mixed Arabic/Latin search keys.
String normalizeForSearch(String input) => normalizeArabic(input).toLowerCase();
