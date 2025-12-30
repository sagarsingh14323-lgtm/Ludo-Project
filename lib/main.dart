import 'package:flutter/material.dart';

void main() {
  runApp(const LudoApp());
}

class LudoApp extends StatelessWidget {
  const LudoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ludo App',
      home: const LudoBoardScreen(),
    );
  }
}

class LudoBoardScreen extends StatelessWidget {
  const LudoBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ludo App'),
        centerTitle: true,
      ),
      body: Center(
        child: Image.asset(
          'assets/images/ludo_board.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
