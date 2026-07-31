import 'package:flutter/material.dart';
import 'screens/invoice_form.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GST Invoice Engine',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xff162642),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff162642),
          primary: const Color(0xff162642),
          secondary: const Color(0xffd4af37),
          surface: Colors.white,
          scaffoldBackgroundColor: const Color(0xfff8f9fa),
        ),
        cardTheme: const CardTheme(
          color: Colors.white,
          elevation: 1,
        ),
      ),
      home: const InvoiceFormScreen(),
    );
  }
}
