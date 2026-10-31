-- ============================================================
-- p06_data_25430005.sql
-- Milestone Proyek 6 - Data sampel Perpustakaan Putri Dewi
-- Nama : Putri Nur Rahma Dewi | NIM : 25430005 | Kelas : A
-- Basis data : perpus_25430005
--
-- Cara menjalankan dari basis data kosong:
--   1. p05_ddl_25430005.sql   (membuat tujuh tabel)
--   2. p06_data_25430005.sql  (berkas ini)
--
-- Parameter P = (05 mod 9) + 1 = 6:
--   transaksi utama (peminjaman) = 10 x P = 60 baris, tersebar pada banyak tanggal
--   maksimal 8 eksemplar per peminjaman (P + 2), denda Rp6.000 per hari.
-- Kunci tamu diisi dengan subkueri memakai kode alami (bukan menebak nilai id).
-- Data dibuat konsisten dengan aturan bisnis:
--   AB-02 peminjam adalah anggota aktif        AB-05 maks. 8 eksemplar per peminjaman
--   AB-06 status eksemplar sesuai peminjaman   AB-07 denda Rp6.000 x hari terlambat
--   AB-08 denda dicatat saat kembali terlambat AB-09 satu eksemplar maks. satu peminjaman aktif
-- Keterangan data: jatuh tempo = tanggal pinjam + 7 hari; denda hanya dibuat
-- untuk pengembalian yang melewati jatuh tempo; peminjaman berstatus aktif
-- belum memiliki denda karena belum dikembalikan.
-- ============================================================

USE perpus_25430005;

-- ------------------------------------------------------------
-- 1. Data induk
-- ------------------------------------------------------------
INSERT INTO petugas (kode_petugas, nama_petugas, username_petugas, peran_petugas) VALUES
  ('PT001','Siti Aminah','siti','administrator'),
  ('PT002','Rudi Hartono','rudi','petugas'),
  ('PT003','Maya Anggraini','maya','petugas'),
  ('PT004','Eko Prasetyo','eko','petugas'),
  ('PT005','Wulan Sari','wulan','petugas');

INSERT INTO anggota (no_anggota, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, alamat_anggota, status_anggota) VALUES
  ('AG-0001','25430005','Putri Nur Rahma Dewi','Ilmu Komputer','081300000001','Jl. Pramuka No. 5, Bandar Lampung','aktif'),
  ('AG-0002','25439101','Alya Zahira','Ilmu Komputer','081300000002','Jl. Kemiling No. 21, Bandar Lampung','aktif'),
  ('AG-0003','25439102','Bima Prakoso','Teknik Informatika','081300000003','Jl. Rajabasa No. 14, Bandar Lampung','aktif'),
  ('AG-0004','25439103','Citra Maharani','Manajemen','081300000004','Jl. Sukarame No. 7, Bandar Lampung','aktif'),
  ('AG-0005','25439104','Dimas Aryanto','Akuntansi','081300000005',NULL,'aktif'),
  ('AG-0006','25439105','Elsa Kurnia','Pendidikan Matematika','081300000006','Jl. Antasari No. 33, Bandar Lampung','aktif'),
  ('AG-0007','25439106','Farhan Ramadhan','Teknik Informatika','081300000007','Jl. Untung Suropati No. 9, Bandar Lampung','aktif'),
  ('AG-0008','25439107','Gita Pertiwi','Ilmu Komputer','081300000008','Jl. Way Halim No. 18, Bandar Lampung','aktif'),
  ('AG-0009','25439108','Hafiz Mubarok','Manajemen','081300000009',NULL,'aktif'),
  ('AG-0010','25439109','Intan Permatasari','Akuntansi','081300000010','Jl. Imam Bonjol No. 27, Bandar Lampung','aktif'),
  ('AG-0011','25439110','Joko Susilo','Teknik Informatika','081300000011','Jl. Tirtayasa No. 3, Bandar Lampung','tidak aktif'),
  ('AG-0012','25439111','Kartika Sari','Pendidikan Matematika','081300000012','Jl. Cut Nyak Dien No. 11, Bandar Lampung','tidak aktif');

