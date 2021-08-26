-- Memahami table
SELECT * FROM orders_1 limit 5;
SELECT * FROM orders_2 limit 5;
SELECT * FROM customer limit 5;

-- Total Penjualan dan Revenue pada Quarter-1 (Jan, Feb, Mar) dan Quarter-2 (Apr,Mei,Jun)
SELECT
	SUM(quantity) AS total_penjualan,
	SUM(quantity * priceeach) AS revenue
FROM 
	Orders_1
WHERE
	status = 'Shipped';

SELECT
	SUM(quantity) AS total_penjualan,
	SUM(quantity * priceeach) AS revenue
FROM 
	Orders_2
WHERE
	status = 'Shipped';

-- Menghitung persentasi keseluruhan penjualan
SELECT
	quarter,
	SUM(quantity) AS total_penjualan,
	SUM(quantity * priceeach) AS revenue
FROM
	(SELECT
	 	orderNumber,
	 	status,
	 	quantity,
	 	priceeach,
	 	1 AS quarter
	 FROM
	 	orders_1
	 UNION ALL
	 SELECT
	 	orderNumber,
	 	status,
	 	quantity,
	 	priceeach,
	 	2 AS quarter
	 FROM
	 	orders_2
	) AS tabel_a
WHERE
	status = 'Shipped'
GROUP BY
	quarter;

-- Apakah jumlah customers xyz.com semakin bertambah?
SELECT
	quarter,
	total_customers
FROM
	(
	SELECT
	  	QUARTER(createDate) as quarter,
	  	COUNT(DISTINCT customerID) AS total_customers
	FROM
	  	customer
	WHERE
	  	createDate BETWEEN '2004-01-01' AND '2004-06-30'
	GROUP BY
	  	quarter
	) AS tabel_b

-- Seberapa banyak customers tersebut yang sudah melakukan transaksi?
SELECT
	quarter,
	total_customers
FROM
	(
	SELECT
	  	QUARTER(createDate) as quarter,
	 	COUNT(customerID) AS total_customers
	FROM
	  	customer
	WHERE
		customerID IN(
			SELECT 
		  		DISTINCT customerID as customerID
		  	FROM 
		  		Orders_1
		  	UNION
		  	SELECT 
		  		DISTINCT customerID as customerID
		  	FROM 
		  		Orders_2		
		)	  
	  	AND
	  	createDate BETWEEN '2004-01-01' AND '2004-06-30'
	GROUP BY
	  	quarter	
	) AS tabel_b

-- Category produk apa saja yang paling banyak di-order oleh customers di Quarter-2?
SELECT
	SUBSTRING(productCode, 1, 3) AS categoryid,
	COUNT(DISTINCT orderNumber) AS total_order,
	SUM(quantity) AS total_penjualan
FROM
	(
	SELECT 
	  	productCode,
		orderNumber,
		quantity
	FROM
	  	Orders_2	
	WHERE
	  	status = 'shipped'
	) AS tabel_c
GROUP BY
	categoryid
ORDER BY
	total_order DESC

-- Seberapa banyak customers yang tetap aktif bertransaksi setelah transaksi pertamanya?
--#Menghitung total unik customers yang transaksi di quarter_1
SELECT COUNT(DISTINCT customerID) as total_customers FROM orders_1;
--#output = 25
SELECT 
	1 as quarter,
	q2
FROM
	(
	SELECT
	  	(COUNT(DISTINCT customerid) * 100) / 25 as q2
	FROM
	  	orders_2
	WHERE
	  	customerid IN (
			SELECT 
		  		customerid
		  	FROM
		  		orders_1
		)
	) AS tabel_d

