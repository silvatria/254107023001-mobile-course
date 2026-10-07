# Perbandingan Storage dan Keputusan

| Pilihan | Pola data dan query | Reaktivitas | Type-safety | Boilerplate/testing | Keputusan |
|---|---|---|---|---|---|
| SharedPreferences | Key-value sederhana; tidak cocok untuk daftar catatan atau relasi | Tidak menyediakan stream perubahan | Nilai terbatas pada tipe primitif | Paling sederhana; dapat dibungkus repository | Dipakai hanya untuk tema dan waktu terakhir dibuka |
| Hive | Penyimpanan objek; filter dan relasi lebih banyak dikelola aplikasi | Mendukung pemantauan box | Bergantung pada adapter/model | Setup sedang; tes perlu box sementara | Tidak dipilih karena kebutuhan ini meminta SQL dan pengurutan terstruktur |
| sqflite / SQLite | SQL untuk CRUD, filter, urut, transaksi, dan indeks | Tidak otomatis; Riverpod di-invalidasi setelah mutasi | Mapping baris ditangani model/repository | Query manual, tetapi mudah diuji melalui repository palsu | Dipilih untuk catatan, sesuai kebutuhan praktikum |
| Drift / SQLite | Query SQL dan API query yang lebih deklaratif | Query dapat dipantau sebagai stream | Tinggi melalui kode hasil generator | Perlu generator dan konfigurasi tambahan | Alternatif baik bila API reaktif/type-safe sepadan dengan tambahan setup |

## Keputusan final

- **SharedPreferences** menyimpan `dark_mode` dan `last_opened_at`, yaitu nilai preferensi kecil.
- **sqflite** menyimpan catatan dan cache data bacaan. `notes` mempunyai `updated_at` dan `dirty`; query daftar memakai `ORDER BY updated_at DESC, id DESC`.
- **Riverpod** menyediakan repository dan state UI. Setelah perubahan catatan, provider daftar, detail, dan hitungan dirty dibaca ulang.
- **Drift** tidak dipakai. Aplikasi belum memerlukan relasi rumit atau stream query bawaan; sqflite membuat skema dan alur CRUD yang diwajibkan lebih langsung serta menghindari code generation.

Seribu catatan masih wajar untuk SQLite. Bila dataset membesar, indeks pada kolom pengurutan dan pagination dapat ditambahkan berdasarkan kebutuhan pengukuran, bukan hanya perkiraan jumlah data.