INSERT INTO buku (kode_buku, isbn, judul_buku, penulis_buku, penerbit_buku, tahun_terbit, kategori_buku) VALUES
  ('BK001','9786231000011','Basis Data Dasar','Hendra Wijaya','Penerbit Nusantara',2023,'Basis Data'),
  ('BK002','9786231000028','Pemrograman Python untuk Pemula','Rina Kartika','Cakrawala Media',2022,'Pemrograman'),
  ('BK003','9786231000035','Jaringan Komputer Praktis','Dedi Santoso','Graha Teknologi',2021,'Jaringan'),
  ('BK004','9786231000042','Struktur Data dan Algoritma','Maria Lestari','Cakrawala Media',2024,'Pemrograman'),
  ('BK005','9786231000059','Kalkulus Dasar','Budi Hartanto','Penerbit Nusantara',2019,'Matematika'),
  ('BK006','9786231000066','Statistika untuk Sains Data','Ayu Permata','Graha Teknologi',2023,'Matematika'),
  ('BK007',NULL,'Sejarah Indonesia Modern','Tri Widodo','Pustaka Bangsa',2018,'Sejarah'),
  ('BK008',NULL,'Kumpulan Cerita Pendek Senja','Laras Ningrum','Pustaka Bangsa',2020,'Sastra'),
  ('BK009','9786231000097','Kebiasaan Belajar Efektif','Rizky Maulana','Cakrawala Media',2022,'Pengembangan Diri'),
  ('BK010','9786231000103','Rekayasa Perangkat Lunak','Fitri Handayani','Graha Teknologi',2024,'Pemrograman');

-- Eksemplar: status awal tersedia; status dipinjam diperbarui setelah detail peminjaman diisi
INSERT INTO eksemplar (kode_eksemplar, id_buku, kondisi_eksemplar, status_eksemplar) VALUES
  ('EK001',(SELECT id_buku FROM buku WHERE kode_buku='BK001'),'baik','tersedia'),
  ('EK002',(SELECT id_buku FROM buku WHERE kode_buku='BK001'),'baik','tersedia'),
  ('EK003',(SELECT id_buku FROM buku WHERE kode_buku='BK001'),'baik','tersedia'),
  ('EK004',(SELECT id_buku FROM buku WHERE kode_buku='BK002'),'baik','tersedia'),
  ('EK005',(SELECT id_buku FROM buku WHERE kode_buku='BK002'),'baik','tersedia'),
  ('EK006',(SELECT id_buku FROM buku WHERE kode_buku='BK002'),'baik','tersedia'),
  ('EK007',(SELECT id_buku FROM buku WHERE kode_buku='BK003'),'rusak','tersedia'),
  ('EK008',(SELECT id_buku FROM buku WHERE kode_buku='BK003'),'baik','tersedia'),
  ('EK009',(SELECT id_buku FROM buku WHERE kode_buku='BK004'),'baik','tersedia'),
  ('EK010',(SELECT id_buku FROM buku WHERE kode_buku='BK004'),'baik','tersedia'),
  ('EK011',(SELECT id_buku FROM buku WHERE kode_buku='BK004'),'baik','tersedia'),
  ('EK012',(SELECT id_buku FROM buku WHERE kode_buku='BK005'),'baik','tersedia'),
  ('EK013',(SELECT id_buku FROM buku WHERE kode_buku='BK005'),'baik','tersedia'),
  ('EK014',(SELECT id_buku FROM buku WHERE kode_buku='BK006'),'baik','tersedia'),
  ('EK015',(SELECT id_buku FROM buku WHERE kode_buku='BK006'),'baik','tersedia'),
  ('EK016',(SELECT id_buku FROM buku WHERE kode_buku='BK007'),'baik','tersedia'),
  ('EK017',(SELECT id_buku FROM buku WHERE kode_buku='BK007'),'baik','tersedia'),
  ('EK018',(SELECT id_buku FROM buku WHERE kode_buku='BK008'),'baik','tersedia'),
  ('EK019',(SELECT id_buku FROM buku WHERE kode_buku='BK008'),'rusak','tersedia'),
  ('EK020',(SELECT id_buku FROM buku WHERE kode_buku='BK009'),'baik','tersedia'),
  ('EK021',(SELECT id_buku FROM buku WHERE kode_buku='BK009'),'baik','tersedia'),
  ('EK022',(SELECT id_buku FROM buku WHERE kode_buku='BK009'),'baik','tersedia'),
  ('EK023',(SELECT id_buku FROM buku WHERE kode_buku='BK010'),'baik','tersedia'),
  ('EK024',(SELECT id_buku FROM buku WHERE kode_buku='BK010'),'baik','tersedia'),
  ('EK025',(SELECT id_buku FROM buku WHERE kode_buku='BK010'),'baik','tersedia');

