import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'pages/Home.dart';

void main() {
  runApp(const MaterialApp(
    title:  "Lista de Tarefas",
    debugShowCheckedModeBanner: false,
    //definindo idioma para o calendario
    localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
    supportedLocales: const [Locale('pt', 'BR')],
    home: Home(),
  ));
}
