-- Overall Performance by Year
SELECT 
	EXTRACT(YEAR FROM order_date) as years,
	SUM(sales) as sales,
	COUNT(order_id) as number_of_order
FROM 
	dqlab_sales_store
WHERE
	order_status = 'order finished'
GROUP BY
	years

-- Overall Performance by Product Sub Category
SELECT
	YEAR(order_date) AS years,
	product_sub_category,
	SUM(sales) AS sales
FROM 
	dqlab_sales_store
WHERE
	order_status = 'order finished' AND
	YEAR(order_date) IN('2011','2012')
GROUP BY
	years,
	product_sub_category
ORDER BY
	years,
	SUM(sales)
DESC

-- Promotion Effectiveness and Efficiency by Years
SELECT 
	YEAR(order_date) AS years,
	SUM(sales) AS sales,
	SUM(discount_value) AS promotion_value,
	ROUND((SUM(discount_value) / SUM(sales)) * 100,2) AS burn_rate_percentage
FROM 
	dqlab_sales_store
WHERE
	order_status = 'order finished'
GROUP BY
	years

-- Promotion Effectiveness and Efficiency by Product Sub Category
SELECT
	YEAR(order_date) AS years,
	product_sub_category,
	product_category,
	SUM(sales) AS sales,
	SUM(discount_value) AS promotion_value,
	ROUND((SUM(discount_value) / SUM(sales)) * 100, 2) AS burn_rate_percentage
FROM
	dqlab_sales_store
WHERE
	order_status = 'order finished' AND
	YEAR(order_date) IN ('2012')
	
GROUP BY
	years,
	product_sub_category,
	product_category
ORDER BY
	sales DESC

-- Customers Transactions per Year
SELECT
	YEAR(order_date) AS years,
	COUNT(DISTINCT customer) AS number_of_customer
FROM 
	dqlab_sales_store
WHERE
	order_status = 'Order Finished'	
GROUP BY
	years

