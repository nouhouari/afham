import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bayan/core/i18n/strings.g.dart';
import 'package:bayan/core/providers/settings_providers.dart';
import 'package:bayan/core/theme/app_tokens.dart';
import 'package:bayan/core/theme/dimens.dart';

/// Settings screen — theme, language, and (optional) Arabic font scale.
///
/// All three preferences are persisted via [SharedPreferences] through
/// [ThemeModeNotifier] and [LocaleNotifier]. The UI rebuilds immediately on
/// change, proving persistence on the same session; relaunching the app
/// restores the saved values (wired in `main()`).
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = Theme.of(context).extension<BayanTokens>()!;
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final strings = Translations.of(context);

    return Scaffold(
      backgroundColor: tokens.appBackground,
      appBar: AppBar(
        backgroundColor: tokens.appBackground,
        elevation: 0,
        title: Text(strings.settings.title),
      ),
      body: ListView(
        // Add the system nav-bar inset so the last item (About) can scroll
        // fully clear of the bottom navigation bar.
        padding: EdgeInsets.only(
          bottom: Spacing.xxl + MediaQuery.viewPaddingOf(context).bottom,
        ),
        children: [
          // ── Theme section ────────────────────────────────────────────────────
          _SectionHeader(label: strings.settings.theme),
          _ThemeOption(
            label: strings.settings.themeLight,
            description: 'Daftar — Ivoire & encre',
            icon: Icons.light_mode_outlined,
            mode: ThemeMode.light,
            current: themeMode,
            tokens: tokens,
            onTap: () => ref
                .read(themeModeProvider.notifier)
                .setThemeMode(ThemeMode.light),
          ),
          _ThemeOption(
            label: strings.settings.themeDark,
            description: 'Sakīna — Vert-nuit & or',
            icon: Icons.dark_mode_outlined,
            mode: ThemeMode.dark,
            current: themeMode,
            tokens: tokens,
            onTap: () => ref
                .read(themeModeProvider.notifier)
                .setThemeMode(ThemeMode.dark),
          ),
          _ThemeOption(
            label: strings.settings.themeSystem,
            description: 'Suit le réglage système',
            icon: Icons.phone_android_outlined,
            mode: ThemeMode.system,
            current: themeMode,
            tokens: tokens,
            onTap: () => ref
                .read(themeModeProvider.notifier)
                .setThemeMode(ThemeMode.system),
          ),

          const _Divider(),

          // ── Language section ─────────────────────────────────────────────────
          _SectionHeader(label: strings.settings.language),
          _LanguageOption(
            label: strings.settings.languageFr,
            locale: const Locale('fr'),
            current: locale,
            tokens: tokens,
            onTap: () =>
                ref.read(localeProvider.notifier).setLocale(const Locale('fr')),
          ),
          _LanguageOption(
            label: strings.settings.languageEn,
            locale: const Locale('en'),
            current: locale,
            tokens: tokens,
            onTap: () =>
                ref.read(localeProvider.notifier).setLocale(const Locale('en')),
          ),
          _LanguageOption(
            label: strings.settings.languageId,
            locale: const Locale('id'),
            current: locale,
            tokens: tokens,
            onTap: () =>
                ref.read(localeProvider.notifier).setLocale(const Locale('id')),
          ),
          _LanguageOption(
            label: strings.settings.languageUr,
            locale: const Locale('ur'),
            current: locale,
            tokens: tokens,
            onTap: () =>
                ref.read(localeProvider.notifier).setLocale(const Locale('ur')),
          ),

          const _Divider(),

          // ── Arabic font scale section ─────────────────────────────────────────
          _SectionHeader(label: strings.settings.arabicScale),
          _ArabicScalePreview(tokens: tokens),
          const SizedBox(height: Spacing.sm),
          _ScaleOptionRow(tokens: tokens, strings: strings),

          const _Divider(),

          // ── About / credits section ───────────────────────────────────────────
          _SectionHeader(label: strings.settings.about),
          _CreditLine(
            icon: Icons.volume_up_outlined,
            text: strings.settings.audioCredit,
          ),
        ],
      ),
    );
  }
}

// ── Credit line ───────────────────────────────────────────────────────────────

