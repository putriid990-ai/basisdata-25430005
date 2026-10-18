-- ============================================================
-- p05_ddl_25430005.sql
-- Milestone Proyek 5 - DDL Perpustakaan Putri Dewi
-- Nama : Putri Nur Rahma Dewi | NIM : 25430005 | Kelas : A
-- Basis data : perpus_25430005
-- Dapat dijalankan ulang dari basis data kosong.
-- Tabel tidak diberi CHARACTER SET sendiri (mewarisi collation basis data).
--
-- Kode AB mengacu pada dokumen kebutuhan data P2 (p02_kebutuhan_data_25430005.md):
--   AB-01 nomor anggota unik                  AB-07 denda Rp6.000 per hari
--   AB-02 hanya anggota aktif boleh meminjam  AB-08 denda dicatat saat kembali lewat jatuh tempo
--   AB-03 satu judul punya banyak eksemplar   AB-09 satu eksemplar maks. satu peminjaman aktif
--   AB-04 eksemplar dipinjam tak boleh dipinjam orang lain
--   AB-05 maksimal 8 eksemplar per peminjaman AB-10/AB-11 hak akses (Pertemuan 13)
--   AB-06 status eksemplar Tersedia/Dipinjam
--
-- Aturan yang TIDAK dapat dijaga CHECK (melibatkan banyak baris atau tabel lain),
-- ditandai untuk Modul 14 (transaksi/trigger):
--   AB-02 status anggota aktif saat meminjam
--   AB-04 dan AB-09 satu peminjaman aktif per eksemplar
--   AB-05 maksimal 8 eksemplar per peminjaman (P + 2 = 8)
--   AB-06 sinkron status_eksemplar dengan detail_peminjaman (NFR-04)
--   AB-08 denda dibuat otomatis saat pengembalian terlambat
-- ============================================================

USE perpus_25430005;

-- ------------------------------------------------------------
-- 1. Hapus tabel lama: urutan ANAK -> INDUK
-- ------------------------------------------------------------
DROP TABLE IF EXISTS denda;
DROP TABLE IF EXISTS detail_peminjaman;
DROP TABLE IF EXISTS peminjaman;
DROP TABLE IF EXISTS eksemplar;
DROP TABLE IF EXISTS buku;
DROP TABLE IF EXISTS anggota;
DROP TABLE IF EXISTS petugas;

-- ------------------------------------------------------------
-- 2. Buat tabel: urutan INDUK -> ANAK
-- ------------------------------------------------------------

-- petugas (AB-10, AB-11: peran menentukan hak akses)
CREATE TABLE petugas (
  id_petugas        SMALLINT     NOT NULL AUTO_INCREMENT,
  kode_petugas      VARCHAR(10)  NOT NULL,
  nama_petugas      VARCHAR(100) NOT NULL,
  username_petugas  VARCHAR(30)  NOT NULL,
  peran_petugas     ENUM('petugas','administrator') NOT NULL DEFAULT 'petugas',  -- AB-11
  CONSTRAINT pk_petugas PRIMARY KEY (id_petugas),
  CONSTRAINT uq_petugas_kode     UNIQUE KEY (kode_petugas),
  CONSTRAINT uq_petugas_username UNIQUE KEY (username_petugas)
) ENGINE=InnoDB;

-- anggota (AB-01, AB-02)
CREATE TABLE anggota (
  id_anggota      INT          NOT NULL AUTO_INCREMENT,
  no_anggota      VARCHAR(10)  NOT NULL,                  -- contoh AG-0001
  nim_anggota     CHAR(8)      NOT NULL,
  nama_anggota    VARCHAR(100) NOT NULL,
  prodi_anggota   VARCHAR(60)  NOT NULL,
  no_hp_anggota   VARCHAR(15)  NULL,                      -- data pribadi (NFR-02)
  alamat_anggota  VARCHAR(200) NULL,                      -- data pribadi (NFR-02)
  status_anggota  ENUM('aktif','tidak aktif') NOT NULL DEFAULT 'aktif',  -- AB-02
  CONSTRAINT pk_anggota PRIMARY KEY (id_anggota),
  CONSTRAINT uq_anggota_no  UNIQUE KEY (no_anggota),      -- AB-01
  CONSTRAINT uq_anggota_nim UNIQUE KEY (nim_anggota)
) ENGINE=InnoDB;

-- buku (AB-03: satu judul, banyak eksemplar)
CREATE TABLE buku (
  id_buku        INT          NOT NULL AUTO_INCREMENT,
  kode_buku      VARCHAR(10)  NOT NULL,
  isbn           VARCHAR(13)  NULL,                       -- jika tersedia
  judul_buku     VARCHAR(150) NOT NULL,
  penulis_buku   VARCHAR(100) NOT NULL,
  penerbit_buku  VARCHAR(100) NOT NULL,
  tahun_terbit   SMALLINT     NOT NULL,
  kategori_buku  VARCHAR(50)  NOT NULL,
  CONSTRAINT pk_buku PRIMARY KEY (id_buku),
  CONSTRAINT uq_buku_kode UNIQUE KEY (kode_buku),
  CONSTRAINT uq_buku_isbn UNIQUE KEY (isbn),              -- NULL boleh berulang
  CONSTRAINT ck_buku_tahun CHECK (tahun_terbit BETWEEN 1900 AND 2100)  -- "tahun valid" (kamus data)
) ENGINE=InnoDB;

