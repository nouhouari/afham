import 'package:flutter/foundation.dart';

/// A clean domain model returned by [SearchDao.searchLemmas].
///
/// Decouples feature code from Drift-generated row types.
@immutable
class SearchResult {
  const SearchResult({
    required this.lemmaId,
    required this.lemmaAr,
    required this.latin,
    required this.pos,
    required this.frequency,
    required this.rootAr,
    required this.rootLatin,
    required this.translation,
    required this.tafsir,
    required this.gem,
    required this.mnemonic,
  });

  final int lemmaId;

  /// Lemma with harakat, e.g. رَحْمَة
  final String lemmaAr;

  /// ASCII transliteration, e.g. raḥma
  final String latin;

  /// Part of speech, e.g. 'noun'
  final String pos;

  /// Corpus frequency (higher = more common). Used for sorting.
  final int frequency;

  /// Root Arabic letters, e.g. ر-ح-م (may be empty if rootless)
  final String rootAr;

  /// Root Latin transliteration, e.g. r-ḥ-m
  final String rootLatin;

  // ── Localised content (from word_content for the current lang) ──

  final String translation;
  final String tafsir;

  /// Pépite linguistique ou spirituelle
  final String gem;

  /// Astuce Mémo (Darija / mnémotechnique)
  final String mnemonic;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchResult &&
          runtimeType == other.runtimeType &&
          lemmaId == other.lemmaId;

  @override
  int get hashCode => lemmaId.hashCode;

  @override
  String toString() => 'SearchResult($lemmaAr / $latin, freq=$frequency)';
}