-- ------------------------------------------------------------
-- 2. Peminjaman (60 baris, 10 x P)
-- ------------------------------------------------------------
INSERT INTO peminjaman (no_peminjaman, tanggal_pinjam, tanggal_jatuh_tempo, id_petugas, id_anggota) VALUES
  ('PJ-0001','2026-09-07','2026-09-14',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT004'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0001')),
  ('PJ-0002','2026-09-07','2026-09-14',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT005'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0005')),
  ('PJ-0003','2026-09-08','2026-09-15',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT002'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0005')),
  ('PJ-0004','2026-09-08','2026-09-15',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT001'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0010')),
  ('PJ-0005','2026-09-08','2026-09-15',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT004'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0005')),
  ('PJ-0006','2026-09-09','2026-09-16',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT002'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0001')),
  ('PJ-0007','2026-09-10','2026-09-17',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT004'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0003')),
  ('PJ-0008','2026-09-10','2026-09-17',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT003'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0005')),
  ('PJ-0009','2026-09-10','2026-09-17',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT004'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0003')),
  ('PJ-0010','2026-09-11','2026-09-18',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT005'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0005')),
  ('PJ-0011','2026-09-11','2026-09-18',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT002'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0008')),
  ('PJ-0012','2026-09-14','2026-09-21',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT002'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0008')),
  ('PJ-0013','2026-09-14','2026-09-21',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT004'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0003')),
  ('PJ-0014','2026-09-14','2026-09-21',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT002'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0010')),
  ('PJ-0015','2026-09-15','2026-09-22',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT003'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0009')),
  ('PJ-0016','2026-09-15','2026-09-22',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT003'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0009')),
  ('PJ-0017','2026-09-16','2026-09-23',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT005'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0010')),
  ('PJ-0018','2026-09-16','2026-09-23',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT004'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0009')),
  ('PJ-0019','2026-09-16','2026-09-23',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT005'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0001')),
  ('PJ-0020','2026-09-17','2026-09-24',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT003'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0009')),
  ('PJ-0021','2026-09-17','2026-09-24',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT002'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0004')),
  ('PJ-0022','2026-09-18','2026-09-25',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT002'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0006')),
  ('PJ-0023','2026-09-18','2026-09-25',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT005'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0004')),
  ('PJ-0024','2026-09-21','2026-09-28',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT003'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0010')),
  ('PJ-0025','2026-09-22','2026-09-29',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT002'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0002')),
  ('PJ-0026','2026-09-23','2026-09-30',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT004'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0002')),
  ('PJ-0027','2026-09-23','2026-09-30',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT001'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0010')),
  ('PJ-0028','2026-09-24','2026-10-01',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT002'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0010')),
  ('PJ-0029','2026-09-25','2026-10-02',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT001'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0006')),
  ('PJ-0030','2026-09-25','2026-10-02',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT004'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0006')),
  ('PJ-0031','2026-09-25','2026-10-02',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT003'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0006')),
  ('PJ-0032','2026-09-28','2026-10-05',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT005'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0009')),
  ('PJ-0033','2026-09-29','2026-10-06',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT004'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0006')),
  ('PJ-0034','2026-09-30','2026-10-07',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT005'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0002')),
  ('PJ-0035','2026-09-30','2026-10-07',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT003'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0006')),
  ('PJ-0036','2026-09-30','2026-10-07',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT005'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0001')),
  ('PJ-0037','2026-10-01','2026-10-08',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT003'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0005')),
  ('PJ-0038','2026-10-01','2026-10-08',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT001'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0004')),
  ('PJ-0039','2026-10-01','2026-10-08',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT001'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0005')),
  ('PJ-0040','2026-10-02','2026-10-09',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT003'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0003')),
  ('PJ-0041','2026-10-05','2026-10-12',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT004'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0009')),
  ('PJ-0042','2026-10-06','2026-10-13',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT003'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0006')),
  ('PJ-0043','2026-10-06','2026-10-13',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT005'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0006')),
  ('PJ-0044','2026-10-07','2026-10-14',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT002'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0006')),
  ('PJ-0045','2026-10-07','2026-10-14',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT004'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0009')),
  ('PJ-0046','2026-10-08','2026-10-15',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT003'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0010')),
  ('PJ-0047','2026-10-08','2026-10-15',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT001'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0007')),
  ('PJ-0048','2026-10-09','2026-10-16',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT005'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0006')),
  ('PJ-0049','2026-10-09','2026-10-16',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT003'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0002')),
  ('PJ-0050','2026-10-12','2026-10-19',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT001'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0001')),
  ('PJ-0051','2026-10-12','2026-10-19',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT004'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0002')),
  ('PJ-0052','2026-10-12','2026-10-19',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT001'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0002')),
  ('PJ-0053','2026-10-13','2026-10-20',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT003'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0003')),
  ('PJ-0054','2026-10-13','2026-10-20',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT001'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0007')),
  ('PJ-0055','2026-10-13','2026-10-20',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT003'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0007')),
  ('PJ-0056','2026-10-14','2026-10-21',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT002'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0008')),
  ('PJ-0057','2026-10-15','2026-10-22',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT001'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0002')),
  ('PJ-0058','2026-10-16','2026-10-23',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT004'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0006')),
  ('PJ-0059','2026-10-16','2026-10-23',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT003'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0005')),
  ('PJ-0060','2026-10-16','2026-10-23',(SELECT id_petugas FROM petugas WHERE kode_petugas='PT004'),(SELECT id_anggota FROM anggota WHERE no_anggota='AG-0010'));

