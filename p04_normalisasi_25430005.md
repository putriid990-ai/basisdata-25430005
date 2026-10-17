# Normalisasi Proyek Perpustakaan - Milestone Proyek 4

- Nama: Putri Nur Rahma Dewi
- NIM: 25430005
- Kelas: A
- Database: `perpus_25430005`
- Tema Proyek: Perpustakaan Putri Dewi

Catatan penulisan: kunci primer ditandai **tebal**, kunci tamu ditandai `*`.

---

## 1. Dokumen Sumber

Dokumen sumber yang dipakai sebagai titik awal UNF adalah **Slip Peminjaman Perpustakaan Putri Dewi** (Pertemuan 2, bagian 11).

| Kolom pada slip | Contoh |
|---|---|
| Nomor Peminjaman | PJ-0001 |
| Tanggal Pinjam | 03-10-2026 |
| Nomor Anggota | AG-0001 |
| Nama Anggota | Putri Nur Rahma Dewi |
| Kode Eksemplar | EK001 |
| Judul Buku | Basis Data Dasar |
| Tanggal Jatuh Tempo | 10-10-2026 |
| Kode Petugas | PT001 |

Satu slip dapat memuat beberapa eksemplar (maksimal 8 per transaksi, AB-05), sehingga eksemplar menjadi grup berulang.

---

## 2. Tahapan UNF ke 1NF

### 2.1 UNF

```
PEMINJAMAN_UNF (no_peminjaman, tanggal_pinjam, tanggal_jatuh_tempo,
                no_anggota, nim_anggota, nama_anggota, prodi_anggota,
                no_hp_anggota, alamat_anggota, status_anggota,
                kode_petugas, nama_petugas, username_petugas, peran_petugas,
                { kode_eksemplar, kondisi_eksemplar, status_eksemplar,
                  kode_buku, isbn, judul_buku, penulis_buku, penerbit_buku,
                  tahun_terbit, kategori_buku, tanggal_kembali,
                  status_peminjaman })
```

### 2.2 1NF

Satu baris untuk setiap eksemplar di setiap peminjaman.
Kunci primer menjadi komposit **(no_peminjaman, kode_eksemplar)**.

PEMINJAMAN_1NF (**no_peminjaman**, **kode_eksemplar**, tanggal_pinjam, tanggal_jatuh_tempo, no_anggota, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, alamat_anggota, status_anggota, kode_petugas, nama_petugas, username_petugas, peran_petugas, kondisi_eksemplar, status_eksemplar, kode_buku, isbn, judul_buku, penulis_buku, penerbit_buku, tahun_terbit, kategori_buku, tanggal_kembali, status_peminjaman)

Asumsi: satu buku memiliki satu penulis utama (sesuai kamus data P2 dan kolom `penulis_buku` pada ERD). Jika ingin mencatat banyak penulis, perlu relasi baru agar tetap 1NF.

---

## 3. Dependensi Fungsional

Diturunkan dari aturan bisnis dan kamus data P2, bukan dari contoh data.

| Kode | Dependensi Fungsional | Dasar (AB / dokumen) |
|---|---|---|
| FD1 | no_peminjaman -> tanggal_pinjam, tanggal_jatuh_tempo, no_anggota, kode_petugas | Slip peminjaman, PB-03; AB-02 (peminjam adalah anggota aktif); AB-10 |
| FD2 | no_anggota -> nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, alamat_anggota, status_anggota | AB-01 (nomor anggota unik) |
| FD3 | kode_petugas -> nama_petugas, username_petugas, peran_petugas | AB-11; kamus data no. 27-29 |
| FD4 | kode_eksemplar -> kode_buku, kondisi_eksemplar, status_eksemplar | AB-03 (eksemplar milik satu judul buku); AB-06 |
| FD5 | kode_buku -> isbn, judul_buku, penulis_buku, penerbit_buku, tahun_terbit, kategori_buku | AB-03; kamus data no. 8-14 |
| FD6 | (no_peminjaman, kode_eksemplar) -> tanggal_kembali | AB-09, AB-04 (satu eksemplar hanya satu peminjaman aktif) |
| FD7 | tanggal_kembali -> status_peminjaman (kosong = aktif, terisi = dikembalikan) | kamus data no. 21-22; nilai turunan |
| FD8 | kode_denda -> no_peminjaman, jumlah_hari_terlambat, jumlah_denda, status_pembayaran | AB-07, AB-08 |
| FD9 | tanggal_kembali, tanggal_jatuh_tempo -> jumlah_hari_terlambat | AB-08; nilai turunan |
| FD10 | jumlah_hari_terlambat -> jumlah_denda (Rp6.000 x hari) | AB-07; nilai turunan |

