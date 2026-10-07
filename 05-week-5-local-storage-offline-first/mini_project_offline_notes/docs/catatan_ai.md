# Catatan Praktikum

## Struktur singkat

- `data/local`: skema sqflite dan model serialisasi catatan.
- `data/repositories`: abstraksi repository serta implementasi SQLite untuk CRUD.
- `providers`: injeksi repository, status Riverpod, aksi catatan, dan cache-first.
- `pages` dan `widgets`: UI catatan, preferensi, serta daftar bacaan.

## Hasil dan batasan

CRUD catatan tersimpan di SQLite, diperbarui lewat repository, dan daftar terbaru
muncul lebih dahulu. Preferensi tema dan timestamp pembukaan terakhir disimpan
melalui SharedPreferences. Daftar post menggunakan cache lokal sebelum mencoba
refresh jaringan.

Upload catatan masih berupa simulasi; aturan merge last-write-wins didefinisikan
dan diuji terpisah. Detail verifikasi AI tercatat pada
[ai-prompt-log.md](./ai-prompt-log.md), aturan konflik pada
[aturan-konflik.md](./aturan-konflik.md), dan bukti offline pada
[uji-offline.md](./uji-offline.md).
