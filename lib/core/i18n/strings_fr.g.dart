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
class TranslationsFr extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsFr({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.fr,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <fr>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	late final TranslationsFr _root = this; // ignore: unused_field

	@override 
	TranslationsFr $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsFr(meta: meta ?? this.$meta);

	// Translations
	@override String get appTitle => 'Af\'ham';
	@override String get appTagline => 'Comprendre les mots du Coran';
	@override String get searchHint => 'Chercher un mot coranique…';
	@override String get searchHintArabic => 'رَحْمَة  ·  rahma  ·  صبر';
	@override String get wordOfTheDay => 'Mot du jour';
	@override String get noResults => 'Aucun résultat';
	@override String get noResultsFor => 'Aucun résultat pour « {query} »';
	@override String get searchPrompt => 'Cherche un mot du Coran';
	@override String get searchPromptSub => 'en arabe ou en translittération';
	@override String get loading => 'Chargement…';
	@override String get error => 'Une erreur est survenue';
	@override String get retry => 'Réessayer';
	@override late final _Translations$settings$fr settings = _Translations$settings$fr._(_root);
	@override late final _Translations$word$fr word = _Translations$word$fr._(_root);
	@override late final _Translations$rootFamily$fr rootFamily = _Translations$rootFamily$fr._(_root);
}

// Path: settings
class _Translations$settings$fr extends Translations$settings$en {
	_Translations$settings$fr._(TranslationsFr root) : this._root = root, super.internal(root);

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
	@override String get arabicScaleSmall => 'Petite';
	@override String get arabicScaleNormal => 'Normale';
	@override String get arabicScaleLarge => 'Grande';
	@override String get arabicScaleXLarge => 'Très grande';
}

// Path: word
class _Translations$word$fr extends Translations$word$en {
	_Translations$word$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get translation => 'Traduction';
	@override String get root => 'Racine';
	@override String get rootFamily => 'Famille de racine';
	@override String get tafsir => 'Tafsir';
	@override String get gem => 'Pépite';
	@override String get mnemonic => 'Astuce mémo';
	@override String get playAudio => 'Écouter la prononciation';
	@override String get stopAudio => 'Arrêter';
	@override String get noAudio => 'Pas encore d\'audio';
	@override String get occurrences => '{count} occurrence(s) dans le Coran';
	@override String get versesTitle => 'Dans le Coran';
	@override late final _Translations$word$pos$fr pos = _Translations$word$pos$fr._(_root);
}

// Path: rootFamily
class _Translations$rootFamily$fr extends Translations$rootFamily$en {
	_Translations$rootFamily$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Famille de racine';
	@override String get subtitle => 'Mots partageant la racine {root}';
	@override String get empty => 'Aucun mot trouvé pour cette racine';
}

// Path: word.pos
class _Translations$word$pos$fr extends Translations$word$pos$en {
	_Translations$word$pos$fr._(TranslationsFr root) : this._root = root, super.internal(root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get noun => 'nom';
	@override String get verb => 'verbe';
	@override String get particle => 'particule';
	@override String get adjective => 'adjectif';
	@override String get pronoun => 'pronom';
	@override String get other => 'autre';
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
			'searchHintArabic' => 'رَحْمَة  ·  rahma  ·  صبر',
			'wordOfTheDay' => 'Mot du jour',
			'noResults' => 'Aucun résultat',
			'noResultsFor' => 'Aucun résultat pour « {query} »',
			'searchPrompt' => 'Cherche un mot du Coran',
			'searchPromptSub' => 'en arabe ou en translittération',
			'loading' => 'Chargement…',
			'error' => 'Une erreur est survenue',
			'retry' => 'Réessayer',
			'settings.title' => 'Réglages',
			'settings.theme' => 'Thème',
			'settings.themeLight' => 'Clair (Daftar)',
			'settings.themeDark' => 'Sombre (Sakīna)',
			'settings.themeSystem' => 'Système',
			'settings.language' => 'Langue',
			'settings.languageFr' => 'Français',
			'settings.languageEn' => 'English',
			'settings.arabicScale' => 'Taille police arabe',
			'settings.arabicScaleSmall' => 'Petite',
			'settings.arabicScaleNormal' => 'Normale',
			'settings.arabicScaleLarge' => 'Grande',
			'settings.arabicScaleXLarge' => 'Très grande',
			'word.translation' => 'Traduction',
			'word.root' => 'Racine',
			'word.rootFamily' => 'Famille de racine',
			'word.tafsir' => 'Tafsir',
			'word.gem' => 'Pépite',
			'word.mnemonic' => 'Astuce mémo',
			'word.playAudio' => 'Écouter la prononciation',
			'word.stopAudio' => 'Arrêter',
			'word.noAudio' => 'Pas encore d\'audio',
			'word.occurrences' => '{count} occurrence(s) dans le Coran',
			'word.versesTitle' => 'Dans le Coran',
			'word.pos.noun' => 'nom',
			'word.pos.verb' => 'verbe',
			'word.pos.particle' => 'particule',
			'word.pos.adjective' => 'adjectif',
			'word.pos.pronoun' => 'pronom',
			'word.pos.other' => 'autre',
			'rootFamily.title' => 'Famille de racine',
			'rootFamily.subtitle' => 'Mots partageant la racine {root}',
			'rootFamily.empty' => 'Aucun mot trouvé pour cette racine',
			_ => null,
		};
	}
}
