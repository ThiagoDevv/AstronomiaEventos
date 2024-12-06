import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/auth_screen.dart'; // Certifique-se de que o caminho está correto

void main() {
  runApp(AstronomyApp());
}

class AstronomyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eventos Astronômicos',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AuthScreen(), // Tela inicial é a tela de login
    );
  }
}
