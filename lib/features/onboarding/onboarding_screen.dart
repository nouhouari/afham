import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bayan/core/i18n/strings.g.dart';
import 'package:bayan/core/providers/settings_providers.dart';
import 'package:bayan/core/theme/app_tokens.dart';
import 'package:bayan/core/theme/dimens.dart';

/// First-launch onboarding: three slides introducing the app. Persists an
/// `onboarding.seen` flag so it appears only once; "Skip" or "Get started"
/// mark it seen and replace the route with Search.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await ref.read(sharedPreferencesProvider).setBool(onboardingSeenKey, true);
    if (mounted) context.go('/');
  }

  void _next(int count) {
    if (_page >= count - 1) {
      _finish();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<BayanTokens>()!;
    final o = Translations.of(context).onboarding;

    final slides = <(IconData, String, String)>[
      (Icons.menu_book_outlined, o.slide1Title, o.slide1Body),
      (Icons.search_rounded, o.slide2Title, o.slide2Body),
      (Icons.auto_awesome_outlined, o.slide3Title, o.slide3Body),
    ];
    final isLast = _page == slides.length - 1;

    return Scaffold(
      backgroundColor: tokens.appBackground,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(Spacing.sm),
                child: TextButton(onPressed: _finish, child: Text(o.skip)),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: slides.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (context, i) {
                  final (icon, title, body) = slides[i];
                  return _Slide(
                    icon: icon,
                    title: title,
                    body: body,
                    tokens: tokens,
                  );
                },
              ),
            ),
            // Page indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < slides.length; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: i == _page ? 22 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: i == _page
                          ? tokens.accent
                          : Theme.of(
                              context,
                            ).colorScheme.onSurface.withAlpha(60),
                      borderRadius: BorderRadius.circular(Radii.pill),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: Spacing.xl),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Spacing.xl,
                0,
                Spacing.xl,
                Spacing.xl,
              ),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => _next(slides.length),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: Spacing.md),
                  ),
                  child: Text(isLast ? o.start : o.next),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  const _Slide({
    required this.icon,
    required this.title,
    required this.body,
    required this.tokens,
  });

  final IconData icon;
  final String title;
  final String body;
  final BayanTokens tokens;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.xxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: tokens.highlightBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 56, color: tokens.accent),
          ),
          const SizedBox(height: Spacing.xxl),
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Spacing.md),
          Text(
            body,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(180),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
