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
class TranslationsUr extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsUr({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ur,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ur>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	late final TranslationsUr _root = this; // ignore: unused_field

	@override 
	TranslationsUr $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsUr(meta: meta ?? this.$meta);

	// Translations
	@override String get appTitle => 'Af\'ham';
	@override String get appTagline => 'قرآن کے الفاظ سمجھیں';
	@override String get searchHint => 'قرآنی لفظ تلاش کریں…';
	@override String get searchHintArabic => 'رَحْمَة  ·  rahma  ·  صبر';
	@override String get wordOfTheDay => 'آج کا لفظ';
	@override String get noResults => 'کوئی نتیجہ نہیں ملا';
	@override String get noResultsFor => '«{query}» کے لیے کوئی نتیجہ نہیں';
	@override String get searchPrompt => 'قرآن سے کوئی لفظ تلاش کریں';
	@override String get searchPromptSub => 'عربی یا رومن حروف میں';
	@override String get loading => 'لوڈ ہو رہا ہے…';
	@override String get error => 'ایک خرابی پیش آگئی';
	@override String get retry => 'دوبارہ کوشش کریں';
	@override late final _Translations$settings$ur settings = _Translations$settings$ur._(_root);
	@override late final _Translations$word$ur word = _Translations$word$ur._(_root);
	@override late final _Translations$rootFamily$ur rootFamily = _Translations$rootFamily$ur._(_root);
	@override late final _Translations$onboarding$ur onboarding = _Translations$onboarding$ur._(_root);
}

// Path: settings
class _Translations$settings$ur extends Translations$settings$en {
	_Translations$settings$ur._(TranslationsUr root) : this._root = root, super.internal(root);

	final TranslationsUr _root; // ignore: unused_field

	// Translations
	@override String get title => 'ترتیبات';
	@override String get theme => 'تھیم';
	@override String get themeLight => 'روشن (Daftar)';
	@override String get themeDark => 'تاریک (Sakīna)';
	@override String get themeSystem => 'سسٹم';
	@override String get language => 'زبان';
	@override String get languageFr => 'Français';
	@override String get languageEn => 'English';
	@override String get languageId => 'Bahasa Indonesia';
	@override String get languageUr => 'اردو';
	@override String get arabicScale => 'عربی فونٹ کا سائز';
	@override String get arabicScaleSmall => 'چھوٹا';
	@override String get arabicScaleNormal => 'عام';
	@override String get arabicScaleLarge => 'بڑا';
	@override String get arabicScaleXLarge => 'بہت بڑا';
	@override String get about => 'تعارف';
	@override String get audioCredit => 'لفظ بہ لفظ تلاوت کا آڈیو بشکریہ Quran.com (Quran Foundation)۔';
}

// Path: word
class _Translations$word$ur extends Translations$word$en {
	_Translations$word$ur._(TranslationsUr root) : this._root = root, super.internal(root);

	final TranslationsUr _root; // ignore: unused_field

	// Translations
	@override String get translation => 'ترجمہ';
	@override String get root => 'مادہ';
	@override String get rootFamily => 'مادے کا خاندان';
	@override String get tafsir => 'تفسیر';
	@override String get gem => 'نکتہ';
	@override String get mnemonic => 'یاد رکھنے کی ترکیب';
	@override String get playAudio => 'تلفظ سنیں';
	@override String get stopAudio => 'روکیں';
	@override String get noAudio => 'ابھی آڈیو نہیں';
	@override String get occurrences => 'قرآن میں {count} بار';
	@override String get versesTitle => 'قرآن میں';
	@override late final _Translations$word$pos$ur pos = _Translations$word$pos$ur._(_root);
}

// Path: rootFamily
class _Translations$rootFamily$ur extends Translations$rootFamily$en {
	_Translations$rootFamily$ur._(TranslationsUr root) : this._root = root, super.internal(root);

	final TranslationsUr _root; // ignore: unused_field

	// Translations
	@override String get title => 'مادے کا خاندان';
	@override String get subtitle => '{root} مادہ رکھنے والے الفاظ';
	@override String get empty => 'اس مادے کے لیے کوئی لفظ نہیں ملا';
}

// Path: onboarding
class _Translations$onboarding$ur extends Translations$onboarding$en {
	_Translations$onboarding$ur._(TranslationsUr root) : this._root = root, super.internal(root);

	final TranslationsUr _root; // ignore: unused_field

	// Translations
	@override String get skip => 'چھوڑیں';
	@override String get next => 'اگلا';
	@override String get start => 'شروع کریں';
	@override String get slide1Title => 'قرآن کو سمجھیں';
	@override String get slide1Body => 'پڑھنے سے سمجھنے کی طرف — میکانکی تلاوت سے دل کی تلاوت (تدبر) کی طرف۔';
	@override String get slide2Title => 'کوئی بھی لفظ تلاش کریں';
	@override String get slide2Body => 'قرآنی لفظ عربی یا رومن حروف میں لکھیں۔ تلاش حرکات اور ہجے میں نرمی رکھتی ہے۔';
	@override String get slide3Title => 'اس کا معنی دریافت کریں';
	@override String get slide3Body => 'کسی لفظ پر ٹیپ کریں اور اس کا کارڈ دیکھیں: ترجمہ، مادہ، تفسیر، روحانی نکتہ اور یاد رکھنے کی ترکیب — اس کے تلفظ کے ساتھ۔';
}

// Path: word.pos
class _Translations$word$pos$ur extends Translations$word$pos$en {
	_Translations$word$pos$ur._(TranslationsUr root) : this._root = root, super.internal(root);

	final TranslationsUr _root; // ignore: unused_field

	// Translations
	@override String get noun => 'اسم';
	@override String get verb => 'فعل';
	@override String get particle => 'حرف';
	@override String get adjective => 'صفت';
	@override String get pronoun => 'ضمیر';
	@override String get other => 'دیگر';
}

/// The flat map containing all translations for locale <ur>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsUr {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'appTitle' => 'Af\'ham',
			'appTagline' => 'قرآن کے الفاظ سمجھیں',
			'searchHint' => 'قرآنی لفظ تلاش کریں…',
			'searchHintArabic' => 'رَحْمَة  ·  rahma  ·  صبر',
			'wordOfTheDay' => 'آج کا لفظ',
			'noResults' => 'کوئی نتیجہ نہیں ملا',
			'noResultsFor' => '«{query}» کے لیے کوئی نتیجہ نہیں',
			'searchPrompt' => 'قرآن سے کوئی لفظ تلاش کریں',
			'searchPromptSub' => 'عربی یا رومن حروف میں',
			'loading' => 'لوڈ ہو رہا ہے…',
			'error' => 'ایک خرابی پیش آگئی',
			'retry' => 'دوبارہ کوشش کریں',
			'settings.title' => 'ترتیبات',
			'settings.theme' => 'تھیم',
			'settings.themeLight' => 'روشن (Daftar)',
			'settings.themeDark' => 'تاریک (Sakīna)',
			'settings.themeSystem' => 'سسٹم',
			'settings.language' => 'زبان',
			'settings.languageFr' => 'Français',
			'settings.languageEn' => 'English',
			'settings.languageId' => 'Bahasa Indonesia',
			'settings.languageUr' => 'اردو',
			'settings.arabicScale' => 'عربی فونٹ کا سائز',
			'settings.arabicScaleSmall' => 'چھوٹا',
			'settings.arabicScaleNormal' => 'عام',
			'settings.arabicScaleLarge' => 'بڑا',
			'settings.arabicScaleXLarge' => 'بہت بڑا',
			'settings.about' => 'تعارف',
			'settings.audioCredit' => 'لفظ بہ لفظ تلاوت کا آڈیو بشکریہ Quran.com (Quran Foundation)۔',
			'word.translation' => 'ترجمہ',
			'word.root' => 'مادہ',
			'word.rootFamily' => 'مادے کا خاندان',
			'word.tafsir' => 'تفسیر',
			'word.gem' => 'نکتہ',
			'word.mnemonic' => 'یاد رکھنے کی ترکیب',
			'word.playAudio' => 'تلفظ سنیں',
			'word.stopAudio' => 'روکیں',
			'word.noAudio' => 'ابھی آڈیو نہیں',
			'word.occurrences' => 'قرآن میں {count} بار',
			'word.versesTitle' => 'قرآن میں',
			'word.pos.noun' => 'اسم',
			'word.pos.verb' => 'فعل',
			'word.pos.particle' => 'حرف',
			'word.pos.adjective' => 'صفت',
			'word.pos.pronoun' => 'ضمیر',
			'word.pos.other' => 'دیگر',
			'rootFamily.title' => 'مادے کا خاندان',
			'rootFamily.subtitle' => '{root} مادہ رکھنے والے الفاظ',
			'rootFamily.empty' => 'اس مادے کے لیے کوئی لفظ نہیں ملا',
			'onboarding.skip' => 'چھوڑیں',
			'onboarding.next' => 'اگلا',
			'onboarding.start' => 'شروع کریں',
			'onboarding.slide1Title' => 'قرآن کو سمجھیں',
			'onboarding.slide1Body' => 'پڑھنے سے سمجھنے کی طرف — میکانکی تلاوت سے دل کی تلاوت (تدبر) کی طرف۔',
			'onboarding.slide2Title' => 'کوئی بھی لفظ تلاش کریں',
			'onboarding.slide2Body' => 'قرآنی لفظ عربی یا رومن حروف میں لکھیں۔ تلاش حرکات اور ہجے میں نرمی رکھتی ہے۔',
			'onboarding.slide3Title' => 'اس کا معنی دریافت کریں',
			'onboarding.slide3Body' => 'کسی لفظ پر ٹیپ کریں اور اس کا کارڈ دیکھیں: ترجمہ، مادہ، تفسیر، روحانی نکتہ اور یاد رکھنے کی ترکیب — اس کے تلفظ کے ساتھ۔',
			_ => null,
		};
	}
}
