import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bayan/core/i18n/strings.g.dart';
import 'package:bayan/core/router/app_router.dart';
import 'package:bayan/core/theme/app_tokens.dart';
import 'package:bayan/core/theme/dimens.dart';
import 'package:bayan/data/audio/audio_clip.dart';
import 'package:bayan/data/audio/audio_repository.dart';
import 'package:bayan/data/database/database_provider.dart';
import 'package:bayan/data/database/models/lemma_detail.dart';
import 'package:bayan/data/database/models/search_result.dart';
import 'package:bayan/features/word_detail/word_detail_sheet.dart';

/// Home / Search screen.
///
/// - Empty query   → shows Mot du jour card (deterministic by day-of-month).
/// - Active query  → live FTS5 results list.
/// - Tap on result → opens [WordDetailSheet] as a draggable bottom sheet.
/// - Tap on Mot du jour → also opens [WordDetailSheet].
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<BayanTokens>()!;
    final query = ref.watch(searchQueryProvider);
    final resultsAsync = ref.watch(searchResultsProvider);
    final strings = Translations.of(context);

    return Scaffold(
      backgroundColor: tokens.appBackground,
      appBar: AppBar(
        backgroundColor: tokens.appBackground,
        elevation: 0,
        title: Text(strings.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: strings.settings.title,
            onPressed: () => context.goNamed('settings'),
          ),
          const SizedBox(width: Spacing.xs),
        ],
      ),
      body: Column(
        children: [
          _SearchField(controller: _controller, tokens: tokens),
          const _SearchDivider(),
          Expanded(
            child: resultsAsync.when(
              data: (results) => _ResultsBody(
                query: query,
                results: results,
                tokens: tokens,
              ),
              loading: () => _LoadingState(tokens: tokens),
              error: (e, _) => _ErrorState(error: e),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Search field ──────────────────────────────────────────────────────────────

class _SearchField extends ConsumerWidget {
  const _SearchField({required this.controller, required this.tokens});

  final TextEditingController controller;
  final BayanTokens tokens;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = Translations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.lg,
        vertical: Spacing.sm,
      ),
      child: TextField(
        controller: controller,
        textDirection: TextDirection.ltr,
        autofocus: false,
        style: Theme.of(context).textTheme.bodyLarge,
        decoration: InputDecoration(
          hintText: strings.searchHint,
          hintStyle: TextStyle(
            color: colorScheme.onSurface.withAlpha(100),
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: colorScheme.onSurface.withAlpha(160),
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    color: colorScheme.onSurface.withAlpha(160),
                  ),
                  onPressed: () {
                    controller.clear();
                    ref.read(searchQueryProvider.notifier).clear();
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Radii.card),
            borderSide: BorderSide(color: colorScheme.outlineVariant),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Radii.card),
            borderSide: BorderSide(color: colorScheme.outlineVariant),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Radii.card),
            borderSide: BorderSide(color: tokens.accent, width: 1.5),
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: Spacing.lg,
            vertical: Spacing.md,
          ),
        ),
        onChanged: (v) => ref.read(searchQueryProvider.notifier).update(v),
      ),
    );
  }
}

class _SearchDivider extends StatelessWidget {
  const _SearchDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      color: Theme.of(context).colorScheme.outlineVariant.withAlpha(80),
    );
  }
}

// ── Results / empty body ──────────────────────────────────────────────────────

class _ResultsBody extends StatelessWidget {
  const _ResultsBody({
    required this.query,
    required this.results,
    required this.tokens,
  });

  final String query;
  final List<SearchResult> results;
  final BayanTokens tokens;

  @override
  Widget build(BuildContext context) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return _EmptyHome(tokens: tokens);
    }
    if (results.isEmpty) {
      return _NoResults(query: trimmed);
    }
    return _ResultsList(results: results, tokens: tokens);
  }
}

// ── Loading / error ───────────────────────────────────────────────────────────

