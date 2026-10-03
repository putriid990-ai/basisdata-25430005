# Analisis Kebutuhan Data Koperasi Mahasiswa (Kopma)

## Identitas

* Nama: Putri Nur Rahma Dewi
* NIM: 25430005
* Kelas: A
* Mata Kuliah: Basis Data
* Semester: 3

---

# 1. Deskripsi Singkat

Koperasi Mahasiswa (Kopma) merupakan contoh organisasi yang digunakan untuk menganalisis kebutuhan data dan proses bisnis. Analisis dilakukan berdasarkan kegiatan pendaftaran anggota, penjualan, pengadaan barang dari pemasok, penerimaan barang, serta penyusunan laporan bulanan.

Tujuan analisis adalah menentukan data yang dibutuhkan, aturan bisnis, kebutuhan informasi, serta operasi CRUD yang menjadi dasar perancangan database.

---

# 2. Proses Bisnis dan Aktor

| Kode  | Proses Bisnis                | Aktor          | Pemicu                                                  |
| ----- | ---------------------------- | -------------- | ------------------------------------------------------- |
| PB-01 | Mendaftarkan anggota         | Kasir          | Mahasiswa ingin menjadi anggota                         |
| PB-02 | Mencatat penjualan           | Kasir          | Pembeli membayar di kasir                               |
| PB-03 | Memesan barang ke pemasok    | Petugas gudang | Stok di bawah batas minimum                             |
| PB-04 | Menerima barang dari pemasok | Petugas gudang | Barang datang bersama faktur                            |
| PB-05 | Menyusun laporan bulanan     | Ketua koperasi | Awal bulan                                              |
| PB-06 | Mengelola data pemasok       | Ketua koperasi | Pemasok baru perlu dicatat atau data pemasok diperbarui |

---

# 3. Analisis Data Transaksi

Data yang perlu disimpan dalam proses penjualan meliputi:

### Penjualan

* Nomor nota
* Tanggal dan waktu
* Kasir
* Anggota jika ada
* Metode pembayaran
* Jumlah pembayaran

### Detail Penjualan

* Nomor nota
* Kode barang
* Nama barang
* Jumlah barang
* Harga saat transaksi

### Barang

* Kode barang
* Nama barang
* Kategori
* Harga jual
* Stok
* Batas minimum stok

### Data Turunan

Beberapa nilai dapat dihitung dari data dasar:

* Subtotal = jumlah barang × harga saat transaksi
* Diskon = persentase diskon × subtotal
* Total = jumlah seluruh subtotal − diskon

---

# 4. Analisis dan Temuan

## TA-01 — Harga Saat Transaksi

Harga saat transaksi perlu disimpan karena harga barang dapat berubah di kemudian hari. Jika sistem hanya mengambil harga terbaru dari data barang, nota lama dapat menunjukkan harga yang berbeda dari harga sebenarnya ketika transaksi dilakukan.

Dengan menyimpan harga saat transaksi pada detail penjualan, riwayat transaksi tetap menunjukkan harga yang benar pada saat pembelian.

## TA-02 — Subtotal dan Total

Subtotal merupakan nilai turunan yang dapat dihitung dari jumlah barang dan harga saat transaksi. Menyimpannya dapat menyebabkan ketidakkonsistenan apabila data dasarnya berubah.

Total juga dapat dihitung dari subtotal dan diskon. Namun, total transaksi dapat disimpan sebagai nilai yang tercatat pada saat transaksi untuk memudahkan pemeriksaan dan audit terhadap jumlah pembayaran yang terjadi.

Keputusan akhir mengenai penyimpanan nilai turunan akan disesuaikan dengan rancangan database pada modul berikutnya.

## TA-03 — Kelengkapan Proses

Pada proses yang diberikan, data pemasok hanya digunakan atau dibaca ketika melakukan pemesanan dan penerimaan barang, tetapi tidak terdapat proses yang secara jelas membuat atau mengelola data pemasok.

Hal tersebut menunjukkan bahwa proses bisnis belum lengkap.

Solusinya adalah menambahkan proses:

**PB-06 — Mengelola Data Pemasok**

Aktor yang bertanggung jawab adalah Ketua koperasi karena memiliki tanggung jawab terhadap pengelolaan data koperasi.

