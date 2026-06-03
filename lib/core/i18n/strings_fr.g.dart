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
class TranslationsFr with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsFr({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.fr,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <fr>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsFr _root = this; // ignore: unused_field

	@override 
	TranslationsFr $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsFr(meta: meta ?? this.$meta);

	// Translations
	@override String get appTitle => 'Af\'ham';
	@override String get appTagline => 'Comprendre les mots du Coran';
	@override String get searchHint => 'Chercher un mot coranique…';
	@override String get wordOfTheDay => 'Mot du jour';
	@override String get noResults => 'Aucun résultat';
	@override late final _Translations$settings$fr settings = _Translations$settings$fr._(_root);
	@override late final _Translations$word$fr word = _Translations$word$fr._(_root);
	@override late final _Translations$rootFamily$fr rootFamily = _Translations$rootFamily$fr._(_root);
}

// Path: settings
class _Translations$settings$fr implements Translations$settings$en {
	_Translations$settings$fr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Réglages';
	@override String get theme => 'Thème';
	@override String get themeLight => 'Clair (Daftar)';
	@override String get themeDark => 'Sombre (Sakīna)';
	@override String get themeSystem => 'Système';
	@override String get language => 'Langue';
	@override String get languageFr => 'Français';
	@override String get languageEn => 'English';
	@override String get arabicScale => 'Taille police arabe';
}

// Path: word
class _Translations$word$fr implements Translations$word$en {
	_Translations$word$fr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get translation => 'Traduction';
	@override String get root => 'Racine';
	@override String get tafsir => 'Tafsir';
	@override String get gem => 'Pépite';
	@override String get mnemonic => 'Astuce mémo';
	@override String get playAudio => 'Écouter la prononciation';
	@override String get occurrences => '{count} occurrence(s) dans le Coran';
}

// Path: rootFamily
class _Translations$rootFamily$fr implements Translations$rootFamily$en {
	_Translations$rootFamily$fr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Famille de racine';
	@override String get subtitle => 'Mots partageant la racine {root}';
}

/// The flat map containing all translations for locale <fr>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsFr {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'appTitle' => 'Af\'ham',
			'appTagline' => 'Comprendre les mots du Coran',
			'searchHint' => 'Chercher un mot coranique…',
			'wordOfTheDay' => 'Mot du jour',
			'noResults' => 'Aucun résultat',
			'settings.title' => 'Réglages',
			'settings.theme' => 'Thème',
			'settings.themeLight' => 'Clair (Daftar)',
			'settings.themeDark' => 'Sombre (Sakīna)',
			'settings.themeSystem' => 'Système',
			'settings.language' => 'Langue',
			'settings.languageFr' => 'Français',
			'settings.languageEn' => 'English',
			'settings.arabicScale' => 'Taille police arabe',
			'word.translation' => 'Traduction',
			'word.root' => 'Racine',
			'word.tafsir' => 'Tafsir',
			'word.gem' => 'Pépite',
			'word.mnemonic' => 'Astuce mémo',
			'word.playAudio' => 'Écouter la prononciation',
			'word.occurrences' => '{count} occurrence(s) dans le Coran',
			'rootFamily.title' => 'Famille de racine',
			'rootFamily.subtitle' => 'Mots partageant la racine {root}',
			_ => null,
		};
	}
}
