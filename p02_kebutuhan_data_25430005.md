# Dokumen Kebutuhan Data - Perpustakaan Putri Dewi

## Identitas

* Nama: Putri Nur Rahma Dewi
* NIM: 25430005
* Kelas: A
* Mata Kuliah: Basis Data
* Semester: 3
* Tema Proyek: Perpustakaan
* Database: `perpus_25430005`

---

# 1. Latar Belakang dan Ruang Lingkup

Perpustakaan Putri Dewi merupakan organisasi fiktif yang menyediakan layanan pendaftaran anggota, pengelolaan data buku dan eksemplar, peminjaman, pengembalian, serta pencatatan denda keterlambatan.

Sistem pengelolaan data diperlukan agar informasi anggota, buku, eksemplar, transaksi peminjaman, pengembalian, denda, dan petugas dapat dikelola secara terstruktur.

Ruang lingkup sistem meliputi:

* Pengelolaan data anggota.
* Pengelolaan data buku.
* Pengelolaan data eksemplar buku.
* Peminjaman buku.
* Pengembalian buku.
* Pengelolaan denda.
* Pengelolaan data petugas.
* Pembuatan laporan perpustakaan.

Satu judul buku dapat memiliki beberapa eksemplar fisik. Oleh karena itu, data `Buku` dan `Eksemplar` dibedakan agar setiap buku fisik dapat dilacak secara jelas.

---

# 2. Aktor dan Proses Bisnis

| Kode  | Proses Bisnis                     | Aktor            | Pemicu                                              |
| ----- | --------------------------------- | ---------------- | --------------------------------------------------- |
| PB-01 | Mendaftarkan anggota              | Petugas          | Mahasiswa ingin menjadi anggota                     |
| PB-02 | Mengelola data buku dan eksemplar | Petugas          | Buku baru tersedia atau data perlu diperbarui       |
| PB-03 | Melakukan peminjaman buku         | Petugas, Anggota | Anggota ingin meminjam buku                         |
| PB-04 | Melakukan pengembalian buku       | Petugas, Anggota | Anggota mengembalikan buku                          |
| PB-05 | Mencatat dan mengelola denda      | Petugas          | Terjadi keterlambatan pengembalian                  |
| PB-06 | Membuat laporan perpustakaan      | Petugas          | Dibutuhkan informasi atau laporan periode tertentu  |
| PB-07 | Mengelola data petugas            | Administrator    | Ada petugas baru atau data petugas perlu diperbarui |

---

# 3. Sumber Data

Sumber data yang digunakan dalam analisis kebutuhan adalah:

1. Formulir pendaftaran anggota.
2. Kartu atau data katalog buku.
3. Slip peminjaman.
4. Formulir pengembalian.
5. Kuitansi pembayaran denda.
6. Laporan transaksi perpustakaan.
7. Slip Peminjaman Perpustakaan Putri Dewi sebagai dokumen fiktif yang dirancang untuk melengkapi analisis.

---

# 4. Kandidat Entitas

| Kode | Entitas           | Data Utama                                                                           |
| ---- | ----------------- | ------------------------------------------------------------------------------------ |
| E-01 | Anggota           | nomor anggota, NIM, nama, prodi, nomor HP, alamat, status                            |
| E-02 | Buku              | kode buku, ISBN, judul, penulis, penerbit, tahun terbit, kategori                    |
| E-03 | Eksemplar         | kode eksemplar, kode buku, kondisi, status ketersediaan                              |
| E-04 | Peminjaman        | nomor peminjaman, anggota, petugas, tanggal pinjam, tanggal jatuh tempo              |
| E-05 | Detail Peminjaman | nomor peminjaman, eksemplar, tanggal kembali, status                                 |
| E-06 | Denda             | kode denda, nomor peminjaman, jumlah hari terlambat, jumlah denda, status pembayaran |
| E-07 | Petugas           | kode petugas, nama, username, peran                                                  |

Contoh: satu judul buku dapat mempunyai beberapa eksemplar. Buku dengan judul "Basis Data Dasar" dapat memiliki kode eksemplar EK001, EK002, dan EK003.

