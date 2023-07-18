

-- 1) Membuat Database: klik kanan pada Databases > Create > Database... dengan nama kimia_farma

-- 2) Membuat Tabel
-- a) Tabel barang
CREATE TABLE barang
(
       kode_barang varchar NOT NULL,
       sektor varchar,
       nama_barang varchar,
       tipe varchar,
       nama_tipe varchar,
       kode_lini varchar,
       lini varchar,
       kemasan varchar
);

-- b) Tabel pelanggan
CREATE TABLE pelanggan
(
       id_customer varchar NOT NULL,
       level varchar,
       nama varchar,
       id_cabang varchar,
       cabang varchar,
       id_grup varchar,
       grup varchar
);

-- c) Tabel penjualan
CREATE TABLE penjualan
(
       id_distributor varchar NOT NULL,
       id_cabang varchar,
       id_invoice varchar,
       tanggal date,
       id_customer varchar,
       id_barang varchar,
       jumlah integer,
       satuan varchar,
       harga numeric,
       mata_uang varchar,
       brand_id varchar,
       lini varchar
);

-- 3) Melakukan import data dengan format csv: klik kanan pada nama tabel > Import/Export Data…

-- 4) Menentukan Primary Key dan Foreign Key
-- PRIMARY KEY
ALTER TABLE barang
      ADD CONSTRAINT kode_barang
      PRIMARY KEY (kode_barang);
	
ALTER TABLE pelanggan
      ADD CONSTRAINT id_customer_pkey
      PRIMARY KEY (id_customer);

ALTER TABLE penjualan
      ADD CONSTRAINT id_invoice_pkey
      PRIMARY KEY (id_invoice);

-- FOREIGN KEY
ALTER TABLE IF EXISTS penjualan
      ADD CONSTRAINT id_barang_fkey
      FOREIGN KEY (id_barang)
      REFERENCES barang (kode_barang);

ALTER TABLE IF EXISTS penjualan
      ADD CONSTRAINT id_customer_fkey
      FOREIGN KEY (id_customer)
      REFERENCES pelanggan (id_customer);

-- 5) Membuat Entity Relationship Diagram (ERD): klik kanan pada Database kimia_farma > Generate ERD

-- 6) Membuat Data Mart
-- Mengecek nilai unik pada kolom id_invoice
SELECT COUNT(DISTINCT(id_invoice))
  FROM penjualan;

-- a) Membuat tabel base penjualan
CREATE TABLE base_table AS
SELECT s.id_invoice,
       s.tanggal,
       s.id_customer,
       c.nama,
       c.id_cabang,
       c.cabang,
       c.grup,
       s.id_distributor,	
       s.id_barang,
       b.nama_barang,
       b.kemasan,
       s.lini,	
       s.jumlah,
       s.satuan,
       s.harga,
       s.mata_uang
  FROM penjualan AS s
  LEFT JOIN pelanggan AS c
    ON s.id_customer = c.id_customer
  LEFT JOIN barang AS b
    ON s.id_barang = b.kode_barang
 ORDER BY s.tanggal;

-- Menentukan Primary Key (PK)
ALTER TABLE base_table ADD PRIMARY KEY(id_invoice);

-- Menampilkan hasil pembuatan tabel base
SELECT *
  FROM base_table
 LIMIT 5;
 
-- b) Membuat tabel agregat penjualan
CREATE TABLE agg_table AS
SELECT tanggal,
       date_part('month', tanggal) AS bulan,
       id_invoice,
       cabang,
       nama AS pelanggan,
       nama_barang AS produk,
       lini AS merek,
       jumlah AS jumlah_produk_terjual,
       harga AS harga_satuan,
       (jumlah * harga) AS pendapatan
  FROM base_table
 ORDER BY 1, 4, 5, 6, 7, 8, 9, 10;
 
-- Menampilkan hasil pembuatan tabel agregat
SELECT *
  FROM agg_table
 LIMIT 5;