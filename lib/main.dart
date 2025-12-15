import 'package:flutter/material.dart';
import 'screens/home_shell.dart';

void main() {
  runApp(const KeuanganApp());
}

class KeuanganApp extends StatelessWidget {
  const KeuanganApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Keuangan Pribadi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const HomeShell(),
    );
  }
}
