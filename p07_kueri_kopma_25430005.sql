-- ============================================================
-- p07_kueri_kopma_25430005.sql
-- Pertemuan 7 - Kueri SELECT Kopma (basis data kopma_123)
-- Nama : Putri Nur Rahma Dewi | NIM : 25430005 | Kelas : A
--
-- PRASYARAT: jalankan dari keadaan awal Modul 6, yaitu
--   p05_ddl_kopma_25430005.sql lalu p06_data_kopma_25430005.sql.
-- Hasil yang diharapkan di bawah dihitung dari data itu. Jika data sudah diubah
-- oleh uji atau latihan Modul 6, reset dulu agar hasilnya sama.
-- Jalankan kueri SATU PER SATU di tab SQL phpMyAdmin.
-- Aturan: setiap kueri ditulis dengan pertanyaan dan hasil yang diharapkan
-- SEBELUM dijalankan. Setelah dijalankan, isi baris 'Hasil nyata'.
-- ============================================================

USE kopma_123;

-- ----------------------------------------------------------------
-- K-01 | KI-03
-- Pertanyaan : Barang apa yang stoknya sudah di bawah stok minimum dan perlu dipesan ulang?
-- Hasil yang diharapkan (diprediksi sebelum dijalankan): 1 baris
--   kode_barang | nama_barang | stok_barang | stok_min_barang | kurang
--   MKN-001 | Roti Cokelat | 5 | 10 | 5
-- Hasil nyata  : (isi setelah dijalankan; tulis 'sama' atau jelaskan perbedaannya)

SELECT kode_barang, nama_barang, stok_barang, stok_min_barang,
       stok_min_barang - stok_barang AS kurang
FROM barang
WHERE stok_barang < stok_min_barang
ORDER BY kurang DESC;

-- ----------------------------------------------------------------
-- K-02 | Tambahan
-- Pertanyaan : Barang apa saja yang termasuk kategori ATK atau minuman?
-- Hasil yang diharapkan (diprediksi sebelum dijalankan): 5 baris
--   kode_barang | nama_barang | kategori_barang | harga_jual_barang
--   ATK-001 | Pulpen Gel 0.5 | ATK | 4000.00
--   ATK-002 | Buku Tulis 58 | ATK | 6500.00
--   ATK-003 | Penggaris 30 cm | ATK | 3500.00
--   MNM-001 | Air Mineral 600 | minuman | 4000.00
--   MNM-002 | Teh Botol 350 | minuman | 5000.00
-- Hasil nyata  : (isi setelah dijalankan; tulis 'sama' atau jelaskan perbedaannya)

SELECT kode_barang, nama_barang, kategori_barang, harga_jual_barang
FROM barang
WHERE kategori_barang IN ('ATK', 'minuman')
ORDER BY kategori_barang, kode_barang;

-- ----------------------------------------------------------------
-- K-03 | KI-01
-- Pertanyaan : Nota mana saja yang tercatat pada 24 dan 25 September 2026?
-- Hasil yang diharapkan (diprediksi sebelum dijalankan): 3 baris
--   no_nota_penjualan | tgl_penjualan | bayar_penjualan
--   PJ-2609-0142 | 2026-09-24 10:15:00 | 30000.00
--   PJ-2609-0143 | 2026-09-24 11:40:00 | 15000.00
--   PJ-2609-0144 | 2026-09-25 09:05:00 | 35000.00
-- Catatan      : Untuk kolom DATETIME, BETWEEN '2026-09-24' AND '2026-09-25' akan melewatkan nota tanggal 25 yang berjam > 00:00 (lihat Troubleshooting Masalah 2).
-- Hasil nyata  : (isi setelah dijalankan; tulis 'sama' atau jelaskan perbedaannya)

SELECT no_nota_penjualan, tgl_penjualan, bayar_penjualan
FROM penjualan
WHERE tgl_penjualan BETWEEN '2026-09-24 00:00:00' AND '2026-09-25 23:59:59'
ORDER BY tgl_penjualan;

-- ----------------------------------------------------------------
-- K-04 | Tambahan
-- Pertanyaan : Anggota mana yang belum mengisi nomor HP?
-- Hasil yang diharapkan (diprediksi sebelum dijalankan): 1 baris
--   no_anggota | nama_anggota | no_hp_anggota
--   A-0460 | Bagas Wicaksono | NULL
-- Hasil nyata  : (isi setelah dijalankan; tulis 'sama' atau jelaskan perbedaannya)

SELECT no_anggota, nama_anggota, no_hp_anggota
FROM anggota
WHERE no_hp_anggota IS NULL;