class _CreditLine extends StatelessWidget {
  const _CreditLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Spacing.xl,
        Spacing.sm,
        Spacing.xl,
        Spacing.sm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: colorScheme.onSurface.withAlpha(140)),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withAlpha(170),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Spacing.xl,
        Spacing.xl,
        Spacing.xl,
        Spacing.xs,
      ),
      child: Text(
        label.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.primary,
          letterSpacing: 1.4,
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      indent: Spacing.xl,
      endIndent: Spacing.xl,
      color: Theme.of(context).colorScheme.outlineVariant,
    );
  }
}

// ── Theme option tile ─────────────────────────────────────────────────────────

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.label,
    required this.description,
    required this.icon,
    required this.mode,
    required this.current,
    required this.tokens,
    required this.onTap,
  });

  final String label;
  final String description;
  final IconData icon;
  final ThemeMode mode;
  final ThemeMode current;
  final BayanTokens tokens;
  final VoidCallback onTap;

  bool get _selected => current == mode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.lg,
        vertical: Spacing.xs,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _selected ? tokens.highlightBackground : colorScheme.surface,
          border: _selected
              ? Border.all(color: tokens.accent, width: 1.5)
              : Border.all(color: colorScheme.outlineVariant, width: 1),
          borderRadius: BorderRadius.circular(Radii.card),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(Radii.card),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.lg,
              vertical: Spacing.md,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: _selected
                      ? tokens.accent
                      : colorScheme.onSurface.withAlpha(160),
                ),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: _selected
                              ? colorScheme.onSurface
                              : colorScheme.onSurface,
                          fontWeight: _selected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                      Text(
                        description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withAlpha(140),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_selected)
                  Icon(Icons.check_rounded, size: 20, color: tokens.accent),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Language option tile ──────────────────────────────────────────────────────

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.label,
    required this.locale,
    required this.current,
    required this.tokens,
    required this.onTap,
  });

  final String label;
  final Locale locale;
  final Locale current;
  final BayanTokens tokens;
  final VoidCallback onTap;

  bool get _selected => current == locale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.lg,
        vertical: Spacing.xs,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _selected ? tokens.highlightBackground : colorScheme.surface,
          border: _selected
              ? Border.all(color: tokens.accent, width: 1.5)
              : Border.all(color: colorScheme.outlineVariant, width: 1),
          borderRadius: BorderRadius.circular(Radii.card),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(Radii.card),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.lg,
              vertical: Spacing.md,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: _selected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
                if (_selected)
                  Icon(Icons.check_rounded, size: 20, color: tokens.accent),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Arabic scale preview + selector ──────────────────────────────────────────

class _ArabicScalePreview extends StatelessWidget {
  const _ArabicScalePreview({required this.tokens});
  final BayanTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.xl,
        vertical: Spacing.sm,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest.withAlpha(80),
          borderRadius: BorderRadius.circular(Radii.card),
        ),
        child: Padding(
          padding: const EdgeInsets.all(Spacing.lg),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
              style: tokens.arabicHero,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

/// Compact row of scale chips (non-wired, visual-only for Phase 5).
/// Wiring to a scale provider is left for a future sprint.
class _ScaleOptionRow extends StatelessWidget {
  const _ScaleOptionRow({required this.tokens, required this.strings});
  final BayanTokens tokens;
  final Translations strings;

  @override
  Widget build(BuildContext context) {
    final items = [
      strings.settings.arabicScaleSmall,
      strings.settings.arabicScaleNormal,
      strings.settings.arabicScaleLarge,
      strings.settings.arabicScaleXLarge,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.xl),
      child: Row(
        children: items.map((label) {
          // Default selected: Normal
          final isSelected = label == strings.settings.arabicScaleNormal;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.xs / 2),
              child: _ScaleChip(
                label: label,
                selected: isSelected,
                tokens: tokens,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ScaleChip extends StatelessWidget {
  const _ScaleChip({
    required this.label,
    required this.selected,
    required this.tokens,
  });

  final String label;
  final bool selected;
  final BayanTokens tokens;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: selected ? tokens.highlightBackground : colorScheme.surface,
        border: Border.all(
          color: selected ? tokens.accent : colorScheme.outlineVariant,
          width: selected ? 1.5 : 1,
        ),
        borderRadius: BorderRadius.circular(Radii.chip),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.xs,
          vertical: Spacing.sm,
        ),
        child: Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: selected
                ? colorScheme.onSurface
                : colorScheme.onSurface.withAlpha(160),
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
