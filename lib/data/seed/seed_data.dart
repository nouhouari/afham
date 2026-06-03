// ignore_for_file: lines_longer_than_80_chars, prefer_single_quotes
import 'package:drift/drift.dart';

import 'package:bayan/core/text/arabic_normalizer.dart';
import 'package:bayan/data/database/app_database.dart';
import 'package:bayan/data/database/daos/seed_dao.dart';

/// Inserts ~20 authentic Quranic lemmas into the database.
///
/// Called once at first launch if [SearchDao.isSeeded] returns false.
/// Uses [SeedDao] helpers which call insertOnConflictUpdate, so re-running is
/// idempotent.
Future<void> seedDatabase(AppDatabase db) async {
  final dao = db.seedDao;

  await db.transaction(() async {
    // ------------------------------------------------------------------
    // 1. ROOTS
    // ------------------------------------------------------------------
    final rootRhm = await dao.insertRoot(
      RootsCompanion.insert(
        rootAr: 'ر-ح-م',
        rootNormalized: normalizeArabic('رحم'),
        latin: 'r-h-m',
      ),
    );
    final rootAll = await dao.insertRoot(
      RootsCompanion.insert(
        rootAr: 'إ-ل-ه',
        rootNormalized: normalizeArabic('اله'),
        latin: 'i-l-h',
      ),
    );
    final rootRbb = await dao.insertRoot(
      RootsCompanion.insert(
        rootAr: 'ر-ب-ب',
        rootNormalized: normalizeArabic('ربب'),
        latin: 'r-b-b',
      ),
    );
    final rootKtb = await dao.insertRoot(
      RootsCompanion.insert(
        rootAr: 'ك-ت-ب',
        rootNormalized: normalizeArabic('كتب'),
        latin: 'k-t-b',
      ),
    );
    final rootAlm = await dao.insertRoot(
      RootsCompanion.insert(
        rootAr: 'ع-ل-م',
        rootNormalized: normalizeArabic('علم'),
        latin: 'a-l-m',
      ),
    );
    final rootNwr = await dao.insertRoot(
      RootsCompanion.insert(
        rootAr: 'ن-و-ر',
        rootNormalized: normalizeArabic('نور'),
        latin: 'n-w-r',
      ),
    );
    final rootSll = await dao.insertRoot(
      RootsCompanion.insert(
        rootAr: 'ص-ل-و',
        rootNormalized: normalizeArabic('صلو'),
        latin: 's-l-w',
      ),
    );
    final rootAmn = await dao.insertRoot(
      RootsCompanion.insert(
        rootAr: 'أ-م-ن',
        rootNormalized: normalizeArabic('امن'),
        latin: 'a-m-n',
      ),
    );
    final rootHmd = await dao.insertRoot(
      RootsCompanion.insert(
        rootAr: 'ح-م-د',
        rootNormalized: normalizeArabic('حمد'),
        latin: 'h-m-d',
      ),
    );
    final rootHdY = await dao.insertRoot(
      RootsCompanion.insert(
        rootAr: 'ه-د-ي',
        rootNormalized: normalizeArabic('هدي'),
        latin: 'h-d-y',
      ),
    );
    final rootSbr = await dao.insertRoot(
      RootsCompanion.insert(
        rootAr: 'ص-ب-ر',
        rootNormalized: normalizeArabic('صبر'),
        latin: 's-b-r',
      ),
    );
    final rootShkr = await dao.insertRoot(
      RootsCompanion.insert(
        rootAr: 'ش-ك-ر',
        rootNormalized: normalizeArabic('شكر'),
        latin: 'sh-k-r',
      ),
    );
    final rootTqw = await dao.insertRoot(
      RootsCompanion.insert(
        rootAr: 'ت-ق-و',
        rootNormalized: normalizeArabic('تقو'),
        latin: 't-q-w',
      ),
    );
    final rootFth = await dao.insertRoot(
      RootsCompanion.insert(
        rootAr: 'ف-ت-ح',
        rootNormalized: normalizeArabic('فتح'),
        latin: 'f-t-h',
      ),
    );
    final rootQlb = await dao.insertRoot(
      RootsCompanion.insert(
        rootAr: 'ق-ل-ب',
        rootNormalized: normalizeArabic('قلب'),
        latin: 'q-l-b',
      ),
    );
    final rootNfs = await dao.insertRoot(
      RootsCompanion.insert(
        rootAr: 'ن-ف-س',
        rootNormalized: normalizeArabic('نفس'),
        latin: 'n-f-s',
      ),
    );
    final rootDkr = await dao.insertRoot(
      RootsCompanion.insert(
        rootAr: 'ذ-ك-ر',
        rootNormalized: normalizeArabic('ذكر'),
        latin: 'dh-k-r',
      ),
    );
    final rootJnn = await dao.insertRoot(
      RootsCompanion.insert(
        rootAr: 'ج-ن-ن',
        rootNormalized: normalizeArabic('جنن'),
        latin: 'j-n-n',
      ),
    );
    final rootSlm = await dao.insertRoot(
      RootsCompanion.insert(
        rootAr: 'س-ل-م',
        rootNormalized: normalizeArabic('سلم'),
        latin: 's-l-m',
      ),
    );
    final rootKrm = await dao.insertRoot(
      RootsCompanion.insert(
        rootAr: 'ك-ر-م',
        rootNormalized: normalizeArabic('كرم'),
        latin: 'k-r-m',
      ),
    );

    // ------------------------------------------------------------------
    // 2. LEMMAS  (frequency = approximate corpus occurrence count)
    // ------------------------------------------------------------------
    final lAllah = await dao.insertLemma(
      LemmasCompanion.insert(
        lemmaAr: 'اللَّه',
        searchKey: normalizeArabic('الله'),
        latin: 'allah',
        pos: const Value('proper_noun'),
        frequency: const Value(2699),
        rootId: Value(rootAll),
      ),
    );
    final lRahma = await dao.insertLemma(
      LemmasCompanion.insert(
        lemmaAr: 'رَحْمَة',
        searchKey: normalizeArabic('رَحْمَة'),
        latin: 'rahma',
        pos: const Value('noun'),
        frequency: const Value(79),
        rootId: Value(rootRhm),
      ),
    );
    final lRabb = await dao.insertLemma(
      LemmasCompanion.insert(
        lemmaAr: 'رَبّ',
        searchKey: normalizeArabic('رَبّ'),
        latin: 'rabb',
        pos: const Value('noun'),
        frequency: const Value(980),
        rootId: Value(rootRbb),
      ),
    );
    final lKitab = await dao.insertLemma(
      LemmasCompanion.insert(
        lemmaAr: 'كِتَاب',
        searchKey: normalizeArabic('كِتَاب'),
        latin: 'kitab',
        pos: const Value('noun'),
        frequency: const Value(230),
        rootId: Value(rootKtb),
      ),
    );
    final lIlm = await dao.insertLemma(
      LemmasCompanion.insert(
        lemmaAr: 'عِلْم',
        searchKey: normalizeArabic('عِلْم'),
        latin: 'ilm',
        pos: const Value('noun'),
        frequency: const Value(105),
        rootId: Value(rootAlm),
      ),
    );
    final lNur = await dao.insertLemma(
      LemmasCompanion.insert(
        lemmaAr: 'نُور',
        searchKey: normalizeArabic('نُور'),
        latin: 'nur',
        pos: const Value('noun'),
        frequency: const Value(49),
        rootId: Value(rootNwr),
      ),
    );
    final lSalat = await dao.insertLemma(
      LemmasCompanion.insert(
        lemmaAr: 'صَلَاة',
        searchKey: normalizeArabic('صَلَاة'),
        latin: 'salat',
        pos: const Value('noun'),
        frequency: const Value(83),
        rootId: Value(rootSll),
      ),
    );
    final lIman = await dao.insertLemma(
      LemmasCompanion.insert(
        lemmaAr: 'إِيمَان',
        searchKey: normalizeArabic('إِيمَان'),
        latin: 'iman',
        pos: const Value('noun'),
        frequency: const Value(45),
        rootId: Value(rootAmn),
      ),
    );
    final lHamd = await dao.insertLemma(
      LemmasCompanion.insert(
        lemmaAr: 'حَمْد',
        searchKey: normalizeArabic('حَمْد'),
        latin: 'hamd',
        pos: const Value('noun'),
        frequency: const Value(43),
        rootId: Value(rootHmd),
      ),
    );
    final lHuda = await dao.insertLemma(
      LemmasCompanion.insert(
        lemmaAr: 'هُدًى',
        searchKey: normalizeArabic('هُدًى'),
        latin: 'huda',
        pos: const Value('noun'),
        frequency: const Value(87),
        rootId: Value(rootHdY),
      ),
    );
    final lSabr = await dao.insertLemma(
      LemmasCompanion.insert(
        lemmaAr: 'صَبْر',
        searchKey: normalizeArabic('صَبْر'),
        latin: 'sabr',
        pos: const Value('noun'),
        frequency: const Value(90),
        rootId: Value(rootSbr),
      ),
    );
    final lShukr = await dao.insertLemma(
      LemmasCompanion.insert(
        lemmaAr: 'شُكْر',
        searchKey: normalizeArabic('شُكْر'),
        latin: 'shukr',
        pos: const Value('noun'),
        frequency: const Value(75),
        rootId: Value(rootShkr),
      ),
    );
    final lTaqwa = await dao.insertLemma(
      LemmasCompanion.insert(
        lemmaAr: 'تَقْوَى',
        searchKey: normalizeArabic('تَقْوَى'),
        latin: 'taqwa',
        pos: const Value('noun'),
        frequency: const Value(258),
        rootId: Value(rootTqw),
      ),
    );
    final lFath = await dao.insertLemma(
      LemmasCompanion.insert(
        lemmaAr: 'فَتْح',
        searchKey: normalizeArabic('فَتْح'),
        latin: 'fath',
        pos: const Value('noun'),
        frequency: const Value(38),
        rootId: Value(rootFth),
      ),
    );
    final lQalb = await dao.insertLemma(
      LemmasCompanion.insert(
        lemmaAr: 'قَلْب',
        searchKey: normalizeArabic('قَلْب'),
        latin: 'qalb',
        pos: const Value('noun'),
        frequency: const Value(168),
        rootId: Value(rootQlb),
      ),
    );
    final lNafs = await dao.insertLemma(
      LemmasCompanion.insert(
        lemmaAr: 'نَفْس',
        searchKey: normalizeArabic('نَفْس'),
        latin: 'nafs',
        pos: const Value('noun'),
        frequency: const Value(295),
        rootId: Value(rootNfs),
      ),
    );
    final lDhikr = await dao.insertLemma(
      LemmasCompanion.insert(
        lemmaAr: 'ذِكْر',
        searchKey: normalizeArabic('ذِكْر'),
        latin: 'dhikr',
        pos: const Value('noun'),
        frequency: const Value(292),
        rootId: Value(rootDkr),
      ),
    );
    final lJanna = await dao.insertLemma(
      LemmasCompanion.insert(
        lemmaAr: 'جَنَّة',
        searchKey: normalizeArabic('جَنَّة'),
        latin: 'janna',
        pos: const Value('noun'),
        frequency: const Value(146),
        rootId: Value(rootJnn),
      ),
    );
    final lSalam = await dao.insertLemma(
      LemmasCompanion.insert(
        lemmaAr: 'سَلَام',
        searchKey: normalizeArabic('سَلَام'),
        latin: 'salam',
        pos: const Value('noun'),
        frequency: const Value(42),
        rootId: Value(rootSlm),
      ),
    );
    final lKarim = await dao.insertLemma(
      LemmasCompanion.insert(
        lemmaAr: 'كَرِيم',
        searchKey: normalizeArabic('كَرِيم'),
        latin: 'karim',
        pos: const Value('adjective'),
        frequency: const Value(47),
        rootId: Value(rootKrm),
      ),
    );

    // ------------------------------------------------------------------
    // 3. WORD CONTENT  (FR + EN per lemma)
    // ------------------------------------------------------------------
    final frContent = <int, ({String trans, String tafsir, String gem, String mnemonic})>{
      lAllah: (
        trans: "Allah — Le Nom par excellence de Dieu",
        tafsir:
            "Le mot aللَّه est le Nom propre de Dieu en arabe ; aucune autre divinite ne peut partager ce nom. Pour les exegetes, il englobe tous les attributs divins.",
        gem:
            "Le mot aللَّه est le seul nom invariable : il ne se met pas au pluriel et ne porte pas d'article indefini.",
        mnemonic:
            "Allah = Al-Ilah contracte : le seul ilah (dieu) digne de ce nom.",
      ),
      lRahma: (
        trans: "Misericorde, bienveillance",
        tafsir:
            "Ar-Rahma designe la bienveillance active de Dieu. Ibn Kathir souligne que la Basmala ouvre chaque sourate par deux attributs de cette misericorde : ar-Rahman (etendue) et ar-Rahim (profonde).",
        gem:
            "رَحْمَة partage sa racine ر-ح-م avec رَحِم (l'uterus) : la misericorde divine est comparee a la tendresse maternelle — une metaphore prophetique explicite.",
        mnemonic:
            "Pense a rahim (uterus en Darija) : la rahma enveloppe comme un sein maternel.",
      ),
      lRabb: (
        trans: "Seigneur, Maitre, Educateur",
        tafsir:
            "Rabb implique a la fois la seigneurie et le soin nourricier. L'imam ar-Razi note que رَبَّ (verbe) signifie elever, nourrir — Dieu est le Rabb parce qu'Il eleve toute chose vers sa perfection.",
        gem:
            "Le terme Rabb est presque exclusivement reserve a Dieu dans le Coran.",
        mnemonic:
            "Rabb est proche de rabbin en hebreu (meme racine semitique R-B-B = grandeur, maitrise).",
      ),
      lKitab: (
        trans: "Livre, Ecriture sacree",
        tafsir:
            "Al-Kitab designe principalement le Coran et les Ecritures revelees anterieures. La racine ك-ت-ب (ecrire) souligne le caractere fixe et preserve de la Parole divine.",
        gem:
            "Dans la sourate Al-Baqara (2:2), dhalika l-kitabu commence au demonstratif d'eloignement dhalika, signalant sa sublimite inatteignable.",
        mnemonic:
            "Kitab vient de kataba (ecrire) ; en Darija ktabi (ecris-moi) — le Livre est ce qui est ecrit et preserve.",
      ),
      lIlm: (
        trans: "Science, savoir, connaissance",
        tafsir:
            "Al-Ilm est l'un des attributs essentiels de Dieu (al-Alim). Dans le Coran, la connaissance est un depot divin accorde a l'homme.",
        gem:
            "Le premier mot revele au Prophete est Iqra (Lis !), et la sourate Al-Alaq mentionne l'ilm des les premiers versets.",
        mnemonic:
            "Ilm est proche de alam (monde, signe) — la connaissance est ce qui devoile le monde.",
      ),
      lNur: (
        trans: "Lumiere",
        tafsir:
            "L'ayat al-Nur (24:35) decrit Allah comme lumiere des cieux et de la terre. Ibn Arabi y voit la lumiere de l'etre irradiant vers la creation.",
        gem:
            "Nur est a la fois lumiere physique et lumiere spirituelle dans le Coran.",
        mnemonic:
            "Nour est un prenom tres courant au Maghreb — chacun porte la lumiere en soi.",
      ),
      lSalat: (
        trans: "Priere rituelle, connexion divine",
        tafsir:
            "As-Salat est le second pilier de l'Islam. Al-Ghazali dans l'Ihya explique que la salat est un entretien prive avec Dieu (munajat).",
        gem:
            "La racine ص-ل-و signifie se relier, se connecter. Quand on dit salla llah alayhi pour le Prophete, on demande a Dieu de le relier a Sa grace.",
        mnemonic:
            "Salat = connexion : ta priere est un appel direct a Dieu — ne raccroche pas !",
      ),
      lIman: (
        trans: "Foi, croyance interieure",
        tafsir:
            "Al-Iman differe de l'islam (soumission externe) : c'est la conviction du coeur. Le hadith de Jibrail le definit : croire en Allah, Ses anges, Ses Livres, Ses messagers, le Dernier Jour et le decret divin.",
        gem:
            "Iman vient d'aman (securite, paix). La foi est un refuge interieur que rien d'exterieur ne peut detruire.",
        mnemonic:
            "Iman est proche d'amine (confiance en Darija/hebreu) — la foi, c'est faire confiance a l'Etre absolu.",
      ),
      lHamd: (
        trans: "Louange, eloge merite",
        tafsir:
            "Al-Hamd differe du shukr (gratitude) : il loue l'etre meme de Dieu independamment des bienfaits recus. Al-Fatiha s'ouvre sur al-hamdu li-Llah.",
        gem:
            "Muhammad signifie le Tres Loue — sa nature meme est d'etre objet de hamd. Ahmad (variante) est l'un de ses noms coraniques (61:6).",
        mnemonic:
            "Hamd = Ahmed/Mohamed : on loue Dieu en nommant Son prophete.",
      ),
      lHuda: (
        trans: "Guidance, juste chemin",
        tafsir:
            "Al-Huda est l'un des noms du Coran (2:185). At-Tabari distingue la guidance generale (fitra) de la guidance speciale (wahy) reservee aux croyants.",
        gem:
            "La sourate Al-Fatiha se conclut par une demande de hidaya : ihdina s-sirata l-mustaqim — repete 17 fois par jour en priere.",
        mnemonic:
            "Houda est un prenom tres courant au Maghreb — la guidance portee comme identite.",
      ),
      lSabr: (
        trans: "Patience, endurance consentie",
        tafsir:
            "Ibn al-Qayyim identifie trois niveaux : patience dans l'obeissance, patience face aux epreuves, patience contre les peches. Le Coran mentionne as-sabr environ 90 fois.",
        gem:
            "As-sabr vient d'une racine qui signifie lier, retenir : la patience est l'acte de retenir son ame de la plainte — une discipline active, pas passive.",
        mnemonic:
            "S-ber en Darija (patience !) — tu l'entends dans chaque conseil de ta grand-mere.",
      ),
      lShukr: (
        trans: "Gratitude, reconnaissance",
        tafsir:
            "Ash-Shukr est la reponse du coeur aux bienfaits divins. Dieu dit : Si vous etes reconnaissants, J'augmenterai (14:7).",
        gem:
            "Le shukr s'exprime en trois dimensions : reconnaitre le bienfait dans le coeur, le confesser avec la langue, et l'utiliser pour obeir a Dieu.",
        mnemonic:
            "Shukran (merci en arabe) : tu remercies Dieu avec le meme mot que tu remercies les gens.",
      ),
      lTaqwa: (
        trans: "Piete, conscience de Dieu, crainte reverencielle",
        tafsir:
            "At-Taqwa est le critere de noblesse dans le Coran : le plus noble d'entre vous aupres d'Allah est le plus pieux (49:13). La racine و-ق-ي signifie proteger.",
        gem:
            "La taqwa est le fil conducteur du Coran : Al-Baqara s'ouvre sur guidance pour ceux qui ont la taqwa (2:2).",
        mnemonic:
            "Taqwa est proche de wqaya (protection en Darija) — la piete te protege comme un bouclier spirituel.",
      ),
      lFath: (
        trans: "Ouverture, victoire, conquete",
        tafsir:
            "Al-Fath designe a la fois l'ouverture physique et l'ouverture spirituelle du coeur. La sourate Al-Fath (48) commence par inna fatahna laka fathan mubina.",
        gem:
            "Al-Fatiha signifie l'Ouverture : ouvrir le Coran, ouvrir la priere, ouvrir le coeur.",
        mnemonic:
            "Fath partage sa racine avec fatha (signe de voyelle) — la voyelle ouvre la prononciation.",
      ),
      lQalb: (
        trans: "Coeur (siege de l'ame et de l'intellect)",
        tafsir:
            "Dans le Coran, le qalb est le lieu de la foi, de la comprehension et de la deviation. N'ont-ils pas des coeurs pour comprendre ? (22:46).",
        gem:
            "Qalb vient de la racine ق-ل-ب (se retourner) : le coeur humain est fluctuant. D'ou le dua : Ya muqallib al-qulub, thabbit qalbi.",
        mnemonic:
            "Qalb = retournement : ton coeur peut basculer — garde-le oriente vers Dieu.",
      ),
      lNafs: (
        trans: "Ame, soi, personne",
        tafsir:
            "Le Coran decrit trois niveaux : an-nafs al-ammara (qui incite au mal, 12:53), an-nafs al-lawwama (qui se reproche, 75:2), et an-nafs al-mutmainna (apaisee, 89:27).",
        gem:
            "Nafs a deux sens : moi (ego) et souffle vital. Purifier la nafs (tazkiya), c'est transformer l'ego en souffle pur au service de Dieu.",
        mnemonic:
            "Nafs est proche de nefes (souffle en turc) : l'ame, c'est le souffle que Dieu a insuffle.",
      ),
      lDhikr: (
        trans: "Rappel, mention, souvenir de Dieu",
        tafsir:
            "Ad-Dhikr est un nom du Coran (15:9) et la pratique du souvenir de Dieu. Inna dh-dhikra tanfa ul-muminin (51:55).",
        gem:
            "Repeter le nom d'Allah, ses attributs, ou ses versets est une forme d'adoration continue accessible a tout instant.",
        mnemonic:
            "Dhikr est proche de dkara (il a mentionne en Darija) — mentionner Dieu a tout instant.",
      ),
      lJanna: (
        trans: "Paradis, jardin",
        tafsir:
            "Al-Janna est decrite dans le Coran comme un jardin de felicite eternelle. La racine ج-ن-ن signifie cacher, abriter.",
        gem:
            "La racine ج-ن-ن donne aussi jinn (cache) et janin (foetus cache dans l'uterus) : le paradis est ce qui est voile, inconnu, sa realite depasse toute imagination.",
        mnemonic:
            "Janna = jardin (avec le J arabe) — ton jardin interieur cultive par les bonnes actions.",
      ),
      lSalam: (
        trans: "Paix, salut, securite",
        tafsir:
            "As-Salam est l'un des 99 noms de Dieu (59:23). Le salut islamique as-salamu alaykum est une priere pour la paix.",
        gem:
            "Islam, Muslim, Salim, Salam partagent tous la racine س-ل-م (integrite). Etre musulman c'est aspirer a cette integrite totale.",
        mnemonic: "Salam est proche du prenom Salem — la paix comme identite.",
      ),
      lKarim: (
        trans: "Noble, genereux",
        tafsir:
            "Al-Karim est l'un des noms divins (27:40). Il qualifie aussi le Coran lui-meme (56:77 : Quranun karim).",
        gem:
            "Inna akramakum inda llahi atqakum (49:13) — la vraie noblesse est la taqwa, pas la lignee.",
        mnemonic:
            "Karim = prenom courant + karam (generosite en Darija) : etre karim c'est donner sans compter.",
      ),
    };

    final enContent = <int, String>{
      lAllah: "Allah — The proper Name of God",
      lRahma: "Mercy, compassion",
      lRabb: "Lord, Master, Nurturer",
      lKitab: "Book, Scripture",
      lIlm: "Knowledge, science",
      lNur: "Light",
      lSalat: "Prayer, ritual connection",
      lIman: "Faith, belief",
      lHamd: "Praise, due praise",
      lHuda: "Guidance, right path",
      lSabr: "Patience, steadfastness",
      lShukr: "Gratitude, thankfulness",
      lTaqwa: "God-consciousness, piety, reverence",
      lFath: "Opening, victory, conquest",
      lQalb: "Heart (seat of understanding and will)",
      lNafs: "Soul, self, person",
      lDhikr: "Remembrance, mention, reminder",
      lJanna: "Paradise, garden",
      lSalam: "Peace, safety, greeting",
      lKarim: "Noble, generous, honourable",
    };

    for (final entry in frContent.entries) {
      final lemmaId = entry.key;
      final c = entry.value;
      await dao.insertWordContent(
        WordContentCompanion.insert(
          lemmaId: lemmaId,
          langCode: 'fr',
          translation: c.trans,
          tafsir: Value(c.tafsir),
          gem: Value(c.gem),
          mnemonic: Value(c.mnemonic),
        ),
      );
    }
    for (final entry in enContent.entries) {
      await dao.insertWordContent(
        WordContentCompanion.insert(
          lemmaId: entry.key,
          langCode: 'en',
          translation: entry.value,
          tafsir: const Value(''),
          gem: const Value(''),
          mnemonic: const Value(''),
        ),
      );
    }

    // ------------------------------------------------------------------
    // 4. SURFACE FORMS  (2+ per lemma: covering common Quranic variants)
    // ------------------------------------------------------------------
    // Stored as list of records: (lemmaId, textAr, latin)
    final forms = <(int, String, String)>[
      (lAllah, 'اللَّهُ', 'allahu'),
      (lAllah, 'اللَّه', 'allah'),
      (lRahma, 'رَحْمَةً', 'rahmatan'),
      (lRahma, 'رَحْمَةُ', 'rahmatu'),
      (lRahma, 'رَحْمَتِهِ', 'rahmatihi'),
      (lRabb, 'رَبِّهِمْ', 'rabbihim'),
      (lRabb, 'رَبَّنَا', 'rabbana'),
      (lKitab, 'الْكِتَابَ', 'al-kitaba'),
      (lKitab, 'كِتَابٌ', 'kitabun'),
      (lIlm, 'عِلْمٌ', 'ilmun'),
      (lIlm, 'الْعِلْمِ', 'al-ilmi'),
      (lNur, 'نُورًا', 'nuran'),
      (lNur, 'نُورُ', 'nuru'),
      (lSalat, 'الصَّلَاةَ', 'as-salata'),
      (lSalat, 'صَلَاةٌ', 'salatun'),
      (lIman, 'إِيمَانًا', 'imanan'),
      (lIman, 'الْإِيمَانِ', 'al-imani'),
      (lHamd, 'الْحَمْدُ', 'al-hamdu'),
      (lHamd, 'حَمْدًا', 'hamdan'),
      (lHuda, 'هُدًى', 'hudan'),
      (lHuda, 'الْهُدَى', 'al-huda'),
      (lSabr, 'الصَّبْرِ', 'as-sabri'),
      (lSabr, 'صَبْرًا', 'sabran'),
      (lShukr, 'شُكْرًا', 'shukran'),
      (lShukr, 'الشُّكُورِ', 'ash-shukuri'),
      (lTaqwa, 'تَقْوَى', 'taqwa'),
      (lTaqwa, 'الْمُتَّقِينَ', 'al-muttaqin'),
      (lFath, 'فَتْحٌ', 'fathun'),
      (lFath, 'فَتَحْنَا', 'fatahna'),
      (lQalb, 'قَلْبٌ', 'qalbun'),
      (lQalb, 'الْقُلُوبِ', 'al-qulubi'),
      (lNafs, 'نَفْسٌ', 'nafsun'),
      (lNafs, 'أَنفُسَكُمْ', 'anfusakum'),
      (lDhikr, 'ذِكْرًا', 'dhikran'),
      (lDhikr, 'الذِّكْرَ', 'adh-dhikra'),
      (lJanna, 'جَنَّةً', 'jannatan'),
      (lJanna, 'الْجَنَّةِ', 'al-jannati'),
      (lSalam, 'سَلَامٌ', 'salamun'),
      (lSalam, 'السَّلَامُ', 'as-salamu'),
      (lKarim, 'كَرِيمٌ', 'karimun'),
      (lKarim, 'قُرْآنٌ كَرِيمٌ', 'quranun karimun'),
    ];

    // Map from form tuple to its inserted rowid.
    final sfIds = <(int, String, String), int>{};
    for (final f in forms) {
      final (lemmaId, textAr, latin) = f;
      final id = await dao.insertSurfaceForm(
        SurfaceFormsCompanion.insert(
          lemmaId: lemmaId,
          textAr: textAr,
          searchKey: normalizeArabic(textAr),
          latin: latin,
        ),
      );
      sfIds[f] = id;
    }

    // ------------------------------------------------------------------
    // 5. VERSES  (one representative verse per lemma)
    // ------------------------------------------------------------------
    final verseAllah = await dao.insertVerse(
      VersesCompanion.insert(
        surah: 1,
        ayah: 1,
        textUthmani: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        textSimple: const Value('بسم الله الرحمن الرحيم'),
      ),
    );
    final verseRahma = await dao.insertVerse(
      VersesCompanion.insert(
        surah: 6,
        ayah: 12,
        textUthmani: 'كَتَبَ عَلَىٰ نَفْسِهِ الرَّحْمَةَ',
        textSimple: const Value('كتب على نفسه الرحمة'),
      ),
    );
    final verseRabb = await dao.insertVerse(
      VersesCompanion.insert(
        surah: 1,
        ayah: 2,
        textUthmani: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
        textSimple: const Value('الحمد لله رب العالمين'),
      ),
    );
    final verseKitab = await dao.insertVerse(
      VersesCompanion.insert(
        surah: 2,
        ayah: 2,
        textUthmani:
            'ذَٰلِكَ الْكِتَابُ لَا رَيْبَ فِيهِ هُدًى لِّلْمُتَّقِينَ',
        textSimple: const Value('ذلك الكتاب لا ريب فيه هدى للمتقين'),
      ),
    );
    final verseIlm = await dao.insertVerse(
      VersesCompanion.insert(
        surah: 2,
        ayah: 31,
        textUthmani: 'وَعَلَّمَ آدَمَ الْأَسْمَاءَ كُلَّهَا',
        textSimple: const Value('وعلم آدم الأسماء كلها'),
      ),
    );
    final verseNur = await dao.insertVerse(
      VersesCompanion.insert(
        surah: 24,
        ayah: 35,
        textUthmani: 'اللَّهُ نُورُ السَّمَاوَاتِ وَالْأَرْضِ',
        textSimple: const Value('الله نور السماوات والأرض'),
      ),
    );
    final verseSalat = await dao.insertVerse(
      VersesCompanion.insert(
        surah: 2,
        ayah: 43,
        textUthmani: 'وَأَقِيمُوا الصَّلَاةَ وَآتُوا الزَّكَاةَ',
        textSimple: const Value('وأقيموا الصلاة وآتوا الزكاة'),
      ),
    );
    final verseIman = await dao.insertVerse(
      VersesCompanion.insert(
        surah: 2,
        ayah: 177,
        textUthmani: 'وَلَٰكِنَّ الْبِرَّ مَنْ آمَنَ بِاللَّهِ',
        textSimple: const Value('ولكن البر من آمن بالله'),
      ),
    );
    final verseShukr = await dao.insertVerse(
      VersesCompanion.insert(
        surah: 14,
        ayah: 7,
        textUthmani: 'لَئِن شَكَرْتُمْ لَأَزِيدَنَّكُمْ',
        textSimple: const Value('لئن شكرتم لأزيدنكم'),
      ),
    );
    final verseTaqwa = await dao.insertVerse(
      VersesCompanion.insert(
        surah: 49,
        ayah: 13,
        textUthmani: 'إِنَّ أَكْرَمَكُمْ عِندَ اللَّهِ أَتْقَاكُمْ',
        textSimple: const Value('إن أكرمكم عند الله أتقاكم'),
      ),
    );
    final verseFath = await dao.insertVerse(
      VersesCompanion.insert(
        surah: 48,
        ayah: 1,
        textUthmani: 'إِنَّا فَتَحْنَا لَكَ فَتْحًا مُّبِينًا',
        textSimple: const Value('إنا فتحنا لك فتحا مبينا'),
      ),
    );
    final verseQalb = await dao.insertVerse(
      VersesCompanion.insert(
        surah: 22,
        ayah: 46,
        textUthmani: 'فَتَكُونَ لَهُمْ قُلُوبٌ يَعْقِلُونَ بِهَا',
        textSimple: const Value('فتكون لهم قلوب يعقلون بها'),
      ),
    );
    final verseNafs = await dao.insertVerse(
      VersesCompanion.insert(
        surah: 89,
        ayah: 27,
        textUthmani: 'يَا أَيَّتُهَا النَّفْسُ الْمُطْمَئِنَّةُ',
        textSimple: const Value('يا أيتها النفس المطمئنة'),
      ),
    );
    final verseDhikr = await dao.insertVerse(
      VersesCompanion.insert(
        surah: 13,
        ayah: 28,
        textUthmani: 'أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ',
        textSimple: const Value('ألا بذكر الله تطمئن القلوب'),
      ),
    );
    final verseJanna = await dao.insertVerse(
      VersesCompanion.insert(
        surah: 3,
        ayah: 133,
        textUthmani: 'وَسَارِعُوا إِلَىٰ مَغْفِرَةٍ مِّن رَّبِّكُمْ وَجَنَّةٍ',
        textSimple: const Value('وسارعوا إلى مغفرة من ربكم وجنة'),
      ),
    );
    final verseSalam = await dao.insertVerse(
      VersesCompanion.insert(
        surah: 6,
        ayah: 54,
        textUthmani:
            'سَلَامٌ عَلَيْكُمْ كَتَبَ رَبُّكُمْ عَلَىٰ نَفْسِهِ الرَّحْمَةَ',
        textSimple: const Value('سلام عليكم كتب ربكم على نفسه الرحمة'),
      ),
    );
    final verseKarim = await dao.insertVerse(
      VersesCompanion.insert(
        surah: 56,
        ayah: 77,
        textUthmani: 'إِنَّهُ لَقُرْآنٌ كَرِيمٌ',
        textSimple: const Value('إنه لقرآن كريم'),
      ),
    );

    // These verse IDs are seeded but not yet used in occurrences.
    // ignore: unused_local_variable
    final unused1 = verseIlm;
    // ignore: unused_local_variable
    final unused2 = verseSalat;
    // ignore: unused_local_variable
    final unused3 = verseIman;

    // ------------------------------------------------------------------
    // 6. OCCURRENCES
    // ------------------------------------------------------------------
    // (lemmaId, textAr-of-surface, latin-of-surface, verseId, position)
    final occurrences = <(int, String, String, int, int)>[
      (lAllah, 'اللَّهُ', 'allahu', verseAllah, 2),
      (lRahma, 'رَحْمَةً', 'rahmatan', verseRahma, 4),
      (lKitab, 'الْكِتَابَ', 'al-kitaba', verseKitab, 1),
      (lNur, 'نُورُ', 'nuru', verseNur, 1),
      (lHamd, 'الْحَمْدُ', 'al-hamdu', verseRabb, 0),
      (lHuda, 'هُدًى', 'hudan', verseKitab, 7),
      (lSabr, 'صَبْرًا', 'sabran', verseFath, 5),
      (lShukr, 'شُكْرًا', 'shukran', verseShukr, 2),
      (lTaqwa, 'تَقْوَى', 'taqwa', verseTaqwa, 6),
      (lFath, 'فَتَحْنَا', 'fatahna', verseFath, 1),
      (lQalb, 'الْقُلُوبِ', 'al-qulubi', verseQalb, 5),
      (lNafs, 'نَفْسٌ', 'nafsun', verseNafs, 3),
      (lDhikr, 'الذِّكْرَ', 'adh-dhikra', verseDhikr, 2),
      (lJanna, 'جَنَّةً', 'jannatan', verseJanna, 8),
      (lSalam, 'سَلَامٌ', 'salamun', verseSalam, 0),
      (lKarim, 'كَرِيمٌ', 'karimun', verseKarim, 2),
    ];

    for (final (lemmaId, textAr, latin, verseId, pos) in occurrences) {
      final sfKey = forms
          .where((f) => f.$1 == lemmaId && f.$2 == textAr && f.$3 == latin)
          .firstOrNull;
      if (sfKey == null) continue;
      final sfId = sfIds[sfKey];
      if (sfId == null) continue;
      await dao.insertOccurrence(
        OccurrencesCompanion.insert(
          surfaceFormId: sfId,
          verseId: verseId,
          position: pos,
        ),
      );
    }
  });
}
