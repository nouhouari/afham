import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bayan/core/i18n/strings.g.dart';
import 'package:bayan/core/theme/app_tokens.dart';
import 'package:bayan/core/theme/dimens.dart';
import 'package:bayan/data/audio/audio_clip.dart';
import 'package:bayan/data/audio/audio_repository.dart';
import 'package:bayan/data/database/database_provider.dart';
import 'package:bayan/data/database/models/lemma_detail.dart';

// ── Public entry point ────────────────────────────────────────────────────────

/// Opens the word-detail bottom sheet for [lemmaId].
///
/// Usage (from any screen):
/// ```dart
/// showWordDetailSheet(context, lemmaId: 42);
/// ```
Future<void> showWordDetailSheet(
  BuildContext context, {
  required int lemmaId,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    // Clip so the drag handle and top-radius render correctly.
    clipBehavior: Clip.antiAliasWithSaveLayer,
    backgroundColor: Colors.transparent,
    builder: (_) => _WordDetailSheet(lemmaId: lemmaId),
  );
}

// ── Sheet wrapper ─────────────────────────────────────────────────────────────

class _WordDetailSheet extends ConsumerWidget {
  const _WordDetailSheet({required this.lemmaId});

  final int lemmaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(lemmaDetailProvider(lemmaId));
    final tokens = Theme.of(context).extension<BayanTokens>()!;
    final colorScheme = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      expand: false,
      snap: true,
      snapSizes: const [0.55, 0.92],
      builder: (context, scrollController) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            boxShadow: tokens.sheetShadow,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(Radii.sheet),
            ),
          ),
          child: Column(
            children: [
              // Drag handle
              const _DragHandle(),
              // Content
              Expanded(
                child: detailAsync.when(
                  data: (detail) => detail == null
                      ? _SheetError(
                          message: 'Lemma #$lemmaId not found',
                          scrollController: scrollController,
                        )
                      : _SheetContent(
                          detail: detail,
                          scrollController: scrollController,
                        ),
                  loading: () => const _SheetLoading(),
                  error: (e, _) => _SheetError(
                    message: e.toString(),
                    scrollController: scrollController,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Drag handle ───────────────────────────────────────────────────────────────

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.md),
      child: Center(
        child: Container(
          width: 36,
          height: 4,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface.withAlpha(50),
            borderRadius: BorderRadius.circular(Radii.pill),
          ),
        ),
      ),
    );
  }
}

// ── Loading / Error ───────────────────────────────────────────────────────────

class _SheetLoading extends StatelessWidget {
  const _SheetLoading();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: Theme.of(context).extension<BayanTokens>()!.accent,
      ),
    );
  }
}

class _SheetError extends StatelessWidget {
  const _SheetError({
    required this.message,
    required this.scrollController,
  });

  final String message;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      padding: const EdgeInsets.all(Spacing.xl),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: Spacing.md),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sheet content (6 blocs) ───────────────────────────────────────────────────

class _SheetContent extends StatelessWidget {
  const _SheetContent({
    required this.detail,
    required this.scrollController,
  });

  final LemmaDetail detail;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(
        Spacing.xl,
        Spacing.sm,
        Spacing.xl,
        Spacing.xxl,
      ),
      children: [
        // (a) Header: Arabic hero word + transliteration + audio
        _HeaderBlock(detail: detail),
        const SizedBox(height: Spacing.xl),

        // (b) Translation
        if (detail.translation.isNotEmpty) ...[
          _FactBlock(
            label: Translations.of(context).word.translation,
            body: detail.translation,
          ),
          const SizedBox(height: Spacing.lg),
        ],

        // (c) Root (tappable → root family)
        if (detail.hasRoot) ...[
          _RootBlock(detail: detail),
          const SizedBox(height: Spacing.lg),
        ],

        // (d) Tafsir
        if (detail.tafsir.isNotEmpty) ...[
          _FactBlock(
            label: Translations.of(context).word.tafsir,
            body: detail.tafsir,
          ),
          const SizedBox(height: Spacing.lg),
        ],

        // (e) Pépite — gold highlight box
        if (detail.gem.isNotEmpty) ...[
          _GemBlock(gem: detail.gem),
          const SizedBox(height: Spacing.lg),
        ],

        // (f) Astuce Mémo — green memo box
        if (detail.mnemonic.isNotEmpty) ...[
          _MemoBlock(mnemonic: detail.mnemonic),
          const SizedBox(height: Spacing.lg),
        ],

        // Verse occurrences
        if (detail.verses.isNotEmpty) ...[
          _VersesBlock(verses: detail.verses),
        ],
      ],
    );
  }
}

