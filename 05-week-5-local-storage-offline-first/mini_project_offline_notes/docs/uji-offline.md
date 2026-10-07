# Verifikasi Offline dan Sinkronisasi

## Bukti tangkapan layar

- [Daftar catatan offline + dirty sebelum sync](../screenshots/p4-dirty-sebelum.png): tiga catatan berstatus belum tersinkron; indikator mode pesawat tampak pada status bar.
- [Daftar catatan setelah sync simulasi](../screenshots/p4-dirty-setelah.png): badge dirty hilang dan catatan ditampilkan bersih.
- [Tema gelap](../screenshots/p1-tema-gelap.png) dan [tema terang](../screenshots/p1-tema-terang.png).
- [Tambah](../screenshots/p3-mode-pesawat/create.png), [ubah](../screenshots/p3-mode-pesawat/update.png), dan [hapus](../screenshots/p3-mode-pesawat/delete.png) catatan.

## Langkah verifikasi ulang

1. Jalankan aplikasi, tambah atau ubah catatan, lalu pastikan ikon cloud-off dan
   badge menampilkan jumlah dirty.
2. Aktifkan toggle **Paksa mode offline** pada Pengaturan. Tekan sinkronkan;
   operasi ditolak dan dirty tetap ada.
3. Nonaktifkan toggle offline dan tekan sinkronkan. Demo upload menandai catatan
   bersih dan badge hilang.
4. Buka Posts saat terhubung agar data cache tersimpan di SQLite. Aktifkan mode
   offline lalu buka ulang Posts; cache tetap tampil. Bila refresh jaringan gagal,
   pesan kegagalan ditampilkan tanpa menghapus cache.

Sinkronisasi catatan di mini project ini adalah simulasi lokal, bukan klaim bahwa
server menerima data. Toggle offline dibuat deterministik agar skenario bisa dites
tanpa bergantung pada konektivitas emulator. Gambar yang tersedia adalah bukti
tangkapan layar yang disediakan bersama project referensi; tidak ada screenshot
baru yang direkayasa atau dibuat dari mockup.
