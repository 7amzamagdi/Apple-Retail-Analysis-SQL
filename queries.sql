USE apple_retail_analysis;

# Get to know your data
SELECT * FROM category;
SELECT * FROM products;
SELECT * FROM stores;
SELECT * FROM sales;
SELECT * FROM warranty;

#1.find number of stores in each country
SELECT country,count(store_id) as Total_Stores
FROM stores
GROUP BY 1
ORDER BY 2 DESC;

#2.calculate the total number of units sold by each store.
SELECT st.store_name, SUM(s.quantity) AS total_units_sold
FROM sales AS s
LEFT JOIN stores AS st
ON st.store_id = s.store_id
GROUP BY 1
ORDER BY 2 DESC;

#3.Identify how many sates occurred in December 2023.

SELECT COUNT(sale_id) as total_NO_sales_in_December23
FROM sales
WHERE sale_date BETWEEN "2023-12-01" AND "2023-12-31";

#4.Determine how many stores have never had a warranty claim filed.
SELECT COUNT(*) AS not_claimed
FROM stores
WHERE store_id NOT IN (SELECT DISTINCT store_id
					   FROM sales AS s 
                       RIGHT JOIN warranty AS w 
                       ON s.sale_id = w.sale_id);

#5.Calcutate th percentage of warranty claims marked as "Rejected" .
SELECT CONCAT(ROUND(COUNT(*)*100/(SELECT COUNT(*) FROM warranty), 2),'%') AS rejected_percentage
FROM warranty
WHERE repair_status LIKE 'Rejected%';

#6.Identify which store had the highest total units sold in the last year.
SELECT st.store_name, SUM(s.quantity) AS total_units_sold
FROM sales AS s
LEFT JOIN stores AS st
ON st.store_id = s.store_id
WHERE s.sale_date >= CURDATE()- INTERVAL 1 YEAR 
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

#7.Count the number of unique products sold in the last year.
SELECT COUNT(DISTINCT product_id) AS NO_product_sold_lastyear
FROM sales 
WHERE sale_date>= CURDATE() - INTERVAL 1 YEAR ;

#8.Find the average price of products in each category.
SELECT category_name,ROUND(AVG(price),2) AS avg_price
FROM products AS p
JOIN category AS c
USING(category_id)
GROUP BY 1
ORDER BY 2 DESC;

#9.How many warranty claims were filed in 2024?
SELECT COUNT(*) AS claims_filed24
FROM warranty
WHERE YEAR(claim_date) = 2024;

#10.For each store, identify the best-selling day based on highest quantity sold.
SELECT st.store_name,DAYNAME(sale_date) AS day_n, SUM(s.quantity) AS Best_selling_store
FROM sales AS s
LEFT JOIN stores AS st
ON st.store_id = s.store_id
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 1;



select * from
(
	select
    store_id,
    DAYNAME(sale_date) as day_name,
    sum(quantity) as Total_Quantity_sold,
    rank() over(partition by store_id order by sum(quantity) desc) as rank_
    from sales
    group by 1,2
) as tb1
where rank_ = 1