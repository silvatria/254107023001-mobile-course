# Catatan AI Challenge

## Prompt

```text
Rancang penyimpanan untuk aplikasi Flutter Offline Notes dengan CRUD catatan,
preferensi tema, daftar bacaan cache-first, dan penulisan yang dapat ditunda
saat offline. Bandingkan SharedPreferences, Hive, sqflite/SQLite, dan Drift
berdasarkan pola data, dukungan query/relasi, reaktivitas, type-safety,
boilerplate, dan kemudahan testing. Berikan skema catatan dengan updated_at
dan dirty flag, serta rekomendasi penyimpanan untuk tiap kebutuhan.
```

## Ringkasan rekomendasi awal

Rekomendasi awal membedakan preferensi kecil dari kumpulan catatan: SharedPreferences
untuk tema dan SQLite untuk catatan. Drift disebut sebagai pilihan bila stream query
dan type-safety hasil generator dibutuhkan; sqflite tetap merupakan opsi yang lebih
langsung untuk CRUD SQL.

## Verifikasi terhadap implementasi

| Klaim/rekomendasi | Hasil verifikasi |
|---|---|
| SharedPreferences cocok menyimpan kumpulan catatan | Ditolak. Aplikasi hanya menyimpan `dark_mode` dan `last_opened_at` di sana. |
| Sqflite dapat mengurutkan catatan dan menyimpan status sync | Terverifikasi pada repository dan skema SQLite: daftar diurutkan dengan `updated_at DESC`, dan tiap catatan menyimpan `dirty`. |
| Sqflite menyediakan stream query otomatis | Tidak. UI memuat ulang provider Riverpod setelah aksi CRUD; tidak diklaim sebagai stream database real-time. |
| Sinkronisasi berarti data telah dikirim ke server sungguhan | Tidak untuk mini project ini. `syncNotes` adalah simulasi upload: saat online simulasi sukses, dirty ditandai bersih; ketika offline, operasi ditolak dan dirty dipertahankan. |
| Cache-first berarti daftar bacaan masih tersedia tanpa jaringan setelah pernah dimuat | Terverifikasi pada alur aplikasi: cache SQLite dibaca lebih dahulu, lalu penyegaran jaringan dilakukan; kegagalan refresh ditampilkan dan cache tidak diganti dengan hasil kosong. |

Keputusan akhir dan perbandingan lengkap ada di [perbandingan-storage.md](./perbandingan-storage.md).
