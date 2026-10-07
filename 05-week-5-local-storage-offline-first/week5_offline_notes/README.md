AI Verification Checklist
Sebelum rekomendasi AI diterima, verifikasi dan catat temuan Anda di README:
•	Apakah AI menempatkan daftar catatan di SharedPreferences? (Tolak: rapuh untuk koleksi.)
Jawab : Tidak. AI dengan tepat menempatkan SharedPreferences khusus untuk preferensi tema/pengaturan key-value sederhana, sedangkan daftar catatan ditempatkan di Drift / sqflite. (Sesuai, menolak SharedPreferences untuk koleksi karena rapuh).
•	Apakah skema AI mendukung antrean sync (dirty flag / updated_at) atau hanya CRUD polos?
Jawab : Jika merujuk pada implementasi modul offline-first minggu ini, skema tabel membutuhkan tambahan kolom penanda seperti is_synced (dirty flag) dan updated_at untuk menangani sinkronisasi antrean data secara lokal sebelum dikirim ke server.
•	Apakah klaim “real-time” AI didukung stream (Drift watch) atau hanya asumsi?
Jawab : Didukung secara nyata. Drift menyediakan fitur native watch() berbasis Stream Dart yang otomatis memancarkan ulang data saat terjadi perubahan pada tabel database lokal.
•	Apakah estimasi boilerplate AI masuk akal setelah Anda mencoba instalasinya (flutter pub add + migrasi skema)?
Jawab : Masuk akal. Drift memang membutuhkan boilerplate awal berupa konfigurasi build_runner dan file generator, namun terbayar dengan kemudahan type-safety saat kueri data berjalan.
•	Keputusan final Anda beserta alasannya — boleh berbeda dari rekomendasi AI selama berargumen.
Jawab :
•	Menggunakan SharedPreferences untuk preferensi tema karena sangat ringan, cepat, dan sesuai untuk data konfigurasi sederhana.
•	Menggunakan Drift / sqflite untuk pengelolaan catatan karena mendukung struktur relasional, kueri kompleks untuk ribuan data, serta mekanisme offline-first yang handal.