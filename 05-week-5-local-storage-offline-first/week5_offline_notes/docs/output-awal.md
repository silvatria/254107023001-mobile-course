Untuk aplikasi Offline Notes dengan CRUD catatan dan preferensi tema, saya merekomendasikan SharedPreferences untuk tema dan Drift/SQLite untuk catatan. Drift paling cocok jika Anda menginginkan query terstruktur, hasil yang reaktif, dan API bertipe; sqflite adalah alternatif lebih ringan jika bersedia menulis SQL dan mengelola pembaruan UI sendiri.

Pilihan	Kompleksitas query	Relasi	Reaktivitas (stream)	Type-safety	Boilerplate	Kemudahan testing	Rekomendasi untuk aplikasi
SharedPreferences	Sangat terbatas; cocok untuk membaca/menulis nilai sederhana	Tidak cocok	Tidak dirancang untuk stream perubahan data	Rendah; nilai diakses berdasarkan key dan tipe dasar	Rendah	Mudah untuk tes sederhana, tetapi sebaiknya akses dibungkus agar dapat diinjeksi	Preferensi tema: simpan nilai kecil seperti light, dark, atau system
Hive	Rendah–menengah; cocok untuk mengambil dan menyimpan objek, bukan query relasional kompleks	Terbatas; relasi perlu dikelola sendiri	Ada mekanisme pemantauan perubahan box	Menengah; bergantung pada model/adapter yang digunakan	Rendah–menengah	Cukup mudah, tetapi tes perlu menyiapkan dan membersihkan box	Bisa untuk catatan sederhana, tetapi kurang ideal jika kebutuhan query, pencarian, atau relasi berkembang
sqflite (SQLite)	Tinggi; SQL mendukung filter, pengurutan, agregasi, dan pagination	Ya	Bukan stream reaktif bawaan untuk query; perlu memicu pembaruan UI setelah operasi	Rendah–menengah; SQL dan pemetaan hasil biasanya manual	Menengah	Baik dengan database sementara dan lapisan repository	Alternatif untuk catatan jika ingin SQLite dan nyaman mengelola SQL serta pembaruan UI sendiri
Drift (SQLite)	Tinggi; query SQL dan API query Drift	Ya	Ya; query dapat mengeluarkan stream saat data terkait berubah	Tinggi pada API hasil generasi kode dan skema	Menengah–tinggi; ada definisi tabel dan kode generasi	Baik; mendukung pola database sementara dan repository	Catatan: cocok untuk CRUD terstruktur, daftar reaktif, dan kemungkinan fitur query yang bertambah
Skema untuk 1000+ catatan
Seribu catatan masih tergolong ringan untuk SQLite. Jumlah itu sendiri tidak mengharuskan migrasi atau pembagian data; gunakan indeks untuk pola query yang sering dipakai dan pagination agar daftar tidak perlu memuat semuanya sekaligus.


Contoh SQL SQLite:


Simpan timestamp sebagai epoch integer, misalnya dalam milidetik UTC, dengan konvensi yang konsisten. Untuk mengambil daftar secara bertahap:


Jika kelak catatan memiliki tag, model relasinya dapat ditambahkan tanpa menaruh daftar tag sebagai teks dalam satu kolom:


Trade-off utama
SharedPreferences: paling sederhana untuk satu preferensi tema. Jangan menjadikannya penyimpanan utama catatan: ia berorientasi pada pasangan key–value, bukan query dan pengelolaan kumpulan data.
Hive: praktis saat data berbentuk objek dan kebutuhan query sederhana. Trade-off-nya, filter, pengurutan, dan relasi yang makin kaya cenderung perlu ditangani lebih manual dibandingkan SQL.
sqflite: memberi kontrol langsung atas SQLite dan menghindari lapisan generasi kode Drift. Sebagai gantinya, penulisan query, konversi baris ke model, serta notifikasi perubahan untuk memperbarui UI menjadi tanggung jawab aplikasi.
Drift: menambah definisi skema dan proses code generation, tetapi mengurangi pemetaan manual, menyediakan API yang lebih bertipe, dan memudahkan UI berlangganan hasil query. Untuk catatan dengan CRUD dan daftar yang perlu langsung mencerminkan perubahan, trade-off tersebut biasanya sepadan.
Kesimpulan: simpan pilihan tema sebagai satu nilai kecil di SharedPreferences; simpan catatan di Drift/SQLite. Jika kebutuhan catatan dipastikan sangat sederhana dan Anda ingin lebih sedikit abstraksi, sqflite juga pilihan yang wajar.