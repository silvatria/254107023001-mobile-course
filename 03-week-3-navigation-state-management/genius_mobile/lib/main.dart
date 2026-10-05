import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'Beranda.dart';
import 'Lyrics.dart';

void main() {
  // 1. Jalankan widget utama aplikasi Anda (bukan GoRouter-nya langsung)
  runApp(const MyApp()); 
}

// 2. Konfigurasi router dipisah di luar widget
final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => Lyrics(), // Tambahkan const jika Beranda mendukung const
    ),
  ], // <-- Sebelumnya kurang kurung siku penutup list
); // <-- Sebelumnya kurang kurung penutup objek GoRouter

// 3. Buat widget utama aplikasi menggunakan MaterialApp.router
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Aplikasi Saya',
      routerConfig: _router, // <-- Daftarkan variabel _router Anda di sini
    );
  }
}