---

# 5. Aturan Bisnis

| Kode  | Aturan Bisnis                                                                                                   |
| ----- | --------------------------------------------------------------------------------------------------------------- |
| AB-01 | Setiap anggota memiliki nomor anggota yang unik.                                                                |
| AB-02 | Hanya anggota dengan status aktif yang dapat melakukan peminjaman.                                              |
| AB-03 | Satu judul buku dapat memiliki lebih dari satu eksemplar dengan kode yang berbeda.                              |
| AB-04 | Eksemplar yang sedang dipinjam tidak boleh dipinjam oleh anggota lain sampai dikembalikan.                      |
| AB-05 | Maksimal buku dalam satu transaksi peminjaman adalah 8 eksemplar.                                               |
| AB-06 | Status eksemplar berubah menjadi Dipinjam ketika peminjaman berhasil dan menjadi Tersedia setelah pengembalian. |
| AB-07 | Denda keterlambatan sebesar Rp6.000 untuk setiap hari keterlambatan.                                            |
| AB-08 | Denda dicatat ketika buku dikembalikan melewati tanggal jatuh tempo.                                            |
| AB-09 | Satu eksemplar tidak boleh memiliki lebih dari satu peminjaman aktif pada waktu yang sama.                      |
| AB-10 | Data anggota, buku, transaksi, dan denda hanya dapat diubah oleh petugas yang memiliki hak akses.               |
| AB-11 | Data petugas hanya dapat dikelola oleh administrator.                                                           |

---

# 6. Kebutuhan Informasi

| Kode  | Kebutuhan Informasi                                      | Sumber Data                              |
| ----- | -------------------------------------------------------- | ---------------------------------------- |
| KI-01 | Jumlah anggota aktif dan tidak aktif                     | Anggota                                  |
| KI-02 | Ketersediaan buku berdasarkan judul dan jumlah eksemplar | Buku, Eksemplar                          |
| KI-03 | Daftar buku yang sedang dipinjam atau belum dikembalikan | Peminjaman, Detail Peminjaman, Eksemplar |
| KI-04 | Lima judul buku yang paling sering dipinjam setiap bulan | Buku, Detail Peminjaman                  |
| KI-05 | Daftar anggota yang terlambat mengembalikan buku         | Anggota, Peminjaman, Detail Peminjaman   |
| KI-06 | Total denda yang tercatat dan dibayar setiap periode     | Denda, Peminjaman                        |
| KI-07 | Jumlah peminjaman dan pengembalian per hari atau bulan   | Peminjaman, Detail Peminjaman            |
| KI-08 | Daftar petugas berdasarkan peran                         | Petugas                                  |

---

# 7. Matriks CRUD

| Proses                             | Anggota | Buku  | Eksemplar | Peminjaman | Detail Peminjaman | Denda | Petugas |
| ---------------------------------- | ------- | ----- | --------- | ---------- | ----------------- | ----- | ------- |
| PB-01 Mendaftarkan anggota         | C       | -     | -         | -          | -                 | -     | R       |
| PB-02 Mengelola buku dan eksemplar | -       | C,R,U | C,R,U     | -          | -                 | -     | R       |
| PB-03 Peminjaman buku              | R       | R     | R,U       | C          | C                 | -     | R       |
| PB-04 Pengembalian buku            | R       | R     | R,U       | R,U        | R,U               | C     | R       |
| PB-05 Mengelola denda              | R       | -     | -         | R          | R                 | C,R,U | R       |
| PB-06 Membuat laporan              | R       | R     | R         | R          | R                 | R     | R       |
| PB-07 Mengelola data petugas       | -       | -     | -         | -          | -                 | -     | C,R,U   |

Keterangan:

* **C (Create)** = membuat data.
* **R (Read)** = membaca atau mengambil data.
* **U (Update)** = memperbarui data.
* **D (Delete)** = menghapus data jika diperlukan.

Pada sistem ini penghapusan data transaksi tidak dilakukan secara sembarangan agar riwayat peminjaman dan denda tetap tersedia untuk kebutuhan pemeriksaan.

