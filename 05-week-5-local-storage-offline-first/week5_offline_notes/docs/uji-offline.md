# Laporan Pengujian Fitur Offline-First & Sinkronisasi

Dokumen ini berisi langkah-langkah pengujian serta hasil observasi dari implementasi mekanisme *offline-first*, pengelolaan cache data, sinkronisasi, dan indikator status *dirty* pada aplikasi.

---

## 1. Langkah-Langkah Pengujian

### A. Pengujian Indikator Badge Data Belum Disinkronkan (*Dirty Count*)
1. Pastikan perangkat atau emulator terhubung dengan database lokal (SQLite).
2. Lakukan penambahan atau perubahan data catatan (*mutation*) secara lokal tanpa melakukan sinkronisasi ke server (atau dalam kondisi jaringan diputus).
3. Amati perubahan pada indikator badge jumlah data kotor/belum tersinkron (`dirtyCountProvider`).
4. Ambil tangkapan layar kondisi badge sebelum sinkron dan simpan sebagai:
   `screenshots/p4-dirty-sebelum.png`
5. Jalankan proses sinkronisasi data ke server/remote.
6. Amati kembali perubahan badge setelah proses sinkronisasi selesai (jumlah badge seharusnya kembali menjadi 0 atau berkurang).
7. Ambil tangkapan layar kondisi badge sesudah sinkron dan simpan sebagai:
   `screenshots/p4-dirty-sesudah.png`

### B. Pengujian Halaman Posts dalam Mode Offline
1. Putuskan koneksi internet perangkat (aktifkan Mode Pesawat / *Airplane Mode* pada emulator atau perangkat fisik).
2. Buka halaman daftar Post (*PostsPage*) yang menerapkan pola *cache-first*.
3. Amati apakah data tetap berhasil dimuat seketika dari penyimpanan lokal (*cache* SQLite) meskipun koneksi internet terputus.
4. Ambil tangkapan layar halaman saat berjalan dalam mode offline dan simpan sebagai:
   `screenshots/p4-posts-offline.png`

---

## 2. Hasil Observasi

* **Badge Sebelum Sinkron (`p4-dirty-sebelum.png`)**: 
  Indikator badge menunjukkan angka yang sesuai dengan jumlah catatan baru atau yang dimodifikasi secara lokal (`dirty = 1`). Hal ini membuktikan bahwa sistem pencatatan status *dirty* berjalan dengan baik pada tingkat basis data lokal.
* **Badge Sesudah Sinkron (`p4-dirty-sesudah.png`)**: 
  Setelah proses sinkronisasi dipicu, nilai *dirty* pada database diperbarui dan jumlah pada badge kembali kosong atau `0`. Ini mengonfirmasi bahwa data lokal berhasil diunggah dan diselaraskan dengan server.
* **Halaman Posts Offline (`p4-posts-offline.png`)**: 
  Meskipun koneksi internet dimatikan total, daftar pos tetap tampil secara instan berkat mekanisme *cache-first* yang membaca langsung dari SQLite. Banner peringatan mode offline juga muncul dengan baik untuk memberikan informasi visual kepada pengguna tanpa mengganggu fungsionalitas utama aplikasi.