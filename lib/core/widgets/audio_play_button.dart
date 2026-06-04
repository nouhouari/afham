import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bayan/core/i18n/strings.g.dart';
import 'package:bayan/core/theme/app_tokens.dart';
import 'package:bayan/data/audio/audio_clip.dart';
import 'package:bayan/data/audio/audio_repository.dart';

/// Shared audio play/stop control for a single [AudioClip].
///
/// One widget for every surface (detail sheet, result cards, family tiles):
/// reflects the [AudioRepository] playback state, toggles play/stop for *this*
/// clip, and always exposes a tap target ≥ 44 pt (accessibility), regardless of
/// the visual [iconSize]. When [clip] is null it renders a muted, non-interactive
/// "no audio" glyph occupying the same footprint so rows don't shift.
///
/// - [iconSize]: visual icon size (e.g. 28 for the hero header, 22 for tiles).
/// - [filled]: filled play/stop glyphs (hero) vs outlined (compact tiles).
class AudioPlayButton extends ConsumerWidget {
  const AudioPlayButton({
    super.key,
    required this.clip,
    this.iconSize = 22,
    this.filled = false,
  });

  final AudioClip? clip;
  final double iconSize;
  final bool filled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = Theme.of(context).extension<BayanTokens>()!;
    final strings = Translations.of(context);
    // Minimum 44 pt tap target even when the glyph is small.
    final double box = iconSize >= 26 ? 48 : 44;

    if (clip == null) {
      return SizedBox(
        width: box,
        height: box,
        child: Tooltip(
          message: strings.word.noAudio,
          child: Icon(
            Icons.volume_off_outlined,
            size: iconSize < 22 ? iconSize : 20,
            color: Theme.of(context).colorScheme.onSurface.withAlpha(60),
          ),
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
            width: box,
            height: box,
            child: Center(
              child: SizedBox(
                width: iconSize,
                height: iconSize,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: tokens.accent,
                ),
              ),
            ),
          );
        }

        final isPlaying =
            isThisClipActive && state == AudioPlaybackState.playing;

        return IconButton(
          iconSize: iconSize,
          padding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
          constraints: BoxConstraints(minWidth: box, minHeight: box),
          tooltip: isPlaying ? strings.word.stopAudio : strings.word.playAudio,
          icon: Icon(
            isPlaying
                ? (filled
                      ? Icons.stop_circle_rounded
                      : Icons.stop_circle_outlined)
                : (filled
                      ? Icons.play_circle_filled_rounded
                      : Icons.play_circle_outline_rounded),
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