-- ------------------------------------------------------------
-- 3. Detail peminjaman (tanggal_kembali kosong = masih aktif)
-- ------------------------------------------------------------
INSERT INTO detail_peminjaman (id_peminjaman, id_eksemplar, tanggal_kembali, status_peminjaman) VALUES
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0001'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK006'),'2026-09-13','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0002'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK016'),'2026-09-22','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0003'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK022'),'2026-09-20','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0004'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK011'),'2026-09-19','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0005'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK023'),'2026-09-15','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0006'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK005'),'2026-09-16','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0007'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK021'),'2026-09-12','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0007'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK018'),'2026-09-12','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0008'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK010'),'2026-09-15','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0009'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK020'),'2026-09-17','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0009'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK009'),'2026-09-17','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0010'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK015'),'2026-09-13','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0010'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK008'),'2026-09-13','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0010'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK001'),'2026-09-13','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0011'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK003'),'2026-09-18','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0011'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK012'),'2026-09-18','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0011'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK002'),'2026-09-18','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0012'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK021'),'2026-09-19','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0012'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK013'),'2026-09-19','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0013'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK024'),'2026-09-19','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0014'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK025'),'2026-09-16','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0014'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK004'),'2026-09-16','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0014'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK017'),'2026-09-16','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0015'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK015'),'2026-09-18','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0015'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK006'),'2026-09-18','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0016'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK014'),'2026-09-20','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0017'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK023'),'2026-09-30','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0018'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK008'),'2026-09-22','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0019'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK001'),'2026-09-28','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0020'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK004'),'2026-09-26','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0021'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK017'),'2026-09-22','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0021'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK010'),'2026-09-22','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0022'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK009'),'2026-09-21','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0022'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK025'),'2026-09-21','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0022'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK018'),'2026-09-21','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0023'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK020'),'2026-09-22','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0024'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK024'),'2026-09-28','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0025'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK006'),'2026-09-29','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0026'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK002'),'2026-09-30','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0027'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK016'),'2026-09-30','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0028'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK021'),'2026-09-27','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0028'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK018'),'2026-09-27','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0029'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK003'),'2026-09-28','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0029'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK017'),'2026-09-28','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0029'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK012'),'2026-09-28','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0030'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK009'),'2026-10-02','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0030'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK010'),'2026-10-02','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0031'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK025'),'2026-10-10','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0032'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK004'),'2026-10-01','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0033'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK013'),'2026-10-02','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0033'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK003'),'2026-10-02','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0034'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK015'),'2026-10-05','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0035'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK021'),'2026-10-12','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0036'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK012'),NULL,'aktif'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0036'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK005'),NULL,'aktif'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0036'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK011'),NULL,'aktif'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0037'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK002'),'2026-10-08','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0038'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK022'),'2026-10-06','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0039'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK014'),NULL,'aktif'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0039'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK006'),NULL,'aktif'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0040'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK018'),'2026-10-09','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0041'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK024'),'2026-10-07','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0042'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK008'),'2026-10-11','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0043'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK001'),'2026-10-12','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0043'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK017'),'2026-10-12','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0043'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK016'),'2026-10-12','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0044'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK022'),'2026-10-14','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0045'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK009'),'2026-10-10','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0045'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK015'),'2026-10-10','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0045'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK004'),'2026-10-10','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0046'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK010'),'2026-10-13','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0047'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK024'),'2026-10-13','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0048'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK020'),'2026-10-13','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0049'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK023'),'2026-10-14','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0050'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK013'),'2026-10-16','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0050'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK015'),'2026-10-16','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0050'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK002'),'2026-10-16','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0051'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK003'),'2026-10-17','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0052'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK025'),'2026-10-17','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0052'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK018'),'2026-10-17','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0053'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK016'),'2026-10-16','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0053'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK008'),'2026-10-16','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0054'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK001'),'2026-10-17','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0054'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK017'),'2026-10-17','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0054'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK021'),'2026-10-17','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0055'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK004'),'2026-10-16','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0055'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK009'),'2026-10-16','dikembalikan'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0056'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK020'),NULL,'aktif'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0057'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK023'),NULL,'aktif'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0058'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK010'),NULL,'aktif'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0059'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK022'),NULL,'aktif'),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0059'),(SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar='EK024'),NULL,'aktif');

