# Normalisasi Kopma - Pertemuan 4

- Nama: Putri Nur Rahma Dewi
- NIM: 25430005
- Kelas: A
- Mata Kuliah: Basis Data (Semester 3)

Catatan penulisan: kunci primer ditandai **tebal**, kunci tamu ditandai `*`.

---

## 1. Dari UNF ke 1NF

### 1.1 Bentuk UNF

Satu nota menyimpan grup berulang barang (di dalam `{ }`).

```
NOTA_UNF (no_nota_penjualan, tgl_penjualan, kode_petugas, nama_petugas,
          no_anggota, nama_anggota,
          { kode_barang, nama_barang, qty_detail_penjualan,
            harga_satuan_detail_penjualan, subtotal_detail_penjualan },
          jumlah_penjualan, diskon_penjualan, total_penjualan)
```

### 1.2 Bentuk 1NF

Grup berulang dihilangkan: satu baris untuk setiap barang di setiap nota.
Kunci primer menjadi komposit **(no_nota_penjualan, kode_barang)**.

NOTA_1NF (**no_nota_penjualan**, **kode_barang**, tgl_penjualan, kode_petugas, nama_petugas, no_anggota, nama_anggota, nama_barang, qty_detail_penjualan, harga_satuan_detail_penjualan, subtotal_detail_penjualan, jumlah_penjualan, diskon_penjualan, total_penjualan)

---

## 2. Dependensi Fungsional

Diturunkan dari aturan bisnis Pertemuan 2, bukan dari isi spreadsheet.

| Kode | Dependensi Fungsional | Dasar |
|---|---|---|
| FD1 | no_nota_penjualan -> tgl_penjualan, kode_petugas, no_anggota | AB-01 |
| FD2 | kode_petugas -> nama_petugas | satu kode petugas, satu nama |
| FD3 | no_anggota -> nama_anggota | AB-05 |
| FD4 | kode_barang -> nama_barang | satu kode barang, satu nama |
| FD5 | (no_nota_penjualan, kode_barang) -> qty_detail_penjualan, harga_satuan_detail_penjualan | AB-04 |
| FD6 | qty_detail_penjualan, harga_satuan_detail_penjualan -> subtotal_detail_penjualan | nilai turunan |

---

## 3. Menuju 2NF

FD1 dan FD4 hanya bergantung pada sebagian kunci komposit, sehingga dipisah:

- `penjualan` dengan kunci no_nota_penjualan (FD1)
- `barang` dengan kunci kode_barang (FD4)
- sisanya menjadi `detail_penjualan` dengan kunci (no_nota_penjualan, kode_barang) (FD5)

PENJUALAN_2NF (**no_nota_penjualan**, tgl_penjualan, kode_petugas, nama_petugas, no_anggota, nama_anggota, jumlah_penjualan, diskon_penjualan, total_penjualan)

DETAIL_PENJUALAN (**no_nota_penjualan**\*, **kode_barang**\*, qty_detail_penjualan, harga_satuan_detail_penjualan, subtotal_detail_penjualan)

BARANG (**kode_barang**, nama_barang)

## 4. Menuju 3NF

Pada `penjualan` ada dua rantai transitif:

- no_nota_penjualan -> kode_petugas -> nama_petugas
- no_nota_penjualan -> no_anggota -> nama_anggota

Maka `petugas` dan `anggota` dipisah menjadi relasi sendiri.

## 5. Keputusan Nilai Turunan

`subtotal_detail_penjualan`, `jumlah_penjualan`, dan `total_penjualan` dapat dihitung dari detail dan status anggota. Nilai-nilai ini **tidak disimpan** di tabel operasional agar tidak mungkin tidak konsisten dengan data detail.

## 6. Hasil Akhir 3NF

PENJUALAN (**no_nota_penjualan**, tgl_penjualan, kode_petugas\*, no_anggota\*, bayar_penjualan)

DETAIL_PENJUALAN (**no_nota_penjualan**\*, **kode_barang**\*, qty_detail_penjualan, harga_satuan_detail_penjualan)

BARANG (**kode_barang**, nama_barang, kategori_barang, harga_jual_barang, stok_barang, stok_min_barang)

PETUGAS (**kode_petugas**, nama_petugas, peran_petugas)

ANGGOTA (**no_anggota**, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, status_anggota, tgl_daftar_anggota)

### Tabel tahapan

| Tahap | Relasi | Masalah yang dihilangkan |
|---|---|---|
| UNF | NOTA_UNF | grup berulang barang dalam satu nota |
| 1NF | NOTA_1NF | atribut bergantung sebagian kunci, redundansi nama |
| 2NF | PENJUALAN_2NF, DETAIL_PENJUALAN, BARANG | nama petugas dan anggota masih berantai |
| 3NF | PENJUALAN, DETAIL_PENJUALAN, BARANG, PETUGAS, ANGGOTA | rantai transitif |