Selain itu, status anggota perlu dikelola oleh aktor yang berwenang agar perubahan status anggota dapat dilakukan secara terkontrol.

---

# 5. Kandidat Entitas

| Kode | Entitas          | Data Utama                                                 | Sumber Data           |
| ---- | ---------------- | ---------------------------------------------------------- | --------------------- |
| E-01 | Anggota          | nomor anggota, NIM, nama, prodi, nomor HP, status aktif    | Formulir pendaftaran  |
| E-02 | Barang           | kode, nama, kategori, harga jual, stok, batas minimum stok | Daftar barang, faktur |
| E-03 | Penjualan        | nomor nota, tanggal-jam, kasir, anggota, pembayaran        | Nota penjualan        |
| E-04 | Detail Penjualan | nomor nota, barang, qty, harga saat transaksi              | Nota penjualan        |
| E-05 | Petugas          | kode petugas, nama, peran                                  | Wawancara             |
| E-06 | Pemasok          | kode, nama, telepon, alamat                                | Faktur pemasok        |
| E-07 | Pembelian        | nomor faktur, tanggal, pemasok                             | Faktur pemasok        |
| E-08 | Detail Pembelian | nomor faktur, barang, qty, harga beli                      | Faktur pemasok        |

---

# 6. Aturan Bisnis

| Kode  | Aturan Bisnis                                                                                                                |
| ----- | ---------------------------------------------------------------------------------------------------------------------------- |
| AB-01 | Setiap nota memiliki nomor unik dan minimal satu baris barang.                                                               |
| AB-02 | Penjualan dapat dilakukan tanpa anggota. Jika menggunakan anggota, anggota harus berstatus aktif untuk memperoleh diskon 5%. |
| AB-03 | Stok barang tidak boleh negatif. Penjualan ditolak jika jumlah yang dibeli melebihi stok tersedia.                           |
| AB-04 | Harga jual yang digunakan pada nota disimpan pada setiap detail transaksi dan tidak berubah ketika harga barang berubah.     |
| AB-05 | NIM anggota harus unik. Pencarian anggota dapat dilakukan berdasarkan nomor anggota atau NIM.                                |
| AB-06 | Pesanan pembelian dibuat ketika stok barang kurang dari batas minimum.                                                       |
| AB-07 | Setiap kelipatan Rp10.000 dari belanja anggota menghasilkan 1 poin loyalitas.                                                |
| AB-08 | Setiap 50 poin loyalitas dapat ditukarkan dengan diskon Rp5.000.                                                             |
| AB-09 | Penukaran poin hanya dapat dilakukan jika saldo poin anggota minimal 50 poin.                                                |
| AB-10 | Setelah 50 poin ditukarkan, saldo poin anggota berkurang sebanyak 50 poin.                                                   |
| AB-11 | Perolehan dan penukaran poin dicatat berdasarkan transaksi yang bersangkutan.                                                |

---

# 7. Kebutuhan Informasi

| Kode  | Kebutuhan Informasi                                          | Sumber Data                          |
| ----- | ------------------------------------------------------------ | ------------------------------------ |
| KI-01 | Omzet dan jumlah nota per hari dan per bulan                 | Penjualan, Detail Penjualan          |
| KI-02 | Lima barang terlaris setiap bulan berdasarkan jumlah terjual | Detail Penjualan, Barang             |
| KI-03 | Barang dengan stok di bawah batas minimum                    | Barang                               |
| KI-04 | Sepuluh anggota dengan jumlah belanja terbesar setiap bulan  | Penjualan, Detail Penjualan, Anggota |
| KI-05 | Saldo poin loyalitas setiap anggota                          | Anggota, Penjualan                   |
| KI-06 | Anggota dengan jumlah poin loyalitas terbanyak               | Anggota, Penjualan                   |
| KI-07 | Jumlah poin yang diperoleh dan ditukarkan setiap periode     | Anggota, Penjualan                   |
| KI-08 | Total diskon yang berasal dari penukaran poin                | Penjualan, Anggota                   |

---

# 8. Matriks CRUD

