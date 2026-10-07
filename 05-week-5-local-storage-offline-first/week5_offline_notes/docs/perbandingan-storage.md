# Lembar Kerja: Perbandingan Storage

Berikut adalah hasil perbandingan antara SharedPreferences, Hive, sqflite, dan Drift:

## 1. SharedPreferences
* **Kompleksitas Query**: Sangat Terbatas (hanya key-value sederhana).
* **Dukungan Relasi**: Tidak Ada.
* **Reaktivitas (Stream)**: Tidak Ada (perlu listener manual).
* **Type-Safety**: Rendah (butuh casting tipe data manual).
* **Ukuran Boilerplate**: Sangat Minimal (sedikit baris kode).
* **Kemudahan Testing**: Sangat Mudah.
* **Cocok untuk Preferensi?**: **Sangat Cocok** (ringan untuk konfigurasi kecil/tema).
* **Cocok untuk 1000+ Catatan?**: Tidak Cocok (rapuh, membaca/menulis seluruh file sekaligus).
* **Keputusan & Alasan**: **Dipilih** karena ringan dan cepat untuk data konfigurasi/tema.

## 2. Hive
* **Kompleksitas Query**: Rendah–Menengah (mengambil objek langsung dari box).
* **Dukungan Relasi**: Tidak Ada (relasi dikelola manual).
* **Reaktivitas (Stream)**: Ada (fitur watch box untuk pantau data).
* **Type-Safety**: Menengah (butuh TypeAdapter / code generation).
* **Ukuran Boilerplate**: Sedang.
* **Kemudahan Testing**: Cukup Mudah.
* **Cocok untuk Preferensi?**: Kurang Ideal.
* **Cocok untuk 1000+ Catatan?**: Cukup Cocok (cukup cepat untuk data skala menengah).
* **Keputusan & Alasan**: **Ditolak** karena digantikan opsi yang lebih mumpuni.

## 3. sqflite (SQLite)
* **Kompleksitas Query**: Tinggi (mendukung kueri SQL mentah: WHERE, JOIN, dll).
* **Dukungan Relasi**: Mendukung Penuh (Foreign Key dan relasi tabel).
* **Reaktivitas (Stream)**: Terbatas (butuh integrasi manual dengan Stream).
* **Type-Safety**: Rendah (raw query string rawan salah ketik saat runtime).
* **Ukuran Boilerplate**: Tinggi (banyak kode mapping model dan SQL manual).
* **Kemudahan Testing**: Baik (mendukung database memori sementara).
* **Cocok untuk Preferensi?**: Tidak Cocok.
* **Cocok untuk 1000+ Catatan?**: Cocok (handal untuk data skala besar dengan indeks SQL).
* **Keputusan & Alasan**: **Alternatif** yang baik jika ingin kendali penuh SQL mentah.

## 4. Drift (SQLite)
* **Kompleksitas Query**: Tinggi (kueri SQL kompleks, aman secara tipe, API kaya).
* **Dukungan Relasi**: Mendukung Penuh (pemodelan relasi terstruktur dan aman).
* **Reaktivitas (Stream)**: Sangat Baik (dukungan Stream bawaan via .watch()).
* **Type-Safety**: Tinggi (tipe diperiksa compiler Dart lewat code generation).
* **Ukuran Boilerplate**: Menengah–Tinggi (butuh konfigurasi awal build_runner).
* **Kemudahan Testing**: Sangat Baik (mendukung in-memory database & testing bersih).
* **Cocok untuk Preferensi?**: Tidak Cocok.
* **Cocok untuk 1000+ Catatan?**: **Sangat Cocok** (optimal untuk ribuan catatan, indeks, & reaktif).
* **Keputusan & Alasan**: **Dipilih** karena menyediakan type-safety, stream reaktif, & offline-first yang handal.