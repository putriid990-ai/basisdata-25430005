-- ============================================================
-- p06_data_kopma_25430005.sql
-- Pertemuan 6 - Data sampel Kopma (basis data kopma_123)
-- Nama : Putri Nur Rahma Dewi | NIM : 25430005 | Kelas : A
--
-- Cara menjalankan dari basis data kosong:
--   1. p05_ddl_kopma_25430005.sql   (membuat delapan tabel)
--   2. p06_data_kopma_25430005.sql  (berkas ini)
-- Urutan pengisian: induk dahulu, anak kemudian.
-- Kunci tamu diisi dengan INSERT ... SELECT / subkueri memakai kode alami,
-- sehingga tidak bergantung pada nilai AUTO_INCREMENT.
-- Aturan: AB-01 nota unik, AB-02 diskon anggota aktif, AB-03 stok >= 0,
--         AB-04 harga nota = harga saat transaksi, AB-05 NIM/no anggota unik.
-- ============================================================

USE kopma_123;

-- ------------------------------------------------------------
-- 1. Data induk
-- ------------------------------------------------------------
INSERT INTO petugas (kode_petugas, nama_petugas, peran_petugas) VALUES
  ('K01','Dimas','kasir'),
  ('K02','Sari','kasir'),
  ('K03','Rina','kasir'),
  ('G01','Joko','gudang'),
  ('P01','Ketua Kopma','ketua');

INSERT INTO barang (kode_barang, nama_barang, kategori_barang, harga_jual_barang, stok_barang, stok_min_barang) VALUES
  ('ATK-001','Pulpen Gel 0.5','ATK',4000,120,20),
  ('ATK-002','Buku Tulis 58','ATK',6500,80,20),
  ('MNM-001','Air Mineral 600','minuman',4000,48,24),
  ('MKN-001','Roti Cokelat','makanan',5000,6,10),
  ('ATK-003','Penggaris 30 cm','ATK',3500,40,10),
  ('MNM-002','Teh Botol 350','minuman',5000,36,12),
  ('MKN-002','Biskuit Gandum','makanan',7500,30,10),
  ('MKN-003','Wafer Cokelat','makanan',3000,60,15);

-- Anggota: tiga aktif, dua nonaktif (sebelum 2025), satu tanpa nomor HP (data pribadi boleh kosong)
INSERT INTO anggota (no_anggota, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, status_anggota, tgl_daftar_anggota) VALUES
  ('A-0457','2543010101','Nadia Rahmawati','Ilmu Komputer','081234560001','aktif','2025-08-18'),
  ('A-0458','2543010102','Fajar Nugroho','Teknik Informatika','081234560002','aktif','2025-09-02'),
  ('A-0459','2543010103','Salsabila Putri','Manajemen','081234560003','aktif','2026-01-12'),
  ('A-0460','2543010104','Bagas Wicaksono','Ilmu Komputer',NULL,'aktif','2026-02-03'),
  ('A-0301','2443010201','Hendra Saputra','Akuntansi','081234560005','nonaktif','2024-03-05'),
  ('A-0302','2443010202','Lestari Dewi','Pendidikan Matematika','081234560006','nonaktif','2024-08-20');

INSERT INTO pemasok (nama_pemasok, telepon_pemasok, alamat_pemasok) VALUES
  ('CV Sinar Alat Tulis','0721700101','Jl. Teuku Umar No. 12, Bandar Lampung'),
  ('UD Segar Makmur','0721700202','Jl. Kartini No. 45, Bandar Lampung'),
  ('PT Nusa Camilan','0721700303','Jl. Z.A. Pagar Alam No. 8, Bandar Lampung');

-- ------------------------------------------------------------
-- 2. Pembelian dari pemasok (stok awal sudah memuat faktur FK-0917 yang diterima)
-- ------------------------------------------------------------
INSERT INTO pembelian (no_faktur_pembelian, tgl_pembelian, id_pemasok, id_petugas, status_pembelian) VALUES
  ('FK-0917','2026-09-10',(SELECT id_pemasok FROM pemasok WHERE nama_pemasok='CV Sinar Alat Tulis'),(SELECT id_petugas FROM petugas WHERE kode_petugas='G01'),'diterima'),
  ('FK-0921','2026-09-26',(SELECT id_pemasok FROM pemasok WHERE nama_pemasok='UD Segar Makmur'),(SELECT id_petugas FROM petugas WHERE kode_petugas='G01'),'dipesan');

INSERT INTO detail_pembelian (id_pembelian, id_barang, qty_detail_pembelian, harga_beli_detail_pembelian)
SELECT p.id_pembelian, b.id_barang, 100, 2800 FROM pembelian p, barang b WHERE p.no_faktur_pembelian='FK-0917' AND b.kode_barang='ATK-001';
INSERT INTO detail_pembelian (id_pembelian, id_barang, qty_detail_pembelian, harga_beli_detail_pembelian)
SELECT p.id_pembelian, b.id_barang, 60, 4500 FROM pembelian p, barang b WHERE p.no_faktur_pembelian='FK-0917' AND b.kode_barang='ATK-002';
INSERT INTO detail_pembelian (id_pembelian, id_barang, qty_detail_pembelian, harga_beli_detail_pembelian)
SELECT p.id_pembelian, b.id_barang, 40, 2400 FROM pembelian p, barang b WHERE p.no_faktur_pembelian='FK-0917' AND b.kode_barang='ATK-003';
INSERT INTO detail_pembelian (id_pembelian, id_barang, qty_detail_pembelian, harga_beli_detail_pembelian)
SELECT p.id_pembelian, b.id_barang, 48, 3500 FROM pembelian p, barang b WHERE p.no_faktur_pembelian='FK-0921' AND b.kode_barang='MKN-001';
INSERT INTO detail_pembelian (id_pembelian, id_barang, qty_detail_pembelian, harga_beli_detail_pembelian)
SELECT p.id_pembelian, b.id_barang, 24, 2600 FROM pembelian p, barang b WHERE p.no_faktur_pembelian='FK-0921' AND b.kode_barang='MNM-001';