| Proses                             | Anggota | Barang | Penjualan | Detail Penjualan | Pemasok | Pembelian | Detail Pembelian |
| ---------------------------------- | ------- | ------ | --------- | ---------------- | ------- | --------- | ---------------- |
| PB-01 Mendaftarkan anggota         | C       | -      | -         | -                | -       | -         | -                |
| PB-02 Mencatat penjualan           | R       | R      | C         | C                | -       | -         | -                |
| PB-03 Memesan barang ke pemasok    | -       | R,U    | -         | -                | R       | C         | C                |
| PB-04 Menerima barang dari pemasok | -       | R,U    | -         | -                | R       | U         | U                |
| PB-05 Menyusun laporan bulanan     | R       | R      | R         | R                | R       | R         | R                |
| PB-06 Mengelola data pemasok       | -       | -      | -         | -                | C,R,U   | -         | -                |

### CRUD Program Loyalitas

Program loyalitas menggunakan data anggota dan transaksi penjualan.

| Proses                   | Anggota | Barang | Penjualan | Detail Penjualan |
| ------------------------ | ------- | ------ | --------- | ---------------- |
| PB-02 Mencatat penjualan | R,U     | R      | C,U       | C                |
| PB-05 Menyusun laporan   | R       | R      | R         | R                |
| Program loyalitas        | R,U     | -      | R,U       | R                |

Keterangan:

* **C (Create)** = membuat data.
* **R (Read)** = membaca data.
* **U (Update)** = memperbarui data.
* **D (Delete)** = menghapus data jika diperlukan.

---

# 9. Kamus Data

| No | Nama Data                     | Deskripsi                          | Contoh         | Aturan/Format                | Pengelola      |
| -- | ----------------------------- | ---------------------------------- | -------------- | ---------------------------- | -------------- |
| 1  | no_anggota                    | Nomor anggota koperasi             | A-0457         | Unik, format A-4 digit       | Ketua          |
| 2  | nim_anggota                   | NIM anggota                        | 2301010123     | Unik, 10 digit               | Ketua          |
| 3  | no_hp_anggota                 | Nomor HP anggota                   | 0812xxxx       | Data pribadi, akses terbatas | Ketua          |
| 4  | no_nota_penjualan             | Nomor nota penjualan               | PJ-2609-0142   | Unik                         | Kasir          |
| 5  | kode_barang                   | Kode barang                        | BRG001         | Unik                         | Petugas Gudang |
| 6  | nama_barang                   | Nama barang                        | Buku Tulis     | Wajib diisi                  | Petugas Gudang |
| 7  | harga_satuan_detail_penjualan | Harga jual pada saat transaksi     | 4000           | Integer >= 0                 | Kasir          |
| 8  | qty_penjualan                 | Jumlah barang yang dijual          | 3              | Integer > 0                  | Kasir          |
| 9  | stok_barang                   | Jumlah stok tersedia               | 35             | Integer >= 0                 | Petugas Gudang |
| 10 | batas_minimum_stok            | Batas minimal persediaan           | 10             | Integer >= 0                 | Petugas Gudang |
| 11 | kode_pemasok                  | Kode pemasok                       | SUP001         | Unik                         | Ketua          |
| 12 | nama_pemasok                  | Nama pemasok                       | CV Maju Jaya   | Wajib diisi                  | Ketua          |
| 13 | telepon_pemasok               | Nomor telepon pemasok              | 08123456789    | Format nomor telepon         | Ketua          |
| 14 | alamat_pemasok                | Alamat pemasok                     | Bandar Lampung | Wajib diisi                  | Ketua          |
| 15 | no_faktur_pembelian           | Nomor faktur pembelian             | FP-001         | Unik                         | Petugas Gudang |
| 16 | poin_loyalitas                | Saldo poin anggota                 | 50             | Integer >= 0                 | Ketua          |
| 17 | poin_diperoleh                | Poin yang diperoleh dari transaksi | 7              | Integer >= 0                 | Kasir          |
| 18 | poin_ditukar                  | Poin yang ditukarkan               | 50             | Kelipatan 50                 | Kasir          |
| 19 | diskon_loyalitas              | Potongan dari penukaran poin       | 5000           | Rupiah                       | Kasir          |

---

# 10. Kebutuhan Nonfungsional