// ── (a) Header block ──────────────────────────────────────────────────────────

class _HeaderBlock extends ConsumerWidget {
  const _HeaderBlock({required this.detail});

  final LemmaDetail detail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = Theme.of(context).extension<BayanTokens>()!;
    final theme = Theme.of(context);

    final clip = detail.hasAudio
        ? AudioClip(
            id: detail.audioId!,
            packFile: detail.audioPackFile!,
            startMs: detail.audioStartMs!,
            durationMs: detail.audioDurationMs!,
          )
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Arabic hero word
            Expanded(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  detail.lemmaAr,
                  style: tokens.arabicHero,
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            // Audio button
            _SheetAudioButton(clip: clip, tokens: tokens),
          ],
        ),
        const SizedBox(height: Spacing.xs),
        // Transliteration + POS pill
        Row(
          children: [
            Text(
              detail.latin,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(180),
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(width: Spacing.sm),
            _PosPill(pos: detail.pos),
          ],
        ),
      ],
    );
  }
}

// ── (b)/(d) Fact block ────────────────────────────────────────────────────────

class _FactBlock extends StatelessWidget {
  const _FactBlock({required this.label, required this.body});

  final String label;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.primary,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: Spacing.xs),
        Text(body, style: theme.textTheme.bodyLarge),
      ],
    );
  }
}

// ── (c) Root block ────────────────────────────────────────────────────────────

class _RootBlock extends StatelessWidget {
  const _RootBlock({required this.detail});

  final LemmaDetail detail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = Theme.of(context).extension<BayanTokens>()!;
    final strings = Translations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strings.word.root.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.primary,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: Spacing.xs),
        // Tappable root row → root family screen
        InkWell(
          onTap: () {
            Navigator.of(context).pop(); // close sheet first
            context.goNamed(
              'rootFamily',
              pathParameters: {'rootId': detail.rootId.toString()},
            );
          },
          borderRadius: BorderRadius.circular(Radii.chip),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.sm,
              vertical: Spacing.xs,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    detail.rootAr,
                    style: tokens.arabicBody.copyWith(
                      color: tokens.accent,
                    ),
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                Text(
                  '(${detail.rootLatin})',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(160),
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(width: Spacing.xs),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: tokens.accent,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── (e) Pépite block (gold) ───────────────────────────────────────────────────

class _GemBlock extends StatelessWidget {
  const _GemBlock({required this.gem});

  final String gem;

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<BayanTokens>()!;
    final theme = Theme.of(context);

    return _HighlightBox(
      borderColor: tokens.accent,
      fillColor: tokens.highlightBackground,
      label: Translations.of(context).word.gem.toUpperCase(),
      labelColor: tokens.accent,
      icon: Icons.auto_awesome_rounded,
      iconColor: tokens.accent,
      child: Text(gem, style: theme.textTheme.bodyLarge),
    );
  }
}

// ── (f) Mémo block (green) ────────────────────────────────────────────────────

class _MemoBlock extends StatelessWidget {
  const _MemoBlock({required this.mnemonic});

  final String mnemonic;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tokens = Theme.of(context).extension<BayanTokens>()!;
    final theme = Theme.of(context);

    return _HighlightBox(
      borderColor: colorScheme.secondary,
      fillColor: tokens.memoBackground,
      label: Translations.of(context).word.mnemonic.toUpperCase(),
      labelColor: colorScheme.secondary,
      icon: Icons.lightbulb_outline_rounded,
      iconColor: colorScheme.secondary,
      child: Text(mnemonic, style: theme.textTheme.bodyLarge),
    );
  }
}

