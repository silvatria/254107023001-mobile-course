# Laporan Praktikum Minggu 5: Offline-First & Local Storage (Flutter)

Laporan ini mendokumentasikan proses pengembangan dan perbaikan fungsionalitas aplikasi **Offline Notes** yang mengintegrasikan penyimpanan lokal berbasis `Sqflite`, manajemen state dengan `Flutter Riverpod`, navigasi menggunakan `GoRouter`, serta mekanisme sinkronisasi data (*offline-first*).

---

## 1. Arsitektur & Komponen Utama

### A. Model Data (`Note`)
- Menggunakan properti utama `title`, `body` (sebagai isi catatan), `updatedAt`, dan *flag* `dirty` untuk menandai status sinkronisasi data lokal ke server/remote.
- Dilengkapi fungsi serialisasi `fromMap` dan `toMap`, serta aman terhadap field yang kosong.

### B. Repository & Local Storage (`NoteRepository`)
- Mengelola operasi CRUD dasar pada database Sqflite (`fetchNotes`, `getNoteById`, `addNote`, `updateNote`, `deleteNote`).
- Menyediakan fungsi pendukung untuk menghitung jumlah data yang belum tersinkron (`countDirty`) dan memperbarui status sinkronisasi (`markAllSynced`).

### C. Manajemen State & Provider (`Riverpod`)
- Menerapkan `noteRepositoryProvider` dan `noteByIdProvider` untuk menyediakan data catatan secara reaktif ke UI.
- Menggunakan `AsyncValue` untuk menangani status *loading*, *data*, dan *error* pada tampilan daftar maupun detail catatan.

---

## 2. Pengerjaan & Perbaikan Fungsionalitas (Troubleshooting)

1. **Konfigurasi Routing (`GoRouter`)**:
   - Memigrasikan `MaterialApp` standar menjadi `MaterialApp.router` dengan konfigurasi `GoRouter` untuk mendukung *nested routing* pada halaman detail catatan (`/note/:id`).
2. **Sinkronisasi Model UI**:
   - Menyelaraskan penggunaan properti `note.body` pada `NoteDetailPage`, `NotesPage`, dan `NoteTile` agar konsisten dengan definisi model `Note`.
3. **Penyelesaian Konflik Impor (*Ambiguous Import*)**:
   - Memperbaiki konflik penamaan provider pada file *test* (`test/note_test.dart`) dengan menyembunyikan duplikasi deklarasi (*hiding*) sehingga pengujian unit test dan provider berjalan sukses (*passed*).

---

## 3. Pengujian (*Testing*)
- **Model Test**: Memastikan fungsi pemetaan data (`fromMap`) berjalan aman dan serialisasi status *dirty* tetap konsisten.
- **Provider Test**: Menguji `notesProvider` menggunakan mock/fake repository (`FakeNoteRepository`) untuk skenario sukses maupun penanganan galat (*error handling*).
- **Offline-First Sync Test**: Menguji fungsi `syncNotes` dan resolusi konflik berdasarkan waktu pembaruan (`updatedAt` terbaru).