| Kode   | Kebutuhan                                                              |
| ------ | ---------------------------------------------------------------------- |
| NFR-01 | Sistem mampu menangani sekitar 150 nota penjualan per hari.            |
| NFR-02 | Data transaksi disimpan minimal selama 5 tahun.                        |
| NFR-03 | Nomor HP anggota hanya dapat dilihat oleh Ketua koperasi.              |
| NFR-04 | Hak akses pengguna dibatasi sesuai peran dan kebutuhan tugas.          |
| NFR-05 | Data transaksi harus dapat ditelusuri untuk kebutuhan pemeriksaan.     |
| NFR-06 | Data stok harus konsisten dengan transaksi barang masuk dan penjualan. |

---

# 11. Program Loyalitas

Program loyalitas digunakan untuk memberikan manfaat kepada anggota berdasarkan jumlah belanja.

Aturan program:

1. Setiap kelipatan Rp10.000 dari belanja anggota menghasilkan 1 poin.
2. Contoh belanja Rp75.000 menghasilkan 7 poin karena hanya kelipatan penuh Rp10.000 yang dihitung.
3. Sebanyak 50 poin dapat ditukarkan dengan diskon Rp5.000.
4. Penukaran hanya dapat dilakukan jika saldo poin minimal 50.
5. Setelah penukaran, saldo poin berkurang 50.
6. Perolehan dan penukaran poin harus dicatat agar riwayat loyalitas dapat ditelusuri.

---

# 12. Perbaikan Kebutuhan yang Masih Vague

## 12.1 Keamanan Data Anggota

### Sebelum

"Data anggota harus aman."

### Setelah diperjelas

Nomor HP anggota hanya dapat dilihat oleh Ketua koperasi, sedangkan pengguna lain tidak memiliki hak akses untuk melihat data tersebut.

---

## 12.2 Kecepatan Pencarian Barang

### Sebelum

"Sistem harus cepat mencari barang."

### Setelah diperjelas

Pencarian barang berdasarkan kode atau nama harus menampilkan hasil maksimal dalam 2 detik pada kondisi penggunaan normal dengan jumlah data hingga 10.000 barang.

---

## 12.3 Akurasi Laporan Stok

### Sebelum

"Laporan stok harus akurat."

### Setelah diperjelas

Jumlah stok yang ditampilkan pada laporan harus sesuai dengan hasil pencatatan transaksi barang masuk dan penjualan sehingga tidak terdapat perbedaan stok pada saat laporan dibuat.

---

# 13. Analisis Kualitas Data

| Masalah                                 | Dampak                            | Pencegahan                              |
| --------------------------------------- | --------------------------------- | --------------------------------------- |
| NIM anggota ganda                       | Anggota sulit diidentifikasi      | Terapkan aturan NIM unik                |
| Nomor anggota tidak konsisten           | Pencarian anggota sulit           | Gunakan format nomor anggota yang tetap |
| Stok tidak diperbarui                   | Laporan stok tidak akurat         | Perbarui stok setiap transaksi          |
| Harga transaksi mengambil harga terbaru | Nota lama menjadi tidak sesuai    | Simpan harga saat transaksi             |
| Data pemasok tidak lengkap              | Pemesanan sulit ditelusuri        | Wajib mengisi data pemasok              |
| Nomor faktur tidak dicatat              | Riwayat pembelian sulit diperiksa | Gunakan nomor faktur unik               |
| Data nomor HP terbuka                   | Risiko privasi                    | Batasi akses berdasarkan peran          |

---

# 14. Kesimpulan

Analisis kebutuhan data pada Koperasi Mahasiswa menunjukkan bahwa proses bisnis utama membutuhkan data anggota, barang, penjualan, detail penjualan, pemasok, pembelian, dan petugas.

Penyimpanan harga saat transaksi diperlukan agar riwayat penjualan tetap sesuai dengan kondisi ketika transaksi terjadi. Program loyalitas menambahkan kebutuhan data berupa poin yang diperoleh, poin yang ditukarkan, dan diskon loyalitas.

Penambahan proses pengelolaan pemasok juga diperlukan karena data pemasok digunakan dalam proses pembelian tetapi tidak dapat dibuat tanpa proses khusus.

Hasil analisis kebutuhan ini menjadi dasar untuk tahap perancangan database, termasuk perancangan entitas, atribut, relasi, dan struktur tabel.
