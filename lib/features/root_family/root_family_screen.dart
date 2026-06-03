import 'package:flutter/material.dart';

/// Placeholder for the Root Family screen.
/// Phase 2 will replace this with the actual lemma-by-root list.
class RootFamilyScreen extends StatelessWidget {
  const RootFamilyScreen({super.key, required this.rootId});

  final int rootId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Root Family')),
      body: Center(child: Text('Root #$rootId — Phase 2')),
    );
  }
}
