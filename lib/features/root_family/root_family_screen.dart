import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bayan/core/i18n/strings.g.dart';
import 'package:bayan/core/theme/app_tokens.dart';
import 'package:bayan/core/theme/dimens.dart';
import 'package:bayan/data/audio/audio_clip.dart';
import 'package:bayan/data/audio/audio_repository.dart';
import 'package:bayan/data/database/database_provider.dart';
import 'package:bayan/data/database/models/lemma_detail.dart';
import 'package:bayan/features/word_detail/word_detail_sheet.dart';

/// Screen listing all lemmas that share a given root.
///
/// Opened from the Root chip inside the word-detail sheet, or directly via
/// the `/root/:rootId` route.
class RootFamilyScreen extends ConsumerWidget {
  const RootFamilyScreen({super.key, required this.rootId});

  final int rootId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(rootFamilyItemsProvider(rootId));
    final tokens = Theme.of(context).extension<BayanTokens>()!;
    final strings = Translations.of(context);

    return Scaffold(
      backgroundColor: tokens.appBackground,
      appBar: AppBar(
        backgroundColor: tokens.appBackground,
        elevation: 0,
        title: Text(strings.rootFamily.title),
        // Subtitle showing root in Arabic shown in body, not AppBar
      ),
      body: itemsAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return _EmptyState(strings: strings);
          }
          return _RootFamilyList(rootId: rootId, items: items, tokens: tokens);
        },
        loading: () => Center(
          child: CircularProgressIndicator(color: tokens.accent),
        ),
        error: (e, _) => _ErrorState(message: e.toString()),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.strings});
  final Translations strings;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.grain_rounded,
            size: 56,
            color: Theme.of(context).colorScheme.onSurface.withAlpha(60),
          ),
          const SizedBox(height: Spacing.md),
          Text(
            strings.rootFamily.empty,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── Error state ───────────────────────────────────────────────────────────────

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.xl),
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.error,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

// ── List ──────────────────────────────────────────────────────────────────────

class _RootFamilyList extends StatelessWidget {
  const _RootFamilyList({
    required this.rootId,
    required this.items,
    required this.tokens,
  });

  final int rootId;
  final List<RootFamilyItem> items;
  final BayanTokens tokens;

  @override
  Widget build(BuildContext context) {
    final strings = Translations.of(context);

    return CustomScrollView(
      slivers: [
        // Subtitle header with root Arabic and count
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              Spacing.xl,
              Spacing.sm,
              Spacing.xl,
              Spacing.lg,
            ),
            child: Text(
              strings.rootFamily.subtitle.replaceAll(
                '{root}',
                items.isNotEmpty ? items.first.rootAr : '',
              ),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(160),
              ),
            ),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.lg,
            vertical: Spacing.xs,
          ),
          sliver: SliverList.separated(
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: Spacing.sm),
            itemBuilder: (context, i) =>
                _FamilyTile(item: items[i], tokens: tokens),
          ),
        ),

        // Bottom safe-area padding
        const SliverToBoxAdapter(child: SizedBox(height: Spacing.xxl)),
      ],
    );
  }
}

// ── Family tile ───────────────────────────────────────────────────────────────

class _FamilyTile extends StatelessWidget {
  const _FamilyTile({required this.item, required this.tokens});

  final RootFamilyItem item;
  final BayanTokens tokens;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final clip = item.hasAudio
        ? AudioClip(
            id: item.audioId!,
            packFile: item.audioPackFile!,
            startMs: item.audioStartMs!,
            durationMs: item.audioDurationMs!,
          )
        : null;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: tokens.cardShadow,
        borderRadius: BorderRadius.circular(Radii.card),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(Radii.card),
        onTap: () => showWordDetailSheet(context, lemmaId: item.lemmaId),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.lg,
            vertical: Spacing.md,
          ),
          child: Row(
            children: [
              // Arabic word
              Directionality(
                textDirection: TextDirection.rtl,
                child: Text(item.lemmaAr, style: tokens.arabicBody),
              ),
              const SizedBox(width: Spacing.sm),
              // Transliteration
              Text(
                item.latin,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: colorScheme.onSurface.withAlpha(140),
                ),
              ),
              const Spacer(),
              // Translation (truncated)
              if (item.translation.isNotEmpty)
                Flexible(
                  child: Text(
                    item.translation,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withAlpha(180),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                  ),
                ),
              const SizedBox(width: Spacing.xs),
              // Audio button
              _FamilyAudioButton(clip: clip, tokens: tokens),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Audio button for family tiles ─────────────────────────────────────────────

class _FamilyAudioButton extends ConsumerWidget {
  const _FamilyAudioButton({required this.clip, required this.tokens});

  final AudioClip? clip;
  final BayanTokens tokens;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (clip == null) {
      return Icon(
        Icons.volume_off_outlined,
        size: 18,
        color: Theme.of(context).colorScheme.onSurface.withAlpha(50),
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
            width: 32,
            height: 32,
            child: Padding(
              padding: const EdgeInsets.all(Spacing.sm),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: tokens.accent,
              ),
            ),
          );
        }

        final isPlaying =
            isThisClipActive && state == AudioPlaybackState.playing;

        return GestureDetector(
          onTap: () async {
            try {
              await repo.playClip(clip);
            } catch (_) {}
          },
          child: Icon(
            isPlaying
                ? Icons.stop_circle_outlined
                : Icons.play_circle_outline_rounded,
            size: 22,
            color: tokens.accent,
          ),
        );
      },
    );
  }
}