-- ------------------------------------------------------------
-- 3. Nota penjualan. Harga satuan disalin dari harga_jual_barang saat itu (AB-04)
-- ------------------------------------------------------------
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
VALUES ('PJ-2609-0131','2026-09-12 14:20:00',(SELECT id_petugas FROM petugas WHERE kode_petugas='K03'),(SELECT id_anggota FROM anggota WHERE no_anggota='A-0302'),10000);
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT p.id_penjualan, b.id_barang, 1, b.harga_jual_barang FROM penjualan p, barang b WHERE p.no_nota_penjualan='PJ-2609-0131' AND b.kode_barang='ATK-001';
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT p.id_penjualan, b.id_barang, 1, b.harga_jual_barang FROM penjualan p, barang b WHERE p.no_nota_penjualan='PJ-2609-0131' AND b.kode_barang='MNM-001';
UPDATE barang SET stok_barang = stok_barang - 1 WHERE kode_barang='ATK-001';
UPDATE barang SET stok_barang = stok_barang - 1 WHERE kode_barang='MNM-001';

INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
VALUES ('PJ-2609-0142','2026-09-24 10:15:00',(SELECT id_petugas FROM petugas WHERE kode_petugas='K03'),(SELECT id_anggota FROM anggota WHERE no_anggota='A-0457'),30000);
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT p.id_penjualan, b.id_barang, 3, b.harga_jual_barang FROM penjualan p, barang b WHERE p.no_nota_penjualan='PJ-2609-0142' AND b.kode_barang='ATK-001';
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT p.id_penjualan, b.id_barang, 2, b.harga_jual_barang FROM penjualan p, barang b WHERE p.no_nota_penjualan='PJ-2609-0142' AND b.kode_barang='ATK-002';
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT p.id_penjualan, b.id_barang, 1, b.harga_jual_barang FROM penjualan p, barang b WHERE p.no_nota_penjualan='PJ-2609-0142' AND b.kode_barang='MNM-001';
UPDATE barang SET stok_barang = stok_barang - 3 WHERE kode_barang='ATK-001';
UPDATE barang SET stok_barang = stok_barang - 2 WHERE kode_barang='ATK-002';
UPDATE barang SET stok_barang = stok_barang - 1 WHERE kode_barang='MNM-001';

INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
VALUES ('PJ-2609-0143','2026-09-24 11:40:00',(SELECT id_petugas FROM petugas WHERE kode_petugas='K01'),NULL,15000);
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT p.id_penjualan, b.id_barang, 2, b.harga_jual_barang FROM penjualan p, barang b WHERE p.no_nota_penjualan='PJ-2609-0143' AND b.kode_barang='ATK-001';
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT p.id_penjualan, b.id_barang, 1, b.harga_jual_barang FROM penjualan p, barang b WHERE p.no_nota_penjualan='PJ-2609-0143' AND b.kode_barang='MKN-001';
UPDATE barang SET stok_barang = stok_barang - 2 WHERE kode_barang='ATK-001';
UPDATE barang SET stok_barang = stok_barang - 1 WHERE kode_barang='MKN-001';

INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
VALUES ('PJ-2609-0144','2026-09-25 09:05:00',(SELECT id_petugas FROM petugas WHERE kode_petugas='K02'),(SELECT id_anggota FROM anggota WHERE no_anggota='A-0458'),35000);
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT p.id_penjualan, b.id_barang, 3, b.harga_jual_barang FROM penjualan p, barang b WHERE p.no_nota_penjualan='PJ-2609-0144' AND b.kode_barang='ATK-002';
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT p.id_penjualan, b.id_barang, 2, b.harga_jual_barang FROM penjualan p, barang b WHERE p.no_nota_penjualan='PJ-2609-0144' AND b.kode_barang='MNM-001';
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT p.id_penjualan, b.id_barang, 1, b.harga_jual_barang FROM penjualan p, barang b WHERE p.no_nota_penjualan='PJ-2609-0144' AND b.kode_barang='MKN-002';
UPDATE barang SET stok_barang = stok_barang - 3 WHERE kode_barang='ATK-002';
UPDATE barang SET stok_barang = stok_barang - 2 WHERE kode_barang='MNM-001';
UPDATE barang SET stok_barang = stok_barang - 1 WHERE kode_barang='MKN-002';

-- ------------------------------------------------------------
-- 4. Jumlah baris per tabel (bukti untuk laporan)
-- ------------------------------------------------------------
SELECT 'petugas' AS tabel, COUNT(*) AS jumlah_baris FROM petugas
UNION ALL SELECT 'anggota', COUNT(*) FROM anggota
UNION ALL SELECT 'barang', COUNT(*) FROM barang
UNION ALL SELECT 'pemasok', COUNT(*) FROM pemasok
UNION ALL SELECT 'penjualan', COUNT(*) FROM penjualan
UNION ALL SELECT 'detail_penjualan', COUNT(*) FROM detail_penjualan
UNION ALL SELECT 'pembelian', COUNT(*) FROM pembelian
UNION ALL SELECT 'detail_pembelian', COUNT(*) FROM detail_pembelian;
