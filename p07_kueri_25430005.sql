-- ============================================================
-- p07_kueri_25430005.sql
-- Milestone Proyek 7 - Kueri SELECT Perpustakaan Putri Dewi
-- Nama : Putri Nur Rahma Dewi | NIM : 25430005 | Kelas : A
-- Basis data : perpus_25430005
--
-- PRASYARAT: p05_ddl_25430005.sql lalu p06_data_25430005.sql (keadaan awal Modul 6).
-- Hasil yang diharapkan dihitung dari data itu. Jalankan kueri SATU PER SATU.
-- Setiap kueri: kode KI, pertanyaan sehari-hari, hasil yang diharapkan (ditulis
-- sebelum dijalankan), lalu baris 'Hasil nyata' diisi setelah dijalankan.
--
-- Kode KI mengikuti urutan Kebutuhan Informasi pada dokumen P2:
--   KI-01 jumlah anggota aktif dan tidak aktif
--   KI-02 ketersediaan buku berdasarkan judul dan eksemplar
--   KI-03 daftar buku yang sedang dipinjam
--   KI-04 lima judul buku paling sering dipinjam tiap bulan
--   KI-05 daftar anggota yang terlambat mengembalikan buku
--   KI-06 total denda per periode
--   KI-07 jumlah peminjaman dan pengembalian
--   KI-08 daftar petugas berdasarkan peran
-- Cakupan operator: LIKE (P-07), BETWEEN (P-04), IN (P-08), IS NULL (P-09),
--   CASE (P-05, P-12), fungsi tanggal (P-10), fungsi string (P-11).
-- ============================================================

USE perpus_25430005;

-- ----------------------------------------------------------------
-- P-01 | KI-01
-- Pertanyaan : Siapa saja anggota yang berstatus tidak aktif?
-- Hasil yang diharapkan (diprediksi sebelum dijalankan): 2 baris
--   no_anggota | nama_anggota | prodi_anggota | status_anggota
--   AG-0011 | Joko Susilo | Teknik Informatika | tidak aktif
--   AG-0012 | Kartika Sari | Pendidikan Matematika | tidak aktif
-- Catatan      : Menghitung jumlah anggota aktif dan tidak aktif memerlukan COUNT dan GROUP BY (Pertemuan 9).
-- Hasil nyata  : (isi setelah dijalankan; tulis 'sama' atau jelaskan perbedaannya)

SELECT no_anggota, nama_anggota, prodi_anggota, status_anggota
FROM anggota
WHERE status_anggota = 'tidak aktif'
ORDER BY no_anggota;

-- ----------------------------------------------------------------
-- P-02 | KI-02
-- Pertanyaan : Eksemplar mana yang sekarang tersedia dan berkondisi baik?
-- Hasil yang diharapkan (diprediksi sebelum dijalankan): 13 baris (ditampilkan 10 pertama)
--   kode_eksemplar | kondisi_eksemplar | status_eksemplar
--   EK001 | baik | tersedia
--   EK002 | baik | tersedia
--   EK003 | baik | tersedia
--   EK004 | baik | tersedia
--   EK008 | baik | tersedia
--   EK009 | baik | tersedia
--   EK013 | baik | tersedia
--   EK015 | baik | tersedia
--   EK016 | baik | tersedia
--   EK017 | baik | tersedia
-- Catatan      : Menampilkan judul buku untuk tiap eksemplar memerlukan JOIN dengan tabel buku (Pertemuan 10).
-- Hasil nyata  : (isi setelah dijalankan; tulis 'sama' atau jelaskan perbedaannya)

SELECT kode_eksemplar, kondisi_eksemplar, status_eksemplar
FROM eksemplar
WHERE status_eksemplar = 'tersedia' AND kondisi_eksemplar = 'baik'
ORDER BY kode_eksemplar;

