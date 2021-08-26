-- Produk DQLab Mart
SELECT 
	*
FROM
	ms_produk
WHERE 
	harga BETWEEN 50000 AND 150000;

-- Thumb drive di DQLab Mart 
SELECT 
	*
FROM 
	ms_produk
WHERE 
	nama_produk LIKE '%Flashdisk%';

-- Pelanggan Bergelar
SELECT * FROM ms_pelanggan
WHERE 
	nama_pelanggan LIKE '%S.H.' OR
	nama_pelanggan LIKE 'Ir.%' OR
	nama_pelanggan LIKE '%Drs.';

-- Mengurutkan Nama Pelanggan
SELECT
	nama_pelanggan
FROM 
	ms_pelanggan 
ORDER BY
	nama_pelanggan;

-- Mengurutkan Nama Pelanggan Tanpa Gelar
SELECT
	nama_pelanggan
FROM 
	ms_pelanggan
ORDER BY
	SUBSTRING_INDEX(nama_pelanggan,'. ',-1)

-- Nama Pelanggan yang Paling Panjang
SELECT 
	nama_pelanggan
FROM
	ms_pelanggan
WHERE 
	LENGTH(nama_pelanggan) IN (
	SELECT MAX(LENGTH(nama_pelanggan))
	FROM ms_pelanggan
	);
	
-- Nama Pelanggan yang Paling Panjang dengan Gelar
SELECT 
	nama_pelanggan
FROM
	ms_pelanggan
WHERE 
	LENGTH(nama_pelanggan) IN (
	SELECT 
	  MAX(LENGTH(nama_pelanggan))
	FROM ms_pelanggan
	)
	OR
	LENGTH(nama_pelanggan) IN (
	SELECT 
	  MIN(LENGTH(nama_pelanggan))
	FROM ms_pelanggan
	)
ORDER BY
	LENGTH(nama_pelanggan) DESC

-- Kuantitas Produk yang Banyak Terjual
SELECT 
	ms_produk.kode_produk,
	ms_produk.nama_produk,
	SUM(tr_penjualan_detail.qty) AS total_qty
FROM
	ms_produk
INNER JOIN
	tr_penjualan_detail ON tr_penjualan_detail.kode_produk = ms_produk.kode_produk
GROUP BY
	ms_produk.kode_produk,
	ms_produk.nama_produk
HAVING
	SUM(tr_penjualan_detail.qty) > 
	(SELECT MAX(qty) FROM tr_penjualan_detail)

-- Pelanggan Paling Tinggi Nilai Belanjanya
SELECT
	ms_pelanggan.kode_pelanggan,
 	ms_pelanggan.nama_pelanggan,
 	SUM(qty*harga_satuan) AS total_harga
FROM ms_pelanggan
INNER JOIN tr_penjualan
ON ms_pelanggan.kode_pelanggan = tr_penjualan.kode_pelanggan
INNER JOIN tr_penjualan_detail
ON tr_penjualan_detail.kode_transaksi = tr_penjualan.kode_transaksi
GROUP BY 
 	ms_pelanggan.kode_pelanggan,
 	ms_pelanggan.nama_pelanggan
ORDER BY total_harga DESC LIMIT 1;

-- Pelanggan yang Belum Pernah Berbelanja
SELECT
	ms_pelanggan.kode_pelanggan,
	ms_pelanggan.nama_pelanggan,
	ms_pelanggan.alamat
FROM 
	ms_pelanggan
WHERE 
	ms_pelanggan.kode_pelanggan NOT IN (
	SELECT 
		tr_penjualan.kode_pelanggan
	FROM
	  	tr_penjualan	
	)

-- Transaksi Belanja dengan Daftar Belanja lebih dari 1
SELECT
	tr_penjualan.kode_transaksi,
	tr_penjualan.kode_pelanggan,
	ms_pelanggan.nama_pelanggan,
	tr_penjualan.tanggal_transaksi,
	COUNT(tr_penjualan_detail.qty) as jumlah_detail
FROM
	tr_penjualan
INNER JOIN
	ms_pelanggan ON ms_pelanggan.kode_pelanggan = tr_penjualan.kode_pelanggan
INNER JOIN
	tr_penjualan_detail ON tr_penjualan_detail.kode_transaksi = tr_penjualan.kode_transaksi
GROUP BY
	tr_penjualan.kode_transaksi,
	tr_penjualan.kode_pelanggan,
	ms_pelanggan.nama_pelanggan,
	tr_penjualan.tanggal_transaksi
HAVING 
	jumlah_detail > 1

