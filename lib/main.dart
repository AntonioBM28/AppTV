import 'package:flutter/material.dart';
import 'package:smart_app/screens/home_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mis Peliculas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: HomeScreen()
    );
  }
}
//flutter pub upgrade