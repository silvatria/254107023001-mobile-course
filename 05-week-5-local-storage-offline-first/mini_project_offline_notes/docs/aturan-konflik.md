# Aturan Konflik Sinkronisasi

Aturan untuk dua versi catatan dengan identitas yang sama adalah **last-write-wins**
berdasarkan `updated_at` (UTC ISO-8601):

1. Versi dengan `updated_at` lebih baru dipertahankan.
2. Jika timestamp sama, versi lokal dipertahankan agar data lokal tidak tertimpa
   secara nondeterministik.
3. `resolveConflict` mengimplementasikan aturan ini dan dites untuk kedua urutan
   argumen.
4. Perubahan lokal ditandai `dirty = 1`. Sinkronisasi saat offline ditolak dan
   tidak menghapus flag tersebut.

**Batas implementasi:** mini project belum memiliki endpoint sinkronisasi catatan.
`syncNotes` mensimulasikan upload yang berhasil, lalu menandai catatan dirty bersih.
Karena belum ada respons server per catatan, `resolveConflict` adalah aturan merge
yang siap dipakai adapter server mendatang dan belum melakukan pertukaran konflik
nyata. Penghapusan juga belum memakai tombstone untuk replikasi.