---

## 7. Pencocokan dengan Skema Kanonik (Tabel 4.2)

Perbedaan utama dengan hasil di atas adalah **kunci pengganti (surrogate key)** `id_*` sebagai kunci primer, sedangkan kode alami seperti `no_nota_penjualan` menjadi kunci unik.

| Tabel | Kunci primer | Kunci unik | Kunci tamu |
|---|---|---|---|
| petugas | id_petugas | kode_petugas | - |
| anggota | id_anggota | no_anggota, nim_anggota | - |
| barang | id_barang | kode_barang | - |
| pemasok | id_pemasok | - | - |
| penjualan | id_penjualan | no_nota_penjualan | id_petugas, id_anggota (boleh NULL) |
| detail_penjualan | (id_penjualan, id_barang) | - | id_penjualan, id_barang |
| pembelian | id_pembelian | (cek Tabel 4.2 di buku) | id_pemasok |
| detail_pembelian | (id_pembelian, id_barang) | - | id_pembelian, id_barang |

Tabel `pemasok`, `pembelian`, dan `detail_pembelian` muncul di skema kanonik karena spreadsheet lama juga memuat data pemasok (lihat Titik Analisis 3).

## 8. Pemeriksaan BCNF

| Tabel | Penentu | Kunci kandidat? | Hasil |
|---|---|---|---|
| penjualan | no_nota_penjualan | ya | BCNF |
| detail_penjualan | (no_nota_penjualan, kode_barang) | ya | BCNF |
| barang | kode_barang | ya | BCNF |
| petugas | kode_petugas | ya | BCNF |
| anggota | no_anggota, nim_anggota | ya, keduanya kunci kandidat | BCNF |

Tidak ditemukan penentu yang bukan kunci kandidat, sehingga semua tabel memenuhi BCNF.

---

## 9. Titik Analisis

**Titik Analisis 1.** FD5 menempatkan harga satuan pada kunci (no_nota_penjualan, kode_barang) karena AB-04 menyatakan harga di nota dapat berbeda dari harga barang saat ini. Harga tersebut adalah harga saat transaksi. Jika dipindah ke tabel barang, perubahan harga hari ini akan mengubah nilai transaksi lama, sehingga laporan omzet tahun lalu ikut berubah.

**Titik Analisis 2.** Pada tabel operasional, data masih dapat berubah, sehingga total dihitung agar selalu konsisten dengan detailnya. Tabel arsip adalah potret historis yang tidak boleh berubah, sehingga total sengaja disimpan. Dua keputusan itu konsisten karena tujuannya sama, yaitu menjaga angka tetap benar pada konteksnya masing-masing.

**Titik Analisis 3.** Informasi "barang ini dipasok oleh siapa" kini disimpan melalui `pembelian` (memuat id_pemasok) dan `detail_pembelian` (memuat id_barang). Keuntungannya: satu barang dapat dipasok oleh banyak pemasok, riwayat pembelian tiap pemasok tercatat, dan nama pemasok hanya disimpan sekali sehingga tidak ada ejaan yang berubah-ubah.

---

## 10. Latihan dan Modifikasi

### Latihan 1: Beberapa nomor telepon pemasok

Satu pemasok dapat memiliki banyak nomor telepon. Jika disimpan sebagai daftar di satu kolom, melanggar 1NF. Maka dibuat relasi baru:

```
TELEPON_PEMASOK (id_telepon_pemasok, id_pemasok*, no_telepon_pemasok)
UNIQUE (id_pemasok, no_telepon_pemasok)
```

### Latihan 2: Contoh pelanggaran 3NF

Misalkan `nama_anggota` disimpan di tabel penjualan:

```
PENJUALAN_SALAH (no_nota_penjualan, tgl_penjualan, no_anggota, nama_anggota)
```

| no_nota_penjualan | tgl_penjualan | no_anggota | nama_anggota |
|---|---|---|---|
| N-001 | 2026-10-01 | A-01 | Budi Santoso |
| N-002 | 2026-10-02 | A-01 | Budi Santoso |
| N-003 | 2026-10-03 | A-01 | Budi Santoso |

Pelanggarannya: no_nota_penjualan -> no_anggota -> nama_anggota (rantai transitif, nama_anggota bergantung pada atribut bukan kunci).

Kueri ubah yang memperlihatkan anomali ubah:

```sql
UPDATE penjualan_salah
SET nama_anggota = 'Budi S. Santoso'
WHERE no_nota_penjualan = 'N-001';

SELECT DISTINCT no_anggota, nama_anggota
FROM penjualan_salah
WHERE no_anggota = 'A-01';
```

Hasilnya: anggota A-01 muncul dengan dua nama berbeda, padahal satu anggota seharusnya hanya punya satu nama.
