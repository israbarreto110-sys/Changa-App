import 'package:flutter/material.dart';
import 'mapa_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Changa App',
      home: MapaPage(), // <-- Acá le decimos que arranque con el mapa
    );
  }
}
