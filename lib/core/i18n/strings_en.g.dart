///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations

	/// en: 'Af'ham'
	String get appTitle => 'Af\'ham';

	/// en: 'Understand the words of the Quran'
	String get appTagline => 'Understand the words of the Quran';

	/// en: 'Search a Quranic word…'
	String get searchHint => 'Search a Quranic word…';

	/// en: 'رَحْمَة · rahma · صبر'
	String get searchHintArabic => 'رَحْمَة  ·  rahma  ·  صبر';

	/// en: 'Word of the Day'
	String get wordOfTheDay => 'Word of the Day';

	/// en: 'No results found'
	String get noResults => 'No results found';

	/// en: 'No results for «{query}»'
	String get noResultsFor => 'No results for «{query}»';

	/// en: 'Search a word from the Quran'
	String get searchPrompt => 'Search a word from the Quran';

	/// en: 'in Arabic or transliteration'
	String get searchPromptSub => 'in Arabic or transliteration';

	/// en: 'Loading…'
	String get loading => 'Loading…';

	/// en: 'An error occurred'
	String get error => 'An error occurred';

	/// en: 'Retry'
	String get retry => 'Retry';

	late final Translations$settings$en settings = Translations$settings$en.internal(_root);
	late final Translations$word$en word = Translations$word$en.internal(_root);
	late final Translations$rootFamily$en rootFamily = Translations$rootFamily$en.internal(_root);
}

// Path: settings
class Translations$settings$en {
	Translations$settings$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Settings'
	String get title => 'Settings';

	/// en: 'Theme'
	String get theme => 'Theme';

	/// en: 'Light (Daftar)'
	String get themeLight => 'Light (Daftar)';

	/// en: 'Dark (Sakīna)'
	String get themeDark => 'Dark (Sakīna)';

	/// en: 'System'
	String get themeSystem => 'System';

	/// en: 'Language'
	String get language => 'Language';

	/// en: 'Français'
	String get languageFr => 'Français';

	/// en: 'English'
	String get languageEn => 'English';

	/// en: 'Arabic font size'
	String get arabicScale => 'Arabic font size';

	/// en: 'Small'
	String get arabicScaleSmall => 'Small';

	/// en: 'Normal'
	String get arabicScaleNormal => 'Normal';

	/// en: 'Large'
	String get arabicScaleLarge => 'Large';

	/// en: 'X-Large'
	String get arabicScaleXLarge => 'X-Large';
}

// Path: word
class Translations$word$en {
	Translations$word$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Translation'
	String get translation => 'Translation';

	/// en: 'Root'
	String get root => 'Root';

	/// en: 'Root family'
	String get rootFamily => 'Root family';

	/// en: 'Tafsir'
	String get tafsir => 'Tafsir';

	/// en: 'Gem'
	String get gem => 'Gem';

	/// en: 'Memory tip'
	String get mnemonic => 'Memory tip';

	/// en: 'Play pronunciation'
	String get playAudio => 'Play pronunciation';

	/// en: 'Stop'
	String get stopAudio => 'Stop';

	/// en: 'No audio yet'
	String get noAudio => 'No audio yet';

	/// en: '{count} occurrence(s) in the Quran'
	String get occurrences => '{count} occurrence(s) in the Quran';

	/// en: 'In the Quran'
	String get versesTitle => 'In the Quran';

	late final Translations$word$pos$en pos = Translations$word$pos$en.internal(_root);
}

// Path: rootFamily
class Translations$rootFamily$en {
	Translations$rootFamily$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Root family'
	String get title => 'Root family';

	/// en: 'Words sharing the root {root}'
	String get subtitle => 'Words sharing the root {root}';

	/// en: 'No words found for this root'
	String get empty => 'No words found for this root';
}

// Path: word.pos
class Translations$word$pos$en {
	Translations$word$pos$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'noun'
	String get noun => 'noun';

	/// en: 'verb'
	String get verb => 'verb';

	/// en: 'particle'
	String get particle => 'particle';

	/// en: 'adjective'
	String get adjective => 'adjective';

	/// en: 'pronoun'
	String get pronoun => 'pronoun';

	/// en: 'other'
	String get other => 'other';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'appTitle' => 'Af\'ham',
			'appTagline' => 'Understand the words of the Quran',
			'searchHint' => 'Search a Quranic word…',
			'searchHintArabic' => 'رَحْمَة  ·  rahma  ·  صبر',
			'wordOfTheDay' => 'Word of the Day',
			'noResults' => 'No results found',
			'noResultsFor' => 'No results for «{query}»',
			'searchPrompt' => 'Search a word from the Quran',
			'searchPromptSub' => 'in Arabic or transliteration',
			'loading' => 'Loading…',
			'error' => 'An error occurred',
			'retry' => 'Retry',
			'settings.title' => 'Settings',
			'settings.theme' => 'Theme',
			'settings.themeLight' => 'Light (Daftar)',
			'settings.themeDark' => 'Dark (Sakīna)',
			'settings.themeSystem' => 'System',
			'settings.language' => 'Language',
			'settings.languageFr' => 'Français',
			'settings.languageEn' => 'English',
			'settings.arabicScale' => 'Arabic font size',
			'settings.arabicScaleSmall' => 'Small',
			'settings.arabicScaleNormal' => 'Normal',
			'settings.arabicScaleLarge' => 'Large',
			'settings.arabicScaleXLarge' => 'X-Large',
			'word.translation' => 'Translation',
			'word.root' => 'Root',
			'word.rootFamily' => 'Root family',
			'word.tafsir' => 'Tafsir',
			'word.gem' => 'Gem',
			'word.mnemonic' => 'Memory tip',
			'word.playAudio' => 'Play pronunciation',
			'word.stopAudio' => 'Stop',
			'word.noAudio' => 'No audio yet',
			'word.occurrences' => '{count} occurrence(s) in the Quran',
			'word.versesTitle' => 'In the Quran',
			'word.pos.noun' => 'noun',
			'word.pos.verb' => 'verb',
			'word.pos.particle' => 'particle',
			'word.pos.adjective' => 'adjective',
			'word.pos.pronoun' => 'pronoun',
			'word.pos.other' => 'other',
			'rootFamily.title' => 'Root family',
			'rootFamily.subtitle' => 'Words sharing the root {root}',
			'rootFamily.empty' => 'No words found for this root',
			_ => null,
		};
	}
}