-- ----------------------------------------------------------------
-- P-03 | KI-03
-- Pertanyaan : Eksemplar mana yang masih dipinjam (belum dikembalikan)?
-- Hasil yang diharapkan (diprediksi sebelum dijalankan): 10 baris
--   id_peminjaman | id_eksemplar | status_peminjaman
--   36 | 5 | aktif
--   36 | 11 | aktif
--   36 | 12 | aktif
--   39 | 6 | aktif
--   39 | 14 | aktif
--   56 | 20 | aktif
--   57 | 23 | aktif
--   58 | 10 | aktif
--   59 | 22 | aktif
--   59 | 24 | aktif
-- Catatan      : Menampilkan kode dan judul buku memerlukan JOIN (Pertemuan 10).
-- Hasil nyata  : (isi setelah dijalankan; tulis 'sama' atau jelaskan perbedaannya)

SELECT id_peminjaman, id_eksemplar, status_peminjaman
FROM detail_peminjaman
WHERE status_peminjaman = 'aktif' AND tanggal_kembali IS NULL
ORDER BY id_peminjaman, id_eksemplar;

-- ----------------------------------------------------------------
-- P-04 | KI-07
-- Pertanyaan : Peminjaman apa saja yang terjadi pada 1 sampai 9 Oktober 2026?
-- Hasil yang diharapkan (diprediksi sebelum dijalankan): 13 baris (ditampilkan 10 pertama)
--   no_peminjaman | tanggal_pinjam | tanggal_jatuh_tempo
--   PJ-0037 | 2026-10-01 | 2026-10-08
--   PJ-0038 | 2026-10-01 | 2026-10-08
--   PJ-0039 | 2026-10-01 | 2026-10-08
--   PJ-0040 | 2026-10-02 | 2026-10-09
--   PJ-0041 | 2026-10-05 | 2026-10-12
--   PJ-0042 | 2026-10-06 | 2026-10-13
--   PJ-0043 | 2026-10-06 | 2026-10-13
--   PJ-0044 | 2026-10-07 | 2026-10-14
--   PJ-0045 | 2026-10-07 | 2026-10-14
--   PJ-0046 | 2026-10-08 | 2026-10-15
-- Catatan      : Kolom bertipe DATE, jadi BETWEEN aman. Jumlah peminjaman memerlukan COUNT (Pertemuan 9).
-- Hasil nyata  : (isi setelah dijalankan; tulis 'sama' atau jelaskan perbedaannya)

SELECT no_peminjaman, tanggal_pinjam, tanggal_jatuh_tempo
FROM peminjaman
WHERE tanggal_pinjam BETWEEN '2026-10-01' AND '2026-10-09'
ORDER BY tanggal_pinjam, no_peminjaman;

-- ----------------------------------------------------------------
-- P-05 | KI-06
-- Pertanyaan : Denda apa saja yang belum lunas, dan seberapa berat keterlambatannya?
-- Hasil yang diharapkan (diprediksi sebelum dijalankan): 2 baris
--   kode_denda | jumlah_hari_terlambat | jumlah_denda | kategori
--   DN007 | 8 | 48000.00 | berat
--   DN008 | 5 | 30000.00 | sedang
-- Catatan      : Total denda per periode memerlukan SUM (Pertemuan 9).
-- Hasil nyata  : (isi setelah dijalankan; tulis 'sama' atau jelaskan perbedaannya)

SELECT kode_denda, jumlah_hari_terlambat, jumlah_denda,
       CASE WHEN jumlah_hari_terlambat <= 3 THEN 'ringan'
            WHEN jumlah_hari_terlambat <= 6 THEN 'sedang'
            ELSE 'berat' END AS kategori
FROM denda
WHERE status_pembayaran = 'belum lunas'
ORDER BY jumlah_denda DESC, kode_denda;

-- ----------------------------------------------------------------
-- P-06 | KI-08
-- Pertanyaan : Siapa saja petugas, diurutkan menurut peran?
-- Hasil yang diharapkan (diprediksi sebelum dijalankan): 5 baris
--   kode_petugas | nama_petugas | peran
--   PT001 | Siti Aminah | ADMINISTRATOR
--   PT004 | Eko Prasetyo | PETUGAS
--   PT003 | Maya Anggraini | PETUGAS
--   PT002 | Rudi Hartono | PETUGAS
--   PT005 | Wulan Sari | PETUGAS
-- Hasil nyata  : (isi setelah dijalankan; tulis 'sama' atau jelaskan perbedaannya)

