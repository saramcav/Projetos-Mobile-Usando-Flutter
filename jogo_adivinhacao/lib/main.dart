import 'package:adivinhacao2/primeira_tela.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Jogo de Adivinhação",
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const PrimeiraTela(),
    );
  }
}
