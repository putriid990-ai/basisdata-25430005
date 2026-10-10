# LAPORAN PRAKTIKUM BASIS DATA
## Implementasi Database Kopma Menggunakan MariaDB dan phpMyAdmin

### 1. Pendahuluan
Praktikum ini bertujuan untuk membuat database Kopma menggunakan MariaDB melalui phpMyAdmin. Database dirancang untuk mengelola data petugas, anggota, pemasok, barang, penjualan, dan pembelian beserta detail transaksinya.

### 2. Tujuan Praktikum
1. Membuat database dan tabel sesuai rancangan ERD Kopma.
2. Menerapkan Primary Key, Foreign Key, serta constraint pada tabel.
3. Memahami hubungan antar tabel dalam sebuah database relasional.
4. Menyimpan file SQL dan dokumentasi praktikum ke GitHub.

### 3. Alat dan Bahan
- Sistem operasi Windows.
- XAMPP dan MariaDB.
- phpMyAdmin.
- Git dan GitHub.
- Bahasa SQL (Structured Query Language).

### 4. Langkah Kerja
1. Menjalankan layanan MySQL pada XAMPP.
2. Membuka phpMyAdmin melalui browser.
3. Membuat database dengan nama `kopma`.
4. Membuat delapan tabel, yaitu `petugas`, `anggota`, `pemasok`, `barang`, `penjualan`, `detail_penjualan`, `pembelian`, dan `detail_pembelian`.
5. Menentukan tipe data, Primary Key, Foreign Key, dan constraint sesuai rancangan tabel.
6. Memeriksa struktur tabel melalui menu Struktur di phpMyAdmin.
7. Menyimpan skrip SQL dan dokumentasi ke repository GitHub.

### 5. Hasil Praktikum
Database `kopma` berhasil dibuat dengan delapan tabel. Setiap tabel memiliki struktur kolom dan tipe data yang telah ditentukan. Primary Key digunakan untuk mengidentifikasi data, sedangkan Foreign Key menghubungkan tabel transaksi dengan tabel terkait.

**Tabel yang dibuat:**
1. `petugas`
2. `anggota`
3. `pemasok`
4. `barang`
5. `penjualan`
6. `detail_penjualan`
7. `pembelian`
8. `detail_pembelian`

Berdasarkan pemeriksaan pada phpMyAdmin, kedelapan tabel telah berhasil dibuat. Pada saat pemeriksaan, seluruh tabel masih memiliki nol baris data.

### 6. Kesimpulan
Praktikum ini memberikan pemahaman mengenai pembuatan database relasional menggunakan MariaDB dan phpMyAdmin. Database Kopma berhasil dibuat dengan delapan tabel sebagai dasar pengelolaan data anggota, petugas, barang, serta transaksi penjualan dan pembelian. Dokumentasi dan skrip SQL selanjutnya disimpan ke GitHub sebagai arsip hasil praktikum.

### 7. Dokumentasi
Lampirkan tangkapan layar berikut:
- Tampilan database `kopma` yang menunjukkan delapan tabel.
- Struktur kolom salah satu tabel, misalnya `petugas`.
- Tampilan relasi antar tabel jika sudah diperiksa melalui menu Desainer.

