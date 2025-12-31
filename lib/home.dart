import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ludo App")),
      body: Center(
        child: Image.asset(
          'assets/images/ludo_board.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