-- eksemplar (AB-03, AB-06)
CREATE TABLE eksemplar (
  id_eksemplar       INT         NOT NULL AUTO_INCREMENT,
  kode_eksemplar     VARCHAR(10) NOT NULL,
  id_buku            INT         NOT NULL,
  kondisi_eksemplar  ENUM('baik','rusak')         NOT NULL DEFAULT 'baik',
  status_eksemplar   ENUM('tersedia','dipinjam')  NOT NULL DEFAULT 'tersedia',   -- AB-06
  CONSTRAINT pk_eksemplar PRIMARY KEY (id_eksemplar),
  CONSTRAINT uq_eksemplar_kode UNIQUE KEY (kode_eksemplar),
  CONSTRAINT fk_eksemplar_buku FOREIGN KEY (id_buku)
    REFERENCES buku (id_buku) ON DELETE RESTRICT          -- AB-03; buku tidak boleh hilang jika punya eksemplar
) ENGINE=InnoDB;

-- peminjaman (kepala transaksi; AB-02, AB-10)
CREATE TABLE peminjaman (
  id_peminjaman        INT         NOT NULL AUTO_INCREMENT,
  no_peminjaman        VARCHAR(10) NOT NULL,              -- contoh PJ-0001
  tanggal_pinjam       DATE        NOT NULL,
  tanggal_jatuh_tempo  DATE        NOT NULL,
  id_petugas           SMALLINT    NOT NULL,
  id_anggota           INT         NOT NULL,
  CONSTRAINT pk_peminjaman PRIMARY KEY (id_peminjaman),
  CONSTRAINT uq_peminjaman_no UNIQUE KEY (no_peminjaman),
  CONSTRAINT fk_peminjaman_petugas FOREIGN KEY (id_petugas)
    REFERENCES petugas (id_petugas) ON DELETE RESTRICT,   -- NFR-01: riwayat tidak boleh hilang
  CONSTRAINT fk_peminjaman_anggota FOREIGN KEY (id_anggota)
    REFERENCES anggota (id_anggota) ON DELETE RESTRICT,   -- NFR-01
  CONSTRAINT ck_peminjaman_tempo CHECK (tanggal_jatuh_tempo >= tanggal_pinjam)  -- kamus data no. 20
) ENGINE=InnoDB;

-- detail_peminjaman (entitas asosiatif; AB-04, AB-09)
CREATE TABLE detail_peminjaman (
  id_peminjaman      INT  NOT NULL,
  id_eksemplar       INT  NOT NULL,
  tanggal_kembali    DATE NULL,                           -- diisi saat dikembalikan
  status_peminjaman  ENUM('aktif','dikembalikan') NOT NULL DEFAULT 'aktif',
  CONSTRAINT pk_detail_peminjaman PRIMARY KEY (id_peminjaman, id_eksemplar),
  CONSTRAINT fk_detail_peminjaman_peminjaman FOREIGN KEY (id_peminjaman)
    REFERENCES peminjaman (id_peminjaman) ON DELETE RESTRICT,  -- NFR-01
  CONSTRAINT fk_detail_peminjaman_eksemplar FOREIGN KEY (id_eksemplar)
    REFERENCES eksemplar (id_eksemplar) ON DELETE RESTRICT,
  -- Keputusan Modul 4: status_peminjaman disimpan, dijaga konsisten dengan tanggal_kembali
  CONSTRAINT ck_detail_peminjaman_status CHECK (
       (status_peminjaman = 'aktif'        AND tanggal_kembali IS NULL)
    OR (status_peminjaman = 'dikembalikan' AND tanggal_kembali IS NOT NULL)
  )
) ENGINE=InnoDB;

-- denda (AB-07, AB-08; NFR-05)
CREATE TABLE denda (
  id_denda               INT           NOT NULL AUTO_INCREMENT,
  kode_denda             VARCHAR(10)   NOT NULL,
  id_peminjaman          INT           NOT NULL,
  jumlah_hari_terlambat  INT           NOT NULL,
  jumlah_denda           DECIMAL(10,2) NOT NULL,
  status_pembayaran      ENUM('lunas','belum lunas') NOT NULL DEFAULT 'belum lunas',
  CONSTRAINT pk_denda PRIMARY KEY (id_denda),
  CONSTRAINT uq_denda_kode UNIQUE KEY (kode_denda),
  CONSTRAINT fk_denda_peminjaman FOREIGN KEY (id_peminjaman)
    REFERENCES peminjaman (id_peminjaman) ON DELETE RESTRICT,   -- NFR-01
  CONSTRAINT ck_denda_hari   CHECK (jumlah_hari_terlambat >= 0),
  -- AB-07: Rp6.000 x hari (nilai P = 6). Jika tarif berubah, constraint ini diperbarui lewat ALTER.
  CONSTRAINT ck_denda_jumlah CHECK (jumlah_denda = jumlah_hari_terlambat * 6000)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 3. Pemeriksaan
-- ------------------------------------------------------------
SHOW TABLES;
SHOW CREATE TABLE peminjaman;
SHOW CREATE TABLE detail_peminjaman;
SHOW CREATE TABLE denda;