Catatan: denda tidak ada pada slip peminjaman. FD8 diambil dari kuitansi pembayaran denda (sumber data no. 5) dan AB-07/AB-08, lalu ditambahkan sebagai relasi setelah 3NF dari slip.

---

## 4. Menuju 2NF

Kunci komposit (no_peminjaman, kode_eksemplar). Atribut yang hanya bergantung pada sebagian kunci:

- Bergantung pada `no_peminjaman` saja: FD1 beserta atribut anggota dan petugas lewat rantai.
- Bergantung pada `kode_eksemplar` saja: FD4 beserta atribut buku lewat rantai.
- Bergantung pada seluruh kunci: FD6 (`tanggal_kembali`) dan FD7 (`status_peminjaman`).

Hasil pemisahan:

PEMINJAMAN_2NF (**no_peminjaman**, tanggal_pinjam, tanggal_jatuh_tempo, no_anggota, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, alamat_anggota, status_anggota, kode_petugas, nama_petugas, username_petugas, peran_petugas)

EKSEMPLAR_2NF (**kode_eksemplar**, kondisi_eksemplar, status_eksemplar, kode_buku, isbn, judul_buku, penulis_buku, penerbit_buku, tahun_terbit, kategori_buku)

DETAIL_PEMINJAMAN (**no_peminjaman**\*, **kode_eksemplar**\*, tanggal_kembali, status_peminjaman)

## 5. Menuju 3NF

Rantai transitif yang dihilangkan:

- no_peminjaman -> no_anggota -> nim_anggota, nama_anggota, ... (pisahkan `anggota`)
- no_peminjaman -> kode_petugas -> nama_petugas, ... (pisahkan `petugas`)
- kode_eksemplar -> kode_buku -> judul_buku, penulis_buku, ... (pisahkan `buku`)

Hasil 3NF (relasi dengan kunci alami; dalam ERD tiap relasi diberi kunci pengganti `id_*`):

ANGGOTA (**no_anggota**, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, alamat_anggota, status_anggota)

PETUGAS (**kode_petugas**, nama_petugas, username_petugas, peran_petugas)

BUKU (**kode_buku**, isbn, judul_buku, penulis_buku, penerbit_buku, tahun_terbit, kategori_buku)

EKSEMPLAR (**kode_eksemplar**, kode_buku\*, kondisi_eksemplar, status_eksemplar)

PEMINJAMAN (**no_peminjaman**, tanggal_pinjam, tanggal_jatuh_tempo, no_anggota\*, kode_petugas\*)

DETAIL_PEMINJAMAN (**no_peminjaman**\*, **kode_eksemplar**\*, tanggal_kembali, status_peminjaman)

DENDA (**kode_denda**, no_peminjaman\*, jumlah_hari_terlambat, jumlah_denda, status_pembayaran)

Dua relasi masih memuat dependensi antaratribut bukan kunci (FD7 pada `detail_peminjaman`, FD10 pada `denda`). Keduanya sengaja dipertahankan sesuai ERD, alasannya ada di bagian 7.

### Tabel tahapan

| Tahap | Relasi | Masalah yang dihilangkan |
|---|---|---|
| UNF | PEMINJAMAN_UNF | grup berulang eksemplar dalam satu slip |
| 1NF | PEMINJAMAN_1NF | grup berulang; kunci menjadi komposit |
| 2NF | PEMINJAMAN_2NF, EKSEMPLAR_2NF, DETAIL_PEMINJAMAN | atribut bergantung sebagian kunci |
| 3NF | ANGGOTA, PETUGAS, BUKU, EKSEMPLAR, PEMINJAMAN, DETAIL_PEMINJAMAN, DENDA | rantai transitif anggota, petugas, dan buku |

---

## 6. Pemeriksaan BCNF

| Tabel | Penentu | Kunci kandidat? | Hasil |
|---|---|---|---|
| anggota | no_anggota; nim_anggota | ya, keduanya unik (AB-01, kamus data) | BCNF |
| petugas | kode_petugas; username_petugas | ya, keduanya UNIQUE di ERD | BCNF |
| buku | kode_buku; isbn | ya (isbn boleh kosong, tetapi unik jika terisi) | BCNF |
| eksemplar | kode_eksemplar | ya | BCNF |
| peminjaman | no_peminjaman | ya | BCNF |
| detail_peminjaman | (no_peminjaman, kode_eksemplar); **tanggal_kembali** | kunci komposit ya; tanggal_kembali **bukan** kunci kandidat | **Tidak BCNF** (pengecualian terkendali, bagian 7) |
| denda | kode_denda; **jumlah_hari_terlambat** | kode_denda ya; jumlah_hari_terlambat **bukan** kunci kandidat | **Tidak BCNF** (pengecualian terkendali, bagian 7) |

