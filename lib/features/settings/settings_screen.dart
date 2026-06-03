import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bayan/core/providers/settings_providers.dart';

/// Settings screen — lets the user switch theme (Daftar/Sakīna/System)
/// and language (FR/EN).
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // --- Theme ---
          const _SectionHeader(title: 'Theme'),
          _ThemeTile(
            label: 'Light (Daftar)',
            mode: ThemeMode.light,
            current: themeMode,
            onTap: () => ref
                .read(themeModeProvider.notifier)
                .setThemeMode(ThemeMode.light),
          ),
          _ThemeTile(
            label: 'Dark (Sakīna)',
            mode: ThemeMode.dark,
            current: themeMode,
            onTap: () => ref
                .read(themeModeProvider.notifier)
                .setThemeMode(ThemeMode.dark),
          ),
          _ThemeTile(
            label: 'System',
            mode: ThemeMode.system,
            current: themeMode,
            onTap: () => ref
                .read(themeModeProvider.notifier)
                .setThemeMode(ThemeMode.system),
          ),

          const Divider(),

          // --- Language ---
          const _SectionHeader(title: 'Language'),
          _LocaleTile(
            label: 'Français',
            locale: const Locale('fr'),
            current: locale,
            onTap: () =>
                ref.read(localeProvider.notifier).setLocale(const Locale('fr')),
          ),
          _LocaleTile(
            label: 'English',
            locale: const Locale('en'),
            current: locale,
            onTap: () =>
                ref.read(localeProvider.notifier).setLocale(const Locale('en')),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _ThemeTile extends StatelessWidget {
  const _ThemeTile({
    required this.label,
    required this.mode,
    required this.current,
    required this.onTap,
  });

  final String label;
  final ThemeMode mode;
  final ThemeMode current;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      trailing: current == mode
          ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
          : null,
      onTap: onTap,
    );
  }
}

class _LocaleTile extends StatelessWidget {
  const _LocaleTile({
    required this.label,
    required this.locale,
    required this.current,
    required this.onTap,
  });

  final String label;
  final Locale locale;
  final Locale current;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      trailing: current == locale
          ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
          : null,
      onTap: onTap,
    );
  }
}
