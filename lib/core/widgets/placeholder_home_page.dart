import 'package:flutter/material.dart';

/// Proves the app shell (DI + router + theme) compiles and renders.
/// Replaced by the real discover/home screen in a future pass.
class PlaceholderHomePage extends StatelessWidget {
  const PlaceholderHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'CineTrack — setup complete',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