// ── Shared highlight box ──────────────────────────────────────────────────────

class _HighlightBox extends StatelessWidget {
  const _HighlightBox({
    required this.borderColor,
    required this.fillColor,
    required this.label,
    required this.labelColor,
    required this.icon,
    required this.iconColor,
    required this.child,
  });

  final Color borderColor;
  final Color fillColor;
  final String label;
  final Color labelColor;
  final IconData icon;
  final Color iconColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: fillColor,
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(Radii.card),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 14, color: iconColor),
                const SizedBox(width: Spacing.xs),
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: labelColor,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.sm),
            child,
          ],
        ),
      ),
    );
  }
}

// ── Verses block ──────────────────────────────────────────────────────────────

class _VersesBlock extends StatelessWidget {
  const _VersesBlock({required this.verses});

  final List<VerseSnippet> verses;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = Theme.of(context).extension<BayanTokens>()!;
    final colorScheme = theme.colorScheme;
    final strings = Translations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strings.word.versesTitle.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            color: colorScheme.primary,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: Spacing.sm),
        ...verses.map(
          (v) => Padding(
            padding: const EdgeInsets.only(bottom: Spacing.md),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withAlpha(80),
                borderRadius: BorderRadius.circular(Radii.card),
              ),
              child: Padding(
                padding: const EdgeInsets.all(Spacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        v.textUthmani,
                        style: tokens.arabicBody,
                        textAlign: TextAlign.right,
                      ),
                    ),
                    const SizedBox(height: Spacing.xs),
                    Text(
                      v.reference,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurface.withAlpha(120),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── POS pill ──────────────────────────────────────────────────────────────────

class _PosPill extends StatelessWidget {
  const _PosPill({required this.pos});

  final String pos;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = Translations.of(context);

    final label = switch (pos.toLowerCase()) {
      'noun' => strings.word.pos.noun,
      'verb' => strings.word.pos.verb,
      'particle' => strings.word.pos.particle,
      'adjective' => strings.word.pos.adjective,
      'pronoun' => strings.word.pos.pronoun,
      _ => pos,
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(Radii.chip),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurface.withAlpha(160),
        ),
      ),
    );
  }
}

// ── Audio button (inside sheet) ───────────────────────────────────────────────

class _SheetAudioButton extends ConsumerWidget {
  const _SheetAudioButton({required this.clip, required this.tokens});

  final AudioClip? clip;
  final BayanTokens tokens;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = Translations.of(context);

    if (clip == null) {
      return Tooltip(
        message: strings.word.noAudio,
        child: Icon(
          Icons.volume_off_outlined,
          size: 24,
          color: Theme.of(context).colorScheme.onSurface.withAlpha(60),
        ),
      );
    }

    final repo = ref.watch(audioRepositoryProvider);

    return StreamBuilder<AudioPlaybackState>(
      stream: repo.playbackState,
      initialData: AudioPlaybackState.idle,
      builder: (context, snapshot) {
        final state = snapshot.data ?? AudioPlaybackState.idle;
        final isThisClipActive = repo.currentClipId == clip!.id;

        if (isThisClipActive && state == AudioPlaybackState.loading) {
          return SizedBox(
            width: 48,
            height: 48,
            child: Padding(
              padding: const EdgeInsets.all(Spacing.md),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: tokens.accent,
              ),
            ),
          );
        }

        final isPlaying =
            isThisClipActive && state == AudioPlaybackState.playing;

        return IconButton(
          iconSize: 28,
          tooltip: isPlaying ? strings.word.stopAudio : strings.word.playAudio,
          icon: Icon(
            isPlaying
                ? Icons.stop_circle_rounded
                : Icons.play_circle_filled_rounded,
            color: tokens.accent,
          ),
          onPressed: () async {
            try {
              await repo.playClip(clip);
            } catch (_) {
              // Asset not yet present in dev — swallow silently.
            }
          },
        );
      },
    );
  }
}
