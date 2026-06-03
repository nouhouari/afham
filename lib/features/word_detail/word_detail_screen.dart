import 'package:flutter/material.dart';

/// Placeholder for the Word Detail bottom-sheet screen.
/// Phase 2 will replace this with the real fiche (6 blocks + audio).
class WordDetailScreen extends StatelessWidget {
  const WordDetailScreen({super.key, required this.lemmaId});

  final int lemmaId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Word Detail')),
      body: Center(child: Text('Lemma #$lemmaId — Phase 2')),
    );
  }
}