SELECT kode_petugas, nama_petugas, UPPER(peran_petugas) AS peran
FROM petugas
ORDER BY peran_petugas, nama_petugas;

-- ----------------------------------------------------------------
-- P-07 | KI-02
-- Pertanyaan : Buku apa saja yang judulnya mengandung kata 'Data'?
-- Hasil yang diharapkan (diprediksi sebelum dijalankan): 3 baris
--   kode_buku | judul_buku | penulis_buku
--   BK001 | Basis Data Dasar | Hendra Wijaya
--   BK004 | Struktur Data dan Algoritma | Maria Lestari
--   BK006 | Statistika untuk Sains Data | Ayu Permata
-- Hasil nyata  : (isi setelah dijalankan; tulis 'sama' atau jelaskan perbedaannya)

SELECT kode_buku, judul_buku, penulis_buku
FROM buku
WHERE judul_buku LIKE '%Data%'
ORDER BY kode_buku;

-- ----------------------------------------------------------------
-- P-08 | KI-02
-- Pertanyaan : Buku apa saja yang berkategori Pemrograman atau Jaringan?
-- Hasil yang diharapkan (diprediksi sebelum dijalankan): 4 baris
--   kode_buku | judul_buku | kategori_buku
--   BK003 | Jaringan Komputer Praktis | Jaringan
--   BK002 | Pemrograman Python untuk Pemula | Pemrograman
--   BK004 | Struktur Data dan Algoritma | Pemrograman
--   BK010 | Rekayasa Perangkat Lunak | Pemrograman
-- Hasil nyata  : (isi setelah dijalankan; tulis 'sama' atau jelaskan perbedaannya)

SELECT kode_buku, judul_buku, kategori_buku
FROM buku
WHERE kategori_buku IN ('Pemrograman', 'Jaringan')
ORDER BY kategori_buku, kode_buku;

-- ----------------------------------------------------------------
-- P-09 | KI-02
-- Pertanyaan : Buku mana yang belum memiliki nomor ISBN?
-- Hasil yang diharapkan (diprediksi sebelum dijalankan): 2 baris
--   kode_buku | judul_buku | isbn
--   BK007 | Sejarah Indonesia Modern | NULL
--   BK008 | Kumpulan Cerita Pendek Senja | NULL
-- Hasil nyata  : (isi setelah dijalankan; tulis 'sama' atau jelaskan perbedaannya)

SELECT kode_buku, judul_buku, isbn
FROM buku
WHERE isbn IS NULL
ORDER BY kode_buku;

-- ----------------------------------------------------------------
-- P-10 | KI-07
-- Pertanyaan : Lima peminjaman pertama: kapan dipinjam (format Indonesia) dan berapa hari tenggangnya?
-- Hasil yang diharapkan (diprediksi sebelum dijalankan): 5 baris
--   no_peminjaman | tgl_pinjam | tenggang_hari
--   PJ-0001 | 07-09-2026 | 7
--   PJ-0002 | 07-09-2026 | 7
--   PJ-0003 | 08-09-2026 | 7
--   PJ-0004 | 08-09-2026 | 7
--   PJ-0005 | 08-09-2026 | 7
-- Hasil nyata  : (isi setelah dijalankan; tulis 'sama' atau jelaskan perbedaannya)

SELECT no_peminjaman,
       DATE_FORMAT(tanggal_pinjam, '%d-%m-%Y') AS tgl_pinjam,
       DATEDIFF(tanggal_jatuh_tempo, tanggal_pinjam) AS tenggang_hari
FROM peminjaman
ORDER BY tanggal_pinjam, no_peminjaman
LIMIT 5;

-- ----------------------------------------------------------------
-- P-11 | KI-02
-- Pertanyaan : Daftar judul buku dengan penulisnya dalam satu kolom, kategori huruf kapital (5 buku dengan tahun terbit terbaru).
-- Hasil yang diharapkan (diprediksi sebelum dijalankan): 5 baris
--   buku | kategori | tahun_terbit
--   Struktur Data dan Algoritma - Maria Lestari | PEMROGRAMAN | 2024
--   Rekayasa Perangkat Lunak - Fitri Handayani | PEMROGRAMAN | 2024
--   Basis Data Dasar - Hendra Wijaya | BASIS DATA | 2023
--   Statistika untuk Sains Data - Ayu Permata | MATEMATIKA | 2023
--   Pemrograman Python untuk Pemula - Rina Kartika | PEMROGRAMAN | 2022
-- Hasil nyata  : (isi setelah dijalankan; tulis 'sama' atau jelaskan perbedaannya)

