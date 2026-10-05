import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'Beranda.dart';
import 'Lyrics.dart';

void main() {
  runApp(const MyApp());
}

// Konfigurasi GoRouter untuk navigasi antar halaman
final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Beranda(), // Halaman utama YouTube Music
    ),
    GoRoute(
      path: '/lyrics',
      builder: (context, state) => const Lyrics(), // Halaman pemutar / lirik lagu
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'YouTube Music Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.red,
          surface: Colors.black,
        ),
      ),
      routerConfig: _router,
    );
  }
}