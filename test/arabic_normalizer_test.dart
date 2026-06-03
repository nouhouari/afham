import 'package:bayan/core/text/arabic_normalizer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('normalizeArabic', () {
    test('strips harakat (tanwin, shadda, sukun…)', () {
      // رَحْمَة (with fatha + sukun + fatha)
      const withHarakat = 'رَحْمَةً';
      expect(normalizeArabic(withHarakat), equals('رحمه'));
    });

    test('removes tatweel (kashida)', () {
      // كـتـاب → كتاب
      const withTatweel = 'كـتـاب';
      expect(normalizeArabic(withTatweel), equals('كتاب'));
    });

    test('unifies أ إ آ → ا', () {
      expect(normalizeArabic('أ'), equals('ا'));
      expect(normalizeArabic('إ'), equals('ا'));
      expect(normalizeArabic('آ'), equals('ا'));
      // Full word: الإسلام → الاسلام
      expect(normalizeArabic('الإسلام'), equals('الاسلام'));
    });

    test('unifies ى → ي', () {
      // هدى → هدي
      expect(normalizeArabic('هدى'), equals('هدي'));
    });

    test('unifies ة → ه', () {
      // رحمة → رحمه
      expect(normalizeArabic('رحمة'), equals('رحمه'));
    });

    test('combined: رَحْمَة normalises to رحمه', () {
      expect(normalizeArabic('رَحْمَة'), equals('رحمه'));
    });

    test('combined: رحمه (already normalised) is idempotent', () {
      const input = 'رحمه';
      expect(normalizeArabic(input), equals(input));
    });

    test('combined: آيَة → ايه', () {
      expect(normalizeArabic('آيَة'), equals('ايه'));
    });

    test('strips superscript (dagger) alef U+0670', () {
      // هَٰذَا (ha, fatha, dagger-alef, dhal, fatha, alef) → هذا
      final input = String.fromCharCodes([
        0x0647,
        0x064E,
        0x0670,
        0x0630,
        0x064E,
        0x0627,
      ]);
      expect(normalizeArabic(input), equals('هذا'));
    });

    test('strips small high Quranic annotation signs (U+06D6+)', () {
      // ب followed by a small-high sign → ب
      final input = String.fromCharCodes([0x0628, 0x06D6]);
      expect(normalizeArabic(input), equals('ب'));
    });

    test('unifies ؤ → و (waw with hamza)', () {
      // مُؤْمِن → مومن
      expect(normalizeArabic('مُؤْمِن'), equals('مومن'));
    });

    test('unifies ئ → ي (ya with hamza)', () {
      // مسئول → مسيول
      expect(normalizeArabic('مسئول'), equals('مسيول'));
    });

    test('non-Arabic text passes through unchanged', () {
      const latin = 'rahma';
      expect(normalizeArabic(latin), equals(latin));
    });

    test('empty string returns empty string', () {
      expect(normalizeArabic(''), equals(''));
    });
  });

  group('normalizeForSearch', () {
    test('lower-cases ASCII portion', () {
      // Mixed: Latin + Arabic stays clean
      expect(normalizeForSearch('Rahma رَحْمَة'), equals('rahma رحمه'));
    });
  });
}
