# Offline Notes

Aplikasi Flutter kecil untuk mempraktikkan penyimpanan lokal dan pola offline-first.

## Tujuan

Menyimpan catatan dan preferensi pada perangkat agar catatan tetap dapat dibaca
dan diedit tanpa jaringan, serta mendemonstrasikan cache-first dan status
sinkronisasi tertunda.

## Fitur utama

- CRUD catatan persisten melalui SQLite (`sqflite`), dengan daftar `updated_at`
  terbaru lebih dahulu.
- Repository lokal dan state/action UI menggunakan Riverpod.
- Penanda dirty pada tulisan lokal, badge jumlah catatan tertunda, dan `syncNotes`.
- Daftar bacaan Posts membaca cache SQLite terlebih dahulu dan mencoba refresh
  jaringan; kegagalan refresh tidak menghapus cache.
- Toggle tema dan waktu terakhir dibuka disimpan melalui SharedPreferences.
- Toggle offline untuk mendemonstrasikan kegagalan sync secara deterministik.

## Stack teknologi

Flutter/Dart, `sqflite`, `path`, `shared_preferences`, `flutter_riverpod`,
`dio`, dan `go_router`.

## Menjalankan

Pastikan Flutter SDK tersedia, kemudian dari folder ini:

```shell
flutter pub get
flutter run
```

Jalankan pengujian dan analisis statis:

```shell
flutter test
flutter analyze
```

## Hasil yang dicapai

- Model catatan dapat diserialisasi ke SQLite termasuk timestamp dan dirty flag.
- Repository menyediakan create, read, update, delete, hitung dirty, dan
  penandaan sinkronisasi.
- Test mencakup model, provider dengan repository palsu, sinkronisasi, serta
  aturan konflik.
- Screenshot UI CRUD, tema, dan perubahan dirty sebelum/sesudah sync tersedia
  di [screenshots/](./screenshots/).
- Bukti daftar dalam mode pesawat: [dirty sebelum sync](./screenshots/p4-dirty-sebelum.png)
  dan [setelah sync simulasi](./screenshots/p4-dirty-setelah.png).

## Aturan konflik

Last-write-wins berdasarkan `updated_at`: timestamp lebih baru menang; jika sama,
versi lokal menang. Sinkronisasi catatan saat ini adalah **simulasi lokal**, bukan
integrasi endpoint server. Penjelasan rinci ada di
[docs/aturan-konflik.md](./docs/aturan-konflik.md).

## Temuan verifikasi AI

AI menyarankan pemisahan preferensi key-value dari catatan terstruktur. Implementasi
menggunakan SharedPreferences untuk preferensi dan sqflite (bukan Drift) untuk
catatan, karena kebutuhan CRUD SQL dan pengurutan dapat dipenuhi tanpa code
generation. Klaim stream real-time ditolak untuk sqflite; Riverpod di-invalidasi
setelah mutasi. Sinkronisasi server belum nyata dan didokumentasikan sebagai
simulasi. Lihat [docs/ai-prompt-log.md](./docs/ai-prompt-log.md) dan
[docs/perbandingan-storage.md](./docs/perbandingan-storage.md).