-- Status eksemplar mengikuti detail peminjaman yang masih aktif (AB-06)
UPDATE eksemplar SET status_eksemplar = 'dipinjam'
WHERE id_eksemplar IN (SELECT id_eksemplar FROM detail_peminjaman WHERE status_peminjaman = 'aktif');

-- ------------------------------------------------------------
-- 4. Denda (hanya untuk pengembalian yang melewati jatuh tempo; AB-07, AB-08)
-- ------------------------------------------------------------
INSERT INTO denda (kode_denda, id_peminjaman, jumlah_hari_terlambat, jumlah_denda, status_pembayaran) VALUES
  ('DN001',(SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0002'),8,48000,'lunas'),
  ('DN002',(SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0003'),5,30000,'lunas'),
  ('DN003',(SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0004'),4,24000,'lunas'),
  ('DN004',(SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0017'),7,42000,'lunas'),
  ('DN005',(SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0019'),5,30000,'lunas'),
  ('DN006',(SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0020'),2,12000,'lunas'),
  ('DN007',(SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0031'),8,48000,'belum lunas'),
  ('DN008',(SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman='PJ-0035'),5,30000,'belum lunas');

-- ------------------------------------------------------------
-- 5. Jumlah baris per tabel (bukti untuk laporan)
-- ------------------------------------------------------------
SELECT 'petugas' AS tabel, COUNT(*) AS jumlah_baris FROM petugas
UNION ALL SELECT 'anggota', COUNT(*) FROM anggota
UNION ALL SELECT 'buku', COUNT(*) FROM buku
UNION ALL SELECT 'eksemplar', COUNT(*) FROM eksemplar
UNION ALL SELECT 'peminjaman', COUNT(*) FROM peminjaman
UNION ALL SELECT 'detail_peminjaman', COUNT(*) FROM detail_peminjaman
UNION ALL SELECT 'denda', COUNT(*) FROM denda;
