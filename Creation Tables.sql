-- Create Creation

#STORES TABLE

create table stores(
store_id varchar(10) Primary key,
store_name varchar(30),
city varchar(30),
country varchar(30)
);

# We're loaded the csv file to the table 

LOAD DATA INFILE 'stores.csv' INTO TABLE stores
FIELDS TERMINATED BY ','  
ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

select * from stores;

#CATEGORIES TABLE

create table category(
category_id varchar(10) primary key,
category_name varchar(30)
);

LOAD DATA INFILE 'category.csv' INTO TABLE category
FIELDS TERMINATED BY ','  
ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

select * from category;

#PRODUCTS TABLE

create table products(
product_id varchar(10) primary key,
product_name varchar(35),
category_id varchar(10),
launch_date TEXT,
price float,
constraint fk_category foreign key (category_id) references category(category_id)
);


;

LOAD DATA INFILE 'products.csv' INTO TABLE products
FIELDS TERMINATED BY ','  
ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

select * from products;

# We're update the date format to a make it (DATE) : through STR_TO_DATE and modify column
UPDATE products
SET launch_date = str_to_date(launch_date,"%Y-%m-%d");

ALTER TABLE products 
MODIFY COLUMN launch_date DATE;



#SALES TABLE

create table sales(
sale_id varchar(10) primary key,
sale_date TEXT,
store_id varchar(10),
product_id varchar(10),
quantity int,
constraint fk_store foreign key (store_id) references stores(store_id),
constraint fk_product foreign key (product_id) references products(product_id)
);

#Because Sales.csv more than 1 million row we're devide it into 6 chunks every chunk has 100k row 
# (part_n.csv)--> n=1,2,3,4,5,6 

LOAD DATA INFILE 'part_1.csv' INTO TABLE sales
FIELDS TERMINATED BY ','  
ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

select * from sales;

UPDATE sales
SET sale_date = str_to_date(sale_date,"%d-%m-%Y");

ALTER TABLE sales 
MODIFY COLUMN sale_date DATE;


#WARRANTY TABLE

create table warranty(
claim_id varchar(10) primary key,
claim_date TEXT,
sale_id varchar(10),
repair_status varchar(20),
constraint fk_sale foreign key (sale_id) references sales(sale_id)
);

LOAD DATA INFILE 'warranty.csv' INTO TABLE warranty
FIELDS TERMINATED BY ','  
ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

SELECT * FROM warranty;

UPDATE warranty
SET claim_date = str_to_date(claim_date,"%Y-%m-%d");

ALTER TABLE warranty 
MODIFY COLUMN claim_date DATE;



