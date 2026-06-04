///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsId extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsId({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.id,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <id>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	late final TranslationsId _root = this; // ignore: unused_field

	@override 
	TranslationsId $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsId(meta: meta ?? this.$meta);

	// Translations
	@override String get appTitle => 'Af\'ham';
	@override String get appTagline => 'Pahami kata-kata Al-Qur\'an';
	@override String get searchHint => 'Cari kata Al-Qur\'an…';
	@override String get searchHintArabic => 'رَحْمَة  ·  rahma  ·  صبر';
	@override String get wordOfTheDay => 'Kata Hari Ini';
	@override String get noResults => 'Tidak ada hasil';
	@override String get noResultsFor => 'Tidak ada hasil untuk «{query}»';
	@override String get searchPrompt => 'Cari kata dari Al-Qur\'an';
	@override String get searchPromptSub => 'dalam huruf Arab atau transliterasi';
	@override String get loading => 'Memuat…';
	@override String get error => 'Terjadi kesalahan';
	@override String get retry => 'Coba lagi';
	@override late final _Translations$settings$id settings = _Translations$settings$id._(_root);
	@override late final _Translations$word$id word = _Translations$word$id._(_root);
	@override late final _Translations$rootFamily$id rootFamily = _Translations$rootFamily$id._(_root);
	@override late final _Translations$onboarding$id onboarding = _Translations$onboarding$id._(_root);
}

// Path: settings
class _Translations$settings$id extends Translations$settings$en {
	_Translations$settings$id._(TranslationsId root) : this._root = root, super.internal(root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get title => 'Pengaturan';
	@override String get theme => 'Tema';
	@override String get themeLight => 'Terang (Daftar)';
	@override String get themeDark => 'Gelap (Sakīna)';
	@override String get themeSystem => 'Sistem';
	@override String get language => 'Bahasa';
	@override String get languageFr => 'Français';
	@override String get languageEn => 'English';
	@override String get languageId => 'Bahasa Indonesia';
	@override String get languageUr => 'اردو';
	@override String get arabicScale => 'Ukuran font Arab';
	@override String get arabicScaleSmall => 'Kecil';
	@override String get arabicScaleNormal => 'Normal';
	@override String get arabicScaleLarge => 'Besar';
	@override String get arabicScaleXLarge => 'Sangat besar';
	@override String get about => 'Tentang';
	@override String get audioCredit => 'Audio bacaan kata demi kata atas izin Quran.com (Quran Foundation).';
}

// Path: word
class _Translations$word$id extends Translations$word$en {
	_Translations$word$id._(TranslationsId root) : this._root = root, super.internal(root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get translation => 'Terjemahan';
	@override String get root => 'Akar kata';
	@override String get rootFamily => 'Keluarga akar';
	@override String get tafsir => 'Tafsir';
	@override String get gem => 'Mutiara';
	@override String get mnemonic => 'Tips mengingat';
	@override String get playAudio => 'Putar pelafalan';
	@override String get stopAudio => 'Berhenti';
	@override String get noAudio => 'Belum ada audio';
	@override String get occurrences => '{count} kemunculan dalam Al-Qur\'an';
	@override String get versesTitle => 'Dalam Al-Qur\'an';
	@override late final _Translations$word$pos$id pos = _Translations$word$pos$id._(_root);
}

// Path: rootFamily
class _Translations$rootFamily$id extends Translations$rootFamily$en {
	_Translations$rootFamily$id._(TranslationsId root) : this._root = root, super.internal(root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get title => 'Keluarga akar';
	@override String get subtitle => 'Kata-kata yang memiliki akar {root}';
	@override String get empty => 'Tidak ada kata untuk akar ini';
}

// Path: onboarding
class _Translations$onboarding$id extends Translations$onboarding$en {
	_Translations$onboarding$id._(TranslationsId root) : this._root = root, super.internal(root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get skip => 'Lewati';
	@override String get next => 'Berikutnya';
	@override String get start => 'Mulai';
	@override String get slide1Title => 'Pahami Al-Qur\'an';
	@override String get slide1Body => 'Beralih dari membaca ke memahami — dari bacaan mekanis ke bacaan hati (Tadabbur).';
	@override String get slide2Title => 'Cari kata apa pun';
	@override String get slide2Body => 'Ketik kata Al-Qur\'an dalam huruf Arab atau transliterasi. Pencarian toleran terhadap harakat dan ejaan.';
	@override String get slide3Title => 'Temukan maknanya';
	@override String get slide3Body => 'Ketuk sebuah kata untuk fichenya: terjemahan, akar kata, tafsir, mutiara spiritual, dan tips mengingat — beserta pelafalannya.';
}

// Path: word.pos
class _Translations$word$pos$id extends Translations$word$pos$en {
	_Translations$word$pos$id._(TranslationsId root) : this._root = root, super.internal(root);

