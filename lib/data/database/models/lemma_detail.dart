import 'package:flutter/foundation.dart';

/// Full detail of a lemma, as returned by [WordDetailDao.getLemmaDetail].
///
/// Combines columns from `lemmas`, `roots`, `word_content`, `audio_clips`,
/// and up to 2 linked verse occurrences.
@immutable
class LemmaDetail {
  const LemmaDetail({
    required this.lemmaId,
    required this.lemmaAr,
    required this.latin,
    required this.pos,
    required this.frequency,
    required this.rootId,
    required this.rootAr,
    required this.rootLatin,
    required this.translation,
    required this.tafsir,
    required this.gem,
    required this.mnemonic,
    required this.verses,
    this.audioId,
    this.audioPackFile,
    this.audioStartMs,
    this.audioDurationMs,
  });

  final int lemmaId;

  /// Lemma with harakat, e.g. رَحْمَة
  final String lemmaAr;

  /// ASCII transliteration, e.g. raḥma
  final String latin;

  /// Part of speech tag
  final String pos;

  /// Corpus frequency
  final int frequency;

  /// FK to roots table (0 if no root)
  final int rootId;

  /// Root in Arabic letters, e.g. ر-ح-م
  final String rootAr;

  /// Root transliteration
  final String rootLatin;

  // Localised content

  final String translation;
  final String tafsir;

  /// Pépite linguistique / spirituelle
  final String gem;

  /// Astuce Mémo
  final String mnemonic;

  /// Up to 2 example verses (surah:ayah + Uthmani text)
  final List<VerseSnippet> verses;

  // Audio

  final int? audioId;
  final String? audioPackFile;
  final int? audioStartMs;
  final int? audioDurationMs;

  bool get hasAudio =>
      audioId != null &&
      audioPackFile != null &&
      audioStartMs != null &&
      audioDurationMs != null;

  bool get hasRoot => rootId > 0 && rootAr.isNotEmpty;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LemmaDetail &&
          runtimeType == other.runtimeType &&
          lemmaId == other.lemmaId;

  @override
  int get hashCode => lemmaId.hashCode;
}

/// A lightweight verse snippet used inside [LemmaDetail.verses].
@immutable
class VerseSnippet {
  const VerseSnippet({
    required this.surah,
    required this.ayah,
    required this.textUthmani,
  });

  final int surah;
  final int ayah;
  final String textUthmani;

  String get reference => '$surah:$ayah';
}

/// A row returned by [WordDetailDao.lemmasByRoot].
@immutable
class RootFamilyItem {
  const RootFamilyItem({
    required this.lemmaId,
    required this.lemmaAr,
    required this.latin,
    required this.pos,
    required this.frequency,
    required this.translation,
    this.audioId,
    this.audioPackFile,
    this.audioStartMs,
    this.audioDurationMs,
  });

  final int lemmaId;
  final String lemmaAr;
  final String latin;
  final String pos;
  final int frequency;
  final String translation;

  final int? audioId;
  final String? audioPackFile;
  final int? audioStartMs;
  final int? audioDurationMs;

  bool get hasAudio =>
      audioId != null &&
      audioPackFile != null &&
      audioStartMs != null &&
      audioDurationMs != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RootFamilyItem &&
          runtimeType == other.runtimeType &&
          lemmaId == other.lemmaId;

  @override
  int get hashCode => lemmaId.hashCode;
}