SELECT CONCAT(judul_buku, ' - ', penulis_buku) AS buku,
       UPPER(kategori_buku) AS kategori,
       tahun_terbit
FROM buku
ORDER BY tahun_terbit DESC, kode_buku
LIMIT 5;

-- ----------------------------------------------------------------
-- P-12 | KI-01
-- Pertanyaan : Anggota mana boleh meminjam, dan alamat mana yang masih kosong?
-- Hasil yang diharapkan (diprediksi sebelum dijalankan): 4 baris
--   no_anggota | nama_anggota | keterangan | alamat
--   AG-0005 | Dimas Aryanto | Boleh meminjam | -
--   AG-0009 | Hafiz Mubarok | Boleh meminjam | -
--   AG-0011 | Joko Susilo | Tidak boleh meminjam | Jl. Tirtayasa No. 3, Bandar Lampung
--   AG-0012 | Kartika Sari | Tidak boleh meminjam | Jl. Cut Nyak Dien No. 11, Bandar Lampung
-- Hasil nyata  : (isi setelah dijalankan; tulis 'sama' atau jelaskan perbedaannya)

SELECT no_anggota, nama_anggota,
       CASE status_anggota WHEN 'aktif' THEN 'Boleh meminjam'
                           ELSE 'Tidak boleh meminjam' END AS keterangan,
       IFNULL(alamat_anggota, '-') AS alamat
FROM anggota
WHERE status_anggota = 'tidak aktif' OR alamat_anggota IS NULL
ORDER BY no_anggota;

-- ----------------------------------------------------------------
-- P-13 | KI-02
-- Pertanyaan : Eksemplar mana (kode di atas EK010) yang rusak atau sedang dipinjam? (OR ditulis dengan tanda kurung)
-- Hasil yang diharapkan (diprediksi sebelum dijalankan): 8 baris
--   kode_eksemplar | kondisi_eksemplar | status_eksemplar
--   EK011 | baik | dipinjam
--   EK012 | baik | dipinjam
--   EK014 | baik | dipinjam
--   EK019 | rusak | tersedia
--   EK020 | baik | dipinjam
--   EK022 | baik | dipinjam
--   EK023 | baik | dipinjam
--   EK024 | baik | dipinjam
-- Hasil nyata  : (isi setelah dijalankan; tulis 'sama' atau jelaskan perbedaannya)

SELECT kode_eksemplar, kondisi_eksemplar, status_eksemplar
FROM eksemplar
WHERE (kondisi_eksemplar = 'rusak' OR status_eksemplar = 'dipinjam')
  AND kode_eksemplar > 'EK010'
ORDER BY kode_eksemplar;

-- ------------------------------------------------------------
-- KI yang BELUM dapat dijawab dengan satu tabel (dijawab di Pertemuan 9-12)
-- ------------------------------------------------------------
-- KI-01 (jumlah per status)  : perlu COUNT dan GROUP BY            -> Pertemuan 9
-- KI-02 (ketersediaan per judul) : perlu JOIN eksemplar dan buku   -> Pertemuan 10
-- KI-03 (nama buku yang dipinjam): perlu JOIN detail, eksemplar, buku -> Pertemuan 10
-- KI-04 (lima judul terpopuler)  : perlu JOIN, COUNT, GROUP BY, ORDER BY, LIMIT -> Pertemuan 9-10
-- KI-05 (anggota terlambat)      : perlu JOIN peminjaman, detail, anggota dan pembanding tanggal -> Pertemuan 10
-- KI-06 (total denda per periode): perlu SUM dan GROUP BY          -> Pertemuan 9
-- KI-07 (jumlah peminjaman)      : perlu COUNT dan GROUP BY        -> Pertemuan 9