Lima tabel memenuhi BCNF. Dua tabel memiliki penentu yang bukan kunci kandidat karena menyimpan nilai turunan.

---

## 7. Keputusan Nilai Turunan

| Nilai | Keputusan | Alasan |
|---|---|---|
| status_peminjaman (di detail_peminjaman) | Disimpan, dijaga konsisten | Dapat dihitung dari tanggal_kembali (FD7), tetapi disimpan agar daftar buku yang masih dipinjam (KI-03) dan pemeriksaan AB-04/AB-09 dapat disaring langsung. Konsistensi dijaga dengan CHECK: status "dikembalikan" jika dan hanya jika tanggal_kembali terisi. |
| jumlah_hari_terlambat (di denda) | Disimpan sebagai catatan saat denda dibuat | Dapat dihitung dari tanggal_kembali dan tanggal_jatuh_tempo (FD9), tetapi denda adalah catatan historis yang dibuat saat pengembalian (AB-08) dan tidak boleh berubah. Nilainya harus >= 0 (CHECK). |
| jumlah_denda (di denda) | Disimpan sebagai potret historis | Tarif Rp6.000 per hari (AB-07) dapat berubah di masa depan; denda yang sudah tercatat tidak boleh ikut berubah. Kasusnya sama dengan harga satuan di nota Kopma (Titik Analisis 1). Nilainya harus sesuai hari terlambat dan tarif saat pencatatan (NFR-05). |
| status_eksemplar (di eksemplar) | Disimpan | AB-06 dan NFR-04 mengharuskan status ketersediaan selalu konsisten; pencarian ketersediaan juga perlu cepat (NFR-03). Dijaga lewat transaksi saat peminjaman dan pengembalian. |
| tanggal_jatuh_tempo (di peminjaman) | Disimpan | Tidak ada aturan bisnis lama peminjaman tetap pada P2, sehingga nilainya dicatat per transaksi (FD1), dengan CHECK >= tanggal_pinjam. |

Konsekuensi: FD7 dan FD10 adalah dependensi antaratribut bukan kunci, sehingga `detail_peminjaman` dan `denda` tidak memenuhi 3NF/BCNF murni. Ini keputusan sadar (denormalisasi terkendali), bukan kelalaian. Risikonya data tidak konsisten, dan diatasi dengan constraint pada Pertemuan 5.

Keterbatasan yang tercatat: `denda` terhubung ke `peminjaman`, bukan ke eksemplar tertentu. Jika kelak diperlukan penelusuran denda per eksemplar, tambahkan kunci tamu ke `detail_peminjaman`.

---

## 8. Pencocokan dengan ERD (Pertemuan 3)

ERD proyek sudah memakai kunci pengganti `id_*` dan menjadikan kode alami sebagai kunci unik, sesuai pola skema kanonik Pertemuan 4. Hasil 3NF di atas cocok dengan ERD, sehingga **tidak ada perubahan struktur ERD** pada milestone ini.

| Relasi 3NF | Tabel ERD | Kunci primer | Kunci unik | Kunci tamu |
|---|---|---|---|---|
| ANGGOTA | anggota | id_anggota | no_anggota, nim_anggota | - |
| PETUGAS | petugas | id_petugas | kode_petugas, username_petugas | - |
| BUKU | buku | id_buku | kode_buku | - |
| EKSEMPLAR | eksemplar | id_eksemplar | kode_eksemplar | id_buku |
| PEMINJAMAN | peminjaman | id_peminjaman | no_peminjaman | id_petugas, id_anggota |
| DETAIL_PEMINJAMAN | detail_peminjaman | (id_peminjaman, id_eksemplar) | - | id_peminjaman, id_eksemplar |
| DENDA | denda | id_denda | kode_denda | id_peminjaman |

Kunci pengganti tidak menghapus dependensi fungsional, sehingga pemeriksaan 3NF dan BCNF di atas dilakukan dengan kunci alami.

---

## 9. Jembatan ke Pertemuan 5

Setiap kunci dan aturan pada dokumen ini harus muncul sebagai constraint pada skrip DDL:

- PRIMARY KEY dan UNIQUE sesuai tabel di bagian 8 (AB-01, AB-03).
- FOREIGN KEY untuk semua relasi.
- CHECK atau ENUM untuk status_anggota, status_eksemplar, kondisi_eksemplar, status_pembayaran, status_peminjaman.
- CHECK tanggal_jatuh_tempo >= tanggal_pinjam, jumlah_hari_terlambat >= 0, dan konsistensi status_peminjaman dengan tanggal_kembali.
- Batas 8 eksemplar per peminjaman (AB-05) dan keunikan peminjaman aktif per eksemplar (AB-09) perlu ditangani lewat constraint atau trigger.