-- ----------------------------------------------------------------
-- K-05 | Tambahan
-- Pertanyaan : Lima anggota terbaru yang namanya mengandung huruf a, dengan label dan keterangan diskon.
-- Hasil yang diharapkan (diprediksi sebelum dijalankan): 5 baris
--   anggota | tgl_daftar | hp | keterangan
--   Bagas Wicaksono (A-0460) | 03-02-2026 | - | Diskon 5%
--   Salsabila Putri (A-0459) | 12-01-2026 | 081234560003 | Diskon 5%
--   Fajar Nugroho (A-0458) | 02-09-2025 | 081234560002 | Diskon 5%
--   Nadia Rahmawati (A-0457) | 18-08-2025 | 081234560001 | Diskon 5%
--   Lestari Dewi (A-0302) | 20-08-2024 | 081234560006 | Tanpa diskon
-- Catatan      : Alias dan kolom bernama sama (tgl_daftar_anggota) berisiko: ORDER BY lebih dulu mencari alias, sehingga urutan bisa memakai teks 'dd-mm-yyyy'. Lihat K-E3.
-- Hasil nyata  : (isi setelah dijalankan; tulis 'sama' atau jelaskan perbedaannya)

-- alias tanggal memakai nama tgl_daftar (bukan tgl_daftar_anggota) agar ORDER BY
-- mengurutkan berdasarkan kolom tanggal asli, bukan teks hasil DATE_FORMAT
SELECT CONCAT(nama_anggota, ' (', no_anggota, ')')      AS anggota,
       DATE_FORMAT(tgl_daftar_anggota, '%d-%m-%Y')        AS tgl_daftar,
       IFNULL(no_hp_anggota, '-')                         AS hp,
       CASE status_anggota WHEN 'aktif' THEN 'Diskon 5%'
                           ELSE 'Tanpa diskon' END        AS keterangan
FROM anggota
WHERE nama_anggota LIKE '%a%'
ORDER BY tgl_daftar_anggota DESC
LIMIT 5;

-- ----------------------------------------------------------------
-- K-06 | Tambahan
-- Pertanyaan : Sudah berapa hari tiap anggota terdaftar (acuan 31 Oktober 2026), dan apakah tergolong baru (< 180 hari) atau lama?
-- Hasil yang diharapkan (diprediksi sebelum dijalankan): 6 baris
--   no_anggota | nama_anggota | tgl_daftar_anggota | lama_hari | kategori
--   A-0460 | Bagas Wicaksono | 2026-02-03 | 270 | lama
--   A-0459 | Salsabila Putri | 2026-01-12 | 292 | lama
--   A-0458 | Fajar Nugroho | 2025-09-02 | 424 | lama
--   A-0457 | Nadia Rahmawati | 2025-08-18 | 439 | lama
--   A-0302 | Lestari Dewi | 2024-08-20 | 802 | lama
--   A-0301 | Hendra Saputra | 2024-03-05 | 970 | lama
-- Hasil nyata  : (isi setelah dijalankan; tulis 'sama' atau jelaskan perbedaannya)

-- tanggal acuan ditulis tetap agar hasilnya dapat diprediksi; ganti dengan CURDATE() untuk hari ini
SELECT no_anggota, nama_anggota, tgl_daftar_anggota,
       DATEDIFF('2026-10-31', tgl_daftar_anggota) AS lama_hari,
       IF(DATEDIFF('2026-10-31', tgl_daftar_anggota) < 180, 'baru', 'lama') AS kategori
FROM anggota
ORDER BY lama_hari, no_anggota;

-- ----------------------------------------------------------------
-- K-07 | KI-01
-- Pertanyaan : Apa saja baris detail nota PJ-2609-0142 dan berapa subtotal tiap barisnya?
-- Hasil yang diharapkan (diprediksi sebelum dijalankan): 3 baris
--   id_barang | qty_detail_penjualan | harga_satuan_detail_penjualan | subtotal
--   1 | 3 | 4000.00 | 12000.00
--   2 | 2 | 6500.00 | 13000.00
--   3 | 1 | 4000.00 | 4000.00
-- Catatan      : Jumlah manual subtotal = 29000.00 (12000.00 + 13000.00 + 4000.00). Bandingkan dengan nota di Modul 2.
-- Hasil nyata  : (isi setelah dijalankan; tulis 'sama' atau jelaskan perbedaannya)

-- cek dulu id nota: SELECT id_penjualan FROM penjualan WHERE no_nota_penjualan = 'PJ-2609-0142';
SELECT id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan,
       qty_detail_penjualan * harga_satuan_detail_penjualan AS subtotal
FROM detail_penjualan
WHERE id_penjualan = 2
ORDER BY id_barang;

