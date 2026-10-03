-- Praktikum Basis Data - Modul 1
-- Nama : Putri Nur Rahma Dewi
-- NIM  : 25430005
-- Kelas: A

-- Database utama praktikum
CREATE DATABASE IF NOT EXISTS kopma_123;

-- Menggunakan database
USE kopma_123;

-- Tabel contoh untuk pengujian idempotensi
CREATE TABLE IF NOT EXISTS produk (
    id INT PRIMARY KEY,
    nama VARCHAR(100)
);

-- Catatan:
-- User mhs_123 memiliki akses pada kopma_123.
-- User tamu_123 hanya memiliki hak SELECT pada kopma_123.
-- Database proyek individu: perpus_25430005