	final TranslationsId _root; // ignore: unused_field

	// Translations
	@override String get noun => 'kata benda';
	@override String get verb => 'kata kerja';
	@override String get particle => 'partikel';
	@override String get adjective => 'kata sifat';
	@override String get pronoun => 'kata ganti';
	@override String get other => 'lainnya';
}

/// The flat map containing all translations for locale <id>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsId {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'appTitle' => 'Af\'ham',
			'appTagline' => 'Pahami kata-kata Al-Qur\'an',
			'searchHint' => 'Cari kata Al-Qur\'an…',
			'searchHintArabic' => 'رَحْمَة  ·  rahma  ·  صبر',
			'wordOfTheDay' => 'Kata Hari Ini',
			'noResults' => 'Tidak ada hasil',
			'noResultsFor' => 'Tidak ada hasil untuk «{query}»',
			'searchPrompt' => 'Cari kata dari Al-Qur\'an',
			'searchPromptSub' => 'dalam huruf Arab atau transliterasi',
			'loading' => 'Memuat…',
			'error' => 'Terjadi kesalahan',
			'retry' => 'Coba lagi',
			'settings.title' => 'Pengaturan',
			'settings.theme' => 'Tema',
			'settings.themeLight' => 'Terang (Daftar)',
			'settings.themeDark' => 'Gelap (Sakīna)',
			'settings.themeSystem' => 'Sistem',
			'settings.language' => 'Bahasa',
			'settings.languageFr' => 'Français',
			'settings.languageEn' => 'English',
			'settings.languageId' => 'Bahasa Indonesia',
			'settings.languageUr' => 'اردو',
			'settings.arabicScale' => 'Ukuran font Arab',
			'settings.arabicScaleSmall' => 'Kecil',
			'settings.arabicScaleNormal' => 'Normal',
			'settings.arabicScaleLarge' => 'Besar',
			'settings.arabicScaleXLarge' => 'Sangat besar',
			'settings.about' => 'Tentang',
			'settings.audioCredit' => 'Audio bacaan kata demi kata atas izin Quran.com (Quran Foundation).',
			'word.translation' => 'Terjemahan',
			'word.root' => 'Akar kata',
			'word.rootFamily' => 'Keluarga akar',
			'word.tafsir' => 'Tafsir',
			'word.gem' => 'Mutiara',
			'word.mnemonic' => 'Tips mengingat',
			'word.playAudio' => 'Putar pelafalan',
			'word.stopAudio' => 'Berhenti',
			'word.noAudio' => 'Belum ada audio',
			'word.occurrences' => '{count} kemunculan dalam Al-Qur\'an',
			'word.versesTitle' => 'Dalam Al-Qur\'an',
			'word.pos.noun' => 'kata benda',
			'word.pos.verb' => 'kata kerja',
			'word.pos.particle' => 'partikel',
			'word.pos.adjective' => 'kata sifat',
			'word.pos.pronoun' => 'kata ganti',
			'word.pos.other' => 'lainnya',
			'rootFamily.title' => 'Keluarga akar',
			'rootFamily.subtitle' => 'Kata-kata yang memiliki akar {root}',
			'rootFamily.empty' => 'Tidak ada kata untuk akar ini',
			'onboarding.skip' => 'Lewati',
			'onboarding.next' => 'Berikutnya',
			'onboarding.start' => 'Mulai',
			'onboarding.slide1Title' => 'Pahami Al-Qur\'an',
			'onboarding.slide1Body' => 'Beralih dari membaca ke memahami — dari bacaan mekanis ke bacaan hati (Tadabbur).',
			'onboarding.slide2Title' => 'Cari kata apa pun',
			'onboarding.slide2Body' => 'Ketik kata Al-Qur\'an dalam huruf Arab atau transliterasi. Pencarian toleran terhadap harakat dan ejaan.',
			'onboarding.slide3Title' => 'Temukan maknanya',
			'onboarding.slide3Body' => 'Ketuk sebuah kata untuk fichenya: terjemahan, akar kata, tafsir, mutiara spiritual, dan tips mengingat — beserta pelafalannya.',
			_ => null,
		};
	}
}