-- ----------------------------------------------------------------
-- K-E1 | Latihan E1
-- Pertanyaan : Tampilkan nama barang huruf kapital dan harga dalam format Rp4.000.
-- Hasil yang diharapkan (diprediksi sebelum dijalankan): 8 baris
--   nama | harga
--   PULPEN GEL 0.5 | Rp4.000
--   BUKU TULIS 58 | Rp6.500
--   PENGGARIS 30 CM | Rp3.500
--   ROTI COKELAT | Rp5.000
--   BISKUIT GANDUM | Rp7.500
--   WAFER COKELAT | Rp3.000
--   AIR MINERAL 600 | Rp4.000
--   TEH BOTOL 350 | Rp5.000
-- Hasil nyata  : (isi setelah dijalankan; tulis 'sama' atau jelaskan perbedaannya)

SELECT UPPER(nama_barang) AS nama,
       CONCAT('Rp', FORMAT(harga_jual_barang, 0, 'id_ID')) AS harga
FROM barang
ORDER BY kode_barang;

-- ----------------------------------------------------------------
-- K-E2a | Latihan E2 (salah)
-- Pertanyaan : Barang ATK atau minuman yang stoknya kurang dari 40? (versi salah: OR tanpa kurung)
-- Hasil yang diharapkan (diprediksi sebelum dijalankan): 4 baris
--   kode_barang | kategori_barang | stok_barang
--   ATK-001 | ATK | 114
--   ATK-002 | ATK | 75
--   ATK-003 | ATK | 40
--   MNM-002 | minuman | 36
-- Catatan      : Berjalan tanpa galat, tetapi AND dievaluasi lebih dulu daripada OR sehingga semua ATK ikut tampil.
-- Hasil nyata  : (isi setelah dijalankan; tulis 'sama' atau jelaskan perbedaannya)

SELECT kode_barang, kategori_barang, stok_barang
FROM barang
WHERE kategori_barang = 'ATK' OR kategori_barang = 'minuman' AND stok_barang < 40
ORDER BY kode_barang;

-- ----------------------------------------------------------------
-- K-E2b | Latihan E2 (benar)
-- Pertanyaan : Barang ATK atau minuman yang stoknya kurang dari 40? (versi benar: pakai kurung)
-- Hasil yang diharapkan (diprediksi sebelum dijalankan): 1 baris
--   kode_barang | kategori_barang | stok_barang
--   MNM-002 | minuman | 36
-- Hasil nyata  : (isi setelah dijalankan; tulis 'sama' atau jelaskan perbedaannya)

SELECT kode_barang, kategori_barang, stok_barang
FROM barang
WHERE (kategori_barang = 'ATK' OR kategori_barang = 'minuman') AND stok_barang < 40
ORDER BY kode_barang;

-- ------------------------------------------------------------
-- TITIK ANALISIS (kueri yang sengaja salah; buka komentar satu per satu untuk mencoba)
-- ------------------------------------------------------------

-- TA-1: alias kolom tidak dikenal di WHERE (urutan evaluasi: FROM -> WHERE -> SELECT -> ORDER BY)
-- Prediksi: ERROR 1054 - Unknown column 'kurang' in 'where clause'
-- SELECT kode_barang, stok_min_barang - stok_barang AS kurang
-- FROM barang
-- WHERE kurang > 0;

-- TA-1 (perbaikan, setara tanpa alias): ulangi ekspresinya di WHERE
-- Prediksi: 1 baris (MKN-001, kurang 5)
-- SELECT kode_barang, stok_min_barang - stok_barang AS kurang
-- FROM barang
-- WHERE stok_min_barang - stok_barang > 0;

-- TA-2: membandingkan dengan NULL memakai '=' tidak pernah benar (hasilnya UNKNOWN, bukan TRUE)
-- Prediksi: 0 baris, padahal ada anggota tanpa nomor HP (A-0460)
-- SELECT no_anggota, nama_anggota FROM anggota WHERE no_hp_anggota = NULL;

-- TA-2 (benar): IS NULL
-- Prediksi: 1 baris (A-0460)
-- SELECT no_anggota, nama_anggota FROM anggota WHERE no_hp_anggota IS NULL;

-- K-E3: ORDER BY pada alias yang sama dengan nama kolom (uji hipotesis)
-- Hipotesis: ORDER BY mencari alias lebih dulu, sehingga mengurutkan teks 'dd-mm-yyyy', bukan tanggal.
-- Jalankan lalu bandingkan urutannya dengan K-05; catat hasil nyatanya.
-- SELECT no_anggota, DATE_FORMAT(tgl_daftar_anggota, '%d-%m-%Y') AS tgl_daftar_anggota
-- FROM anggota
-- ORDER BY tgl_daftar_anggota DESC
-- LIMIT 5;
