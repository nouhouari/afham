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

	/// en: 'Bayan'
	String get appTitle => 'Bayan';

	/// en: 'Search a Quranic word…'
	String get searchHint => 'Search a Quranic word…';

	/// en: 'Word of the Day'
	String get wordOfTheDay => 'Word of the Day';

	/// en: 'No results found'
	String get noResults => 'No results found';

	late final Translations$settings$en settings = Translations$settings$en._(_root);
	late final Translations$word$en word = Translations$word$en._(_root);
	late final Translations$rootFamily$en rootFamily = Translations$rootFamily$en._(_root);
}

// Path: settings
class Translations$settings$en {
	Translations$settings$en._(this._root);

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
}

// Path: word
class Translations$word$en {
	Translations$word$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Translation'
	String get translation => 'Translation';

	/// en: 'Root'
	String get root => 'Root';

	/// en: 'Tafsir'
	String get tafsir => 'Tafsir';

	/// en: 'Gem'
	String get gem => 'Gem';

	/// en: 'Memory tip'
	String get mnemonic => 'Memory tip';

	/// en: 'Play pronunciation'
	String get playAudio => 'Play pronunciation';

	/// en: '{count} occurrence(s) in the Quran'
	String get occurrences => '{count} occurrence(s) in the Quran';
}

// Path: rootFamily
class Translations$rootFamily$en {
	Translations$rootFamily$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Root family'
	String get title => 'Root family';

	/// en: 'Words sharing the root {root}'
	String get subtitle => 'Words sharing the root {root}';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'appTitle' => 'Bayan',
			'searchHint' => 'Search a Quranic word…',
			'wordOfTheDay' => 'Word of the Day',
			'noResults' => 'No results found',
			'settings.title' => 'Settings',
			'settings.theme' => 'Theme',
			'settings.themeLight' => 'Light (Daftar)',
			'settings.themeDark' => 'Dark (Sakīna)',
			'settings.themeSystem' => 'System',
			'settings.language' => 'Language',
			'settings.languageFr' => 'Français',
			'settings.languageEn' => 'English',
			'settings.arabicScale' => 'Arabic font size',
			'word.translation' => 'Translation',
			'word.root' => 'Root',
			'word.tafsir' => 'Tafsir',
			'word.gem' => 'Gem',
			'word.mnemonic' => 'Memory tip',
			'word.playAudio' => 'Play pronunciation',
			'word.occurrences' => '{count} occurrence(s) in the Quran',
			'rootFamily.title' => 'Root family',
			'rootFamily.subtitle' => 'Words sharing the root {root}',
			_ => null,
		};
	}
}
