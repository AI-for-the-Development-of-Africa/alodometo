import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("W E L C O M E", style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 20)),
      ),
    );
  }
}