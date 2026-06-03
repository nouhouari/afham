import 'package:flutter/material.dart';

/// Placeholder for the Search / Home screen.
/// Phase 2 will replace this with the real FTS5-backed search implementation.
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bayan')),
      body: const Center(child: Text('Search screen — Phase 2')),
    );
  }
}