---

# 8. Kamus Data

| No | Nama Data             | Deskripsi                  | Contoh               | Aturan/Format        | Pengelola     |
| -- | --------------------- | -------------------------- | -------------------- | -------------------- | ------------- |
| 1  | no_anggota            | Nomor identitas anggota    | AG-0001              | Unik                 | Petugas       |
| 2  | nim_anggota           | Nomor induk mahasiswa      | 25430005             | Unik                 | Petugas       |
| 3  | nama_anggota          | Nama lengkap anggota       | Putri Nur Rahma Dewi | Wajib diisi          | Petugas       |
| 4  | prodi_anggota         | Program studi anggota      | Ilmu Komputer        | Wajib diisi          | Petugas       |
| 5  | no_hp_anggota         | Nomor telepon anggota      | 081234567890         | Data pribadi         | Petugas       |
| 6  | alamat_anggota        | Alamat anggota             | Kalianda             | Data pribadi         | Petugas       |
| 7  | status_anggota        | Status keanggotaan         | Aktif                | Aktif/Tidak Aktif    | Petugas       |
| 8  | kode_buku             | Kode identitas buku        | BK001                | Unik                 | Petugas       |
| 9  | isbn                  | Nomor ISBN buku            | 9781234567890        | Jika tersedia        | Petugas       |
| 10 | judul_buku            | Judul buku                 | Basis Data           | Wajib diisi          | Petugas       |
| 11 | penulis_buku          | Nama penulis               | Abdul Kadir          | Wajib diisi          | Petugas       |
| 12 | penerbit_buku         | Nama penerbit              | Informatika          | Wajib diisi          | Petugas       |
| 13 | tahun_terbit          | Tahun penerbitan           | 2025                 | Tahun valid          | Petugas       |
| 14 | kategori_buku         | Kategori buku              | Basis Data           | Wajib diisi          | Petugas       |
| 15 | kode_eksemplar        | Kode buku fisik            | EK001                | Unik                 | Petugas       |
| 16 | status_eksemplar      | Status ketersediaan        | Tersedia             | Tersedia/Dipinjam    | Petugas       |
| 17 | kondisi_eksemplar     | Kondisi fisik buku         | Baik                 | Baik/Rusak           | Petugas       |
| 18 | no_peminjaman         | Nomor transaksi peminjaman | PJ-0001              | Unik                 | Petugas       |
| 19 | tanggal_pinjam        | Tanggal buku dipinjam      | 2026-10-03           | Format tanggal       | Petugas       |
| 20 | tanggal_jatuh_tempo   | Batas waktu pengembalian   | 2026-10-10           | >= tanggal pinjam    | Petugas       |
| 21 | tanggal_kembali       | Tanggal buku dikembalikan  | 2026-10-12           | Diisi saat kembali   | Petugas       |
| 22 | status_peminjaman     | Status transaksi           | Dikembalikan         | Aktif/Dikembalikan   | Petugas       |
| 23 | kode_denda            | Kode identitas denda       | DN001                | Unik                 | Petugas       |
| 24 | jumlah_hari_terlambat | Jumlah hari keterlambatan  | 2                    | Integer >= 0         | Petugas       |
| 25 | jumlah_denda          | Nominal denda              | 12000                | Rp6.000 x hari       | Petugas       |
| 26 | status_pembayaran     | Status pembayaran denda    | Lunas                | Lunas/Belum Lunas    | Petugas       |
| 27 | kode_petugas          | Kode identitas petugas     | PT001                | Unik                 | Administrator |
| 28 | nama_petugas          | Nama petugas               | Siti                 | Wajib diisi          | Administrator |
| 29 | peran_petugas         | Peran pengguna             | Petugas              | Menentukan hak akses | Administrator |

---

# 9. Kebutuhan Nonfungsional

