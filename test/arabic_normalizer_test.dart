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