class _LoadingState extends StatelessWidget {
  const _LoadingState({required this.tokens});
  final BayanTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(color: tokens.accent),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.error});
  final Object error;

  @override
  Widget build(BuildContext context) {
    final strings = Translations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: Spacing.md),
            Text(
              strings.error,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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

// ── Empty home (Mot du jour) ──────────────────────────────────────────────────

class _EmptyHome extends ConsumerWidget {
  const _EmptyHome({required this.tokens});

  final BayanTokens tokens;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // dayOfMonth drives the deterministic word-of-day selection.
    final dayOfMonth = DateTime.now().day;
    final wordAsync = ref.watch(wordOfDayProvider(dayOfMonth));
    final strings = Translations.of(context);

    return CustomScrollView(
      slivers: [
        // Tagline
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              Spacing.xl,
              Spacing.xl,
              Spacing.xl,
              Spacing.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.appTagline,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withAlpha(180),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Word of the Day card
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
            child: wordAsync.when(
              data: (detail) => detail == null
                  ? _SearchPrompt()
                  : _WordOfDayCard(detail: detail, tokens: tokens),
              loading: () => _WordOfDayCardSkeleton(tokens: tokens),
              error: (_, __) => _SearchPrompt(),
            ),
          ),
        ),

        // Search prompt below card
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.all(Spacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.menu_book_outlined,
                  size: 56,
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(50),
                ),
                const SizedBox(height: Spacing.md),
                Text(
                  strings.searchPrompt,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withAlpha(160),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Spacing.xs),
                Text(
                  strings.searchPromptSub,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withAlpha(100),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Word of the Day card ──────────────────────────────────────────────────────

class _WordOfDayCard extends StatelessWidget {
  const _WordOfDayCard({required this.detail, required this.tokens});

  final LemmaDetail detail;
  final BayanTokens tokens;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final strings = Translations.of(context);

    final clip = detail.hasAudio
        ? AudioClip(
            id: detail.audioId!,
            packFile: detail.audioPackFile!,
            startMs: detail.audioStartMs!,
            durationMs: detail.audioDurationMs!,
          )
        : null;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: tokens.cardShadow,
        borderRadius: BorderRadius.circular(Radii.card),
        border: Border.all(color: tokens.accent.withAlpha(60), width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(Radii.card),
        onTap: () => showWordDetailSheet(context, lemmaId: detail.lemmaId),
        child: Padding(
          padding: const EdgeInsets.all(Spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row: label + audio button
              Row(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.wb_sunny_outlined,
                        size: 14,
                        color: tokens.accent,
                      ),
                      const SizedBox(width: Spacing.xs),
                      Text(
                        strings.wordOfTheDay.toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: tokens.accent,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  _CardAudioButton(clip: clip, tokens: tokens),
                ],
              ),
              const SizedBox(height: Spacing.md),

              // Arabic word (hero)
              Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  detail.lemmaAr,
                  style: tokens.arabicHero,
                ),
              ),
              const SizedBox(height: Spacing.xs),

              // Transliteration
              Text(
                detail.latin,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: colorScheme.onSurface.withAlpha(160),
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: Spacing.sm),

              // Translation
              if (detail.translation.isNotEmpty)
                Text(
                  detail.translation,
                  style: theme.textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

              // "Tap to discover" hint
              const SizedBox(height: Spacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.open_in_full_rounded,
                    size: 14,
                    color: colorScheme.onSurface.withAlpha(80),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WordOfDayCardSkeleton extends StatelessWidget {
  const _WordOfDayCardSkeleton({required this.tokens});
  final BayanTokens tokens;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: tokens.cardShadow,
        borderRadius: BorderRadius.circular(Radii.card),
      ),
      child: const Padding(
        padding: EdgeInsets.all(Spacing.lg),
        child: SizedBox(height: 120),
      ),
    );
  }
}

class _SearchPrompt extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

// ── Audio button on card ──────────────────────────────────────────────────────

class _CardAudioButton extends ConsumerWidget {
  const _CardAudioButton({required this.clip, required this.tokens});

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

// ── No results state ──────────────────────────────────────────────────────────

class _NoResults extends StatelessWidget {
  const _NoResults({required this.query});
  final String query;

  @override
  Widget build(BuildContext context) {
    final strings = Translations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 48,
              color: Theme.of(context).colorScheme.onSurface.withAlpha(60),
            ),
            const SizedBox(height: Spacing.md),
            Text(
              strings.noResultsFor.replaceAll('{query}', query),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(160),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Results list ──────────────────────────────────────────────────────────────

class _ResultsList extends StatelessWidget {
  const _ResultsList({required this.results, required this.tokens});

  final List<SearchResult> results;
  final BayanTokens tokens;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.lg,
        vertical: Spacing.sm,
      ),
      itemCount: results.length,
      separatorBuilder: (_, __) => const SizedBox(height: Spacing.sm),
      itemBuilder: (context, i) =>
          _ResultCard(result: results[i], tokens: tokens),
    );
  }
}

// ── Result card ───────────────────────────────────────────────────────────────

class _ResultCard extends ConsumerWidget {
  const _ResultCard({required this.result, required this.tokens});

  final SearchResult result;
  final BayanTokens tokens;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final clip = result.hasAudio
        ? AudioClip(
            id: result.audioId!,
            packFile: result.audioPackFile!,
            startMs: result.audioStartMs!,
            durationMs: result.audioDurationMs!,
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
        onTap: () => showWordDetailSheet(context, lemmaId: result.lemmaId),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.lg,
            vertical: Spacing.md,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: Arabic avatar chip
              _ArabicAvatar(lemmaAr: result.lemmaAr, tokens: tokens),
              const SizedBox(width: Spacing.md),

              // Centre: word info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text(
                            result.lemmaAr,
                            style: tokens.arabicBody,
                          ),
                        ),
                        const SizedBox(width: Spacing.sm),
                        Text(
                          result.latin,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: colorScheme.onSurface.withAlpha(140),
                          ),
                        ),
                        const Spacer(),
                        _PosLabel(pos: result.pos),
                      ],
                    ),
                    if (result.rootAr.isNotEmpty) ...[
                      const SizedBox(height: Spacing.xs),
                      Row(
                        children: [
                          Icon(
                            Icons.account_tree_outlined,
                            size: 12,
                            color: tokens.accent,
                          ),
                          const SizedBox(width: Spacing.xs),
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text(
                              result.rootAr,
                              style: tokens.arabicCaption,
                            ),
                          ),
                          const SizedBox(width: Spacing.xs),
                          Text(
                            result.rootLatin,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: tokens.accent,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (result.translation.isNotEmpty) ...[
                      const SizedBox(height: Spacing.xs),
                      Text(
                        result.translation,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withAlpha(200),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: Spacing.xs),

              // Right: audio button
              _ResultAudioButton(clip: clip, tokens: tokens),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArabicAvatar extends StatelessWidget {
  const _ArabicAvatar({required this.lemmaAr, required this.tokens});
  final String lemmaAr;
  final BayanTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: tokens.highlightBackground,
        borderRadius: BorderRadius.circular(Radii.card),
      ),
      alignment: Alignment.center,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Text(
          // Show first "letter unit" (may be 1-2 chars for Arabic + harakat)
          lemmaAr.characters.take(2).string,
          style: tokens.arabicCaption,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _PosLabel extends StatelessWidget {
  const _PosLabel({required this.pos});
  final String pos;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.xs, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(Radii.chip),
      ),
      child: Text(
        pos,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurface.withAlpha(140),
        ),
      ),
    );
  }
}

// ── Audio button for result cards ─────────────────────────────────────────────

class _ResultAudioButton extends ConsumerWidget {
  const _ResultAudioButton({required this.clip, required this.tokens});

  final AudioClip? clip;
  final BayanTokens tokens;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (clip == null) {
      return Padding(
        padding: const EdgeInsets.only(top: Spacing.xs),
        child: Icon(
          Icons.volume_off_outlined,
          size: 18,
          color: Theme.of(context).colorScheme.onSurface.withAlpha(50),
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
          child: Padding(
            padding: const EdgeInsets.only(top: Spacing.xs),
            child: Icon(
              isPlaying
                  ? Icons.stop_circle_outlined
                  : Icons.play_circle_outline_rounded,
              size: 22,
              color: tokens.accent,
            ),
          ),
        );
      },
    );
  }
}