| Kode   | Kebutuhan                                                                                                                                             |
| ------ | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| NFR-01 | Data transaksi perpustakaan disimpan minimal selama 5 tahun.                                                                                          |
| NFR-02 | Data pribadi anggota hanya dapat diakses oleh petugas yang berwenang.                                                                                 |
| NFR-03 | Pencarian buku berdasarkan kode atau judul diharapkan memberikan hasil maksimal 2 detik pada penggunaan normal dengan jumlah data hingga 10.000 buku. |
| NFR-04 | Sistem harus menjaga konsistensi status eksemplar antara data peminjaman dan data ketersediaan buku.                                                  |
| NFR-05 | Perhitungan denda harus sesuai dengan jumlah hari keterlambatan.                                                                                      |
| NFR-06 | Hak akses pengguna dibedakan berdasarkan peran petugas.                                                                                               |

---

# 10. Parameter Perhitungan Berdasarkan NIM

Dua digit terakhir NIM adalah **05**.

Rumus:

**P = (05 mod 9) + 1**

**P = 5 + 1**

**P = 6**

Berdasarkan nilai P = 6:

* Maksimal buku dalam satu transaksi = P + 2 = **8 eksemplar**.
* Denda keterlambatan = **Rp6.000 per hari**.
* Estimasi transaksi harian = 40 + (5 x P) = 40 + 30 = **70 transaksi per hari**.

---

# 11. Dokumen Fiktif

## Slip Peminjaman Perpustakaan Putri Dewi

**Nomor Peminjaman:** PJ-0001
**Tanggal Pinjam:** 03-10-2026
**Nomor Anggota:** AG-0001
**Nama Anggota:** Putri Nur Rahma Dewi
**Kode Eksemplar:** EK001
**Judul Buku:** Basis Data Dasar
**Tanggal Jatuh Tempo:** 10-10-2026
**Kode Petugas:** PT001

### Analisis

Data yang perlu disimpan dari slip tersebut adalah nomor peminjaman, tanggal pinjam, anggota, eksemplar yang dipinjam, tanggal jatuh tempo, dan petugas.

Nama anggota dan judul buku tidak perlu disimpan ulang pada transaksi apabila sudah tersedia pada tabel Anggota dan Buku karena dapat diperoleh melalui hubungan antarentitas.

---

# 12. Masalah Kualitas Data dan Pencegahannya

| Masalah                                       | Dampak                                         | Pencegahan                                         |
| --------------------------------------------- | ---------------------------------------------- | -------------------------------------------------- |
| Nomor anggota ganda                           | Anggota sulit dibedakan                        | Gunakan nomor anggota unik                         |
| Kode eksemplar ganda                          | Buku fisik sulit dilacak                       | Gunakan kode eksemplar unik                        |
| Status eksemplar tidak diperbarui             | Buku terlihat tersedia padahal sedang dipinjam | Perbarui status saat peminjaman dan pengembalian   |
| Tanggal kembali kosong                        | Riwayat pengembalian tidak lengkap             | Wajib diisi ketika buku dikembalikan               |
| Data anggota tidak lengkap                    | Informasi anggota tidak akurat                 | Validasi data saat pendaftaran                     |
| Perhitungan denda salah                       | Jumlah pembayaran tidak sesuai                 | Gunakan rumus denda berdasarkan hari keterlambatan |
| Data pribadi dapat diakses sembarang pengguna | Risiko penyalahgunaan data                     | Terapkan pembatasan hak akses                      |

---

# 13. Kesimpulan

Berdasarkan analisis kebutuhan, Perpustakaan Putri Dewi membutuhkan pengelolaan data yang terstruktur untuk anggota, buku, eksemplar, peminjaman, pengembalian, denda, dan petugas.

Pemisahan antara entitas Buku dan Eksemplar diperlukan karena satu judul buku dapat memiliki beberapa buku fisik dengan kondisi dan status yang berbeda. Aturan bisnis digunakan untuk menjaga konsistensi transaksi, ketersediaan buku, serta perhitungan denda.

Kebutuhan informasi, matriks CRUD, kamus data, kebutuhan nonfungsional, dan masalah kualitas data yang telah disusun menjadi dasar untuk tahap perancangan database pada modul berikutnya.
