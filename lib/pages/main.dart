import 'package:calendar/pages/login.dart';
import 'package:calendar/pages/register.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Register(),
      routes: {
        '/login': (context) => Login(),
        '/register': (context) => const Register()
      },
    );
  }
}
