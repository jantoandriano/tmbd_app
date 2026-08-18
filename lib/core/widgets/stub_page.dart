import 'package:flutter/material.dart';

/// Generic placeholder for screens not yet built (profile, assistant,
/// notifications). Proves routing from the discover app bar.
class StubPage extends StatelessWidget {
  const StubPage({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title coming soon')),
    );
  }
}
