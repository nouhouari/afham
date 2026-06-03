import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bayan/core/i18n/strings.g.dart';
import 'package:bayan/core/theme/app_tokens.dart';
import 'package:bayan/data/audio/audio_clip.dart';
import 'package:bayan/data/audio/audio_repository.dart';
import 'package:bayan/data/database/database_provider.dart';
import 'package:bayan/data/database/models/search_result.dart';

/// Search / Home screen — Phase 2 functional implementation.
///
/// Wires a [TextField] to [searchQueryProvider] and displays live FTS5 results
/// via [searchResultsProvider]. UI is minimal (Phase 5 will add final polish).
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

    return Scaffold(
      backgroundColor: tokens.appBackground,
      appBar: AppBar(
        backgroundColor: tokens.appBackground,
        elevation: 0,
        title: Text(t.appTitle),
      ),
      body: Column(
        children: [
          _SearchField(controller: _controller, tokens: tokens),
          const Divider(height: 1),
          Expanded(
            child: resultsAsync.when(
              data: (results) =>
                  _ResultsList(query: query, results: results, tokens: tokens),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text(
                  'Erreur : $e',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: controller,
        // Explicit LTR so the cursor starts on the left even when the user
        // switches to Arabic — the RTL flip happens inside the result tiles.
        textDirection: TextDirection.ltr,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'رَحْمَة  ·  rahma  ·  صبر',
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withAlpha(100),
          ),
          prefixIcon: const Icon(Icons.search),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    controller.clear();
                    ref.read(searchQueryProvider.notifier).clear();
                  },
                )
              : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
        ),
        onChanged: (v) => ref.read(searchQueryProvider.notifier).update(v),
      ),
    );
  }
}

// ── Results list ──────────────────────────────────────────────────────────────

class _ResultsList extends StatelessWidget {
  const _ResultsList({
    required this.query,
    required this.results,
    required this.tokens,
  });

  final String query;
  final List<SearchResult> results;
  final BayanTokens tokens;

  @override
  Widget build(BuildContext context) {
    if (query.trim().isEmpty) {
      return const _EmptyPrompt();
    }
    if (results.isEmpty) {
      return Center(
        child: Text(
          'Aucun résultat pour « $query »',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: results.length,
      separatorBuilder: (context, index) =>
          const Divider(height: 1, indent: 72),
      itemBuilder: (context, i) =>
          _ResultTile(result: results[i], tokens: tokens),
    );
  }
}

class _EmptyPrompt extends StatelessWidget {
  const _EmptyPrompt();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.menu_book_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withAlpha(60),
          ),
          const SizedBox(height: 12),
          Text(
            'Cherche un mot du Coran',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 4),
          Text(
            'en arabe ou en translittération',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

// ── Result tile ───────────────────────────────────────────────────────────────

/// A single search result row. Extends [ConsumerWidget] so it can watch
/// [audioRepositoryProvider] and react to playback-state changes.
class _ResultTile extends ConsumerWidget {
  const _ResultTile({required this.result, required this.tokens});

  final SearchResult result;
  final BayanTokens tokens;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // Build the audio clip from result fields (null when no audio configured).
    final clip = result.hasAudio
        ? AudioClip(
            id: result.audioId!,
            packFile: result.audioPackFile!,
            startMs: result.audioStartMs!,
            durationMs: result.audioDurationMs!,
          )
        : null;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: tokens.highlightBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(result.lemmaAr, style: tokens.arabicCaption),
        ),
      ),
      title: Row(
        children: [
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(result.lemmaAr, style: tokens.arabicBody),
          ),
          const SizedBox(width: 8),
          Text(
            result.latin,
            style: theme.textTheme.bodySmall?.copyWith(
              fontStyle: FontStyle.italic,
              color: theme.colorScheme.onSurface.withAlpha(140),
            ),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (result.rootAr.isNotEmpty)
            Text(
              'Racine : ${result.rootAr}  (${result.rootLatin})',
              style: theme.textTheme.bodySmall?.copyWith(color: tokens.accent),
            ),
          Text(
            result.translation,
            style: theme.textTheme.bodyMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            result.pos,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(100),
            ),
          ),
          const SizedBox(width: 4),
          _AudioButton(clip: clip, tokens: tokens),
        ],
      ),
    );
  }
}

// ── Audio play button ─────────────────────────────────────────────────────────

/// A small icon button that plays/stops the given [clip].
///
/// - Disabled (greyed out) when [clip] is null (no audio configured yet).
/// - Shows a spinner while the audio is loading.
/// - Toggles between play and stop icons while the clip is playing.
/// - Reacts to [audioRepositoryProvider]'s playback stream to stay in sync
///   across all tiles (stopping one tile stops the indicator on another).
class _AudioButton extends ConsumerWidget {
  const _AudioButton({required this.clip, required this.tokens});

  final AudioClip? clip;
  final BayanTokens tokens;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // If no audio is available, show a disabled icon immediately.
    if (clip == null) {
      return IconButton(
        iconSize: 20,
        icon: Icon(
          Icons.volume_off_outlined,
          color: Theme.of(context).colorScheme.onSurface.withAlpha(60),
        ),
        onPressed: null, // disabled
        tooltip: 'Pas encore d\'audio',
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
          // Show a compact spinner while seeking/buffering inside the pack.
          return const SizedBox(
            width: 36,
            height: 36,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        final isPlaying =
            isThisClipActive && state == AudioPlaybackState.playing;

        return IconButton(
          iconSize: 20,
          icon: Icon(
            isPlaying ? Icons.stop_circle_outlined : Icons.play_circle_outline,
            color: tokens.accent,
          ),
          onPressed: () async {
            try {
              await repo.playClip(clip);
            } catch (_) {
              // Asset not yet available — swallow silently in dev.
            }
          },
          tooltip: isPlaying ? 'Arrêter' : 'Écouter la prononciation',
        );
      },
    );
  }
}
