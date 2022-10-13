------------------------------------------------------------------------------------------------------
--Data Validation / Cleaning:

--viewing distinct pets in dataset
SELECT distinct pet_type
FROM pet_sales

--deleting the records where the pet_type is a rabbit
DELETE FROM pet_sales
WHERE pet_type = 'rabbit';

--deleting the records where the pet_type is a hamster
DELETE FROM pet_sales
WHERE pet_type = 'hamster';

--dataset now only includes data where pet_type = cat, fish, bird, dog
SELECT distinct pet_type
FROM pet_sales

--Recoding the rebuy column into a purchased_again column to use 'yes' and 'no' 
--in the records instead of '1' and '0'
SELECT *,
CASE WHEN rebuy = '1' THEN 'yes'
WHEN rebuy = '0' THEN 'no'
END as purchased_again
FROM pet_sales;

--Adding the purchased_again column into the table
ALTER TABLE pet_sales
ADD purchased_again varchar;

UPDATE pet_sales
SET purchased_again =
CASE WHEN rebuy = '1' THEN 'yes'
WHEN rebuy = '0' THEN 'no' END;

--viewing dataset
SELECT *
FROM pet_sales;

-- updating the table to round the sales column to a whole number 
--because all of the values are rounded and have an unuseful decimal place
SELECT sales, ROUND(sales,0)
FROM pet_sales

UPDATE pet_sales
SET sales = ROUND(sales,0);

SELECT *
FROM pet_sales

--confirming there is 11 distinct categories in product_category
SELECT COUNT(DISTINCT product_category)
FROM pet_sales;

SELECT DISTINCT product_category
FROM pet_sales;

--confirming there are 5 distinct categories in pet_size
SELECT DISTINCT pet_size
FROM pet_sales;

------------------------------------------------------------------------------------------------------
--Exploratory Analysis:

--Total Sales between each product category
---Equipment, Snack, Toys are the top 3 by almost 2x each of the 4th value
SELECT product_category, SUM(sales) as total_sales
FROM pet_sales
GROUP BY product_category
ORDER BY total_sales DESC;

--Sales between pet type
--cat and dog pet type have significantly higher sales
SELECT pet_type, SUM(sales) as total_sales
FROM pet_sales
GROUP BY pet_type
ORDER BY total_sales DESC;

--Sales between different cat sizes... medium cat sales are the highest
SELECT pet_type, pet_size, SUM(sales) as total_sales
FROM pet_sales
WHERE pet_type = 'cat'
GROUP BY pet_type, pet_size
ORDER BY total_sales DESC;

--Sales between different dog sizes... small dog sales are the highest
SELECT pet_type, pet_size, SUM(sales) as total_sales
FROM pet_sales
WHERE pet_type = 'dog'
GROUP BY pet_type, pet_size
ORDER BY total_sales DESC;

--Count of Products are being purchased more than once
--more sales between products not purchased again
SELECT purchased_again, COUNT(purchased_again)
FROM pet_sales
GROUP BY purchased_again;

--products with highest sales grouping by pet_type and product_category
SELECT pet_type, product_category, SUM(sales)
FROM pet_sales
GROUP BY pet_type, product_category
ORDER BY pet_type, SUM(sales) DESC;

--products are more likely to be purchased again overall
SELECT product_category, COUNT(*)
FROM pet_sales
WHERE purchased_again = 'yes'
GROUP BY product_category
ORDER BY count(purchased_again) DESC;

--products that are not to be purchased again overall
SELECT product_category, COUNT(*)
FROM pet_sales
WHERE purchased_again = 'no'
GROUP BY product_category
ORDER BY count(purchased_again) DESC;

--products are more likely to be purchased again for cats
SELECT product_category, COUNT(*)
FROM pet_sales
WHERE purchased_again = 'yes'
AND pet_type = 'cat'
GROUP BY product_category
ORDER BY COUNT(purchased_again) DESC;

--products are more likely to be purchased again for dogs
SELECT product_category, COUNT(*)
FROM pet_sales
WHERE purchased_again = 'yes'
AND pet_type = 'dog'
GROUP BY product_category
ORDER BY COUNT(purchased_again) DESC;

--products are more likely to be purchased again for fishes
SELECT product_category, COUNT(*)
FROM pet_sales
WHERE purchased_again = 'yes'
AND pet_type = 'fish'
GROUP BY product_category
ORDER BY COUNT(purchased_again) DESC;

--products are more likely to be purchased again for birds
SELECT product_category, COUNT(*)
FROM pet_sales
WHERE purchased_again = 'yes'
AND pet_type = 'bird'
GROUP BY product_category
ORDER BY COUNT(purchased_again) DESC;

--Do the products being purchased again have better sales than others?
--result: products NOT purchased again have better sales 443 vs 390
SELECT purchased_again, COUNT(*)
FROM pet_sales
GROUP BY purchased_again

--How many products are being purchased more than once? 
--result: 390 products
SELECT COUNT(*)
FROM pet_sales
WHERE purchased_again = 'yes'

--products that are not to be purchased again overall
SELECT product_category, SUM(sales)
FROM pet_sales
WHERE purchased_again = 'yes'
GROUP BY product_category
ORDER BY count(purchased_again) DESC;

--Do the products being purchased again have better sales than others?
--sum of sales between products purchased again vs not purchased again
--result: Products not purchased again have higher sales than products purchased again
SELECT purchased_again, SUM(sales) as total_sales
FROM pet_sales
GROUP BY purchased_again
ORDER BY SUM(sales) DESC;


--What products are more likely to be purchased again for different types of pets?
WITH RANKED_PETS AS
--products with highest sales grouping by pet_type and product_category
(SELECT pet_type, product_category, SUM(sales),
DENSE_RANK() OVER(PARTITION BY pet_type ORDER BY SUM(sales) DESC) as RANK
FROM pet_sales
WHERE purchased_again = 'yes'
GROUP BY pet_type, product_category
ORDER BY pet_type, SUM(sales) DESC)

SELECT *
FROM ranked_pets
WHERE RANK BETWEEN 1 and 3;

SELECT product_category, AVG(rating)
FROM pet_sales
GROUP BY product_category

------------------------------------------------------------------------------------------------------
--SQL queries Exported to Tableau Dashboard:

--How many products are being purchased more than once? 
--result: 390 products
SELECT purchased_again, COUNT(*)
FROM pet_sales
GROUP BY purchased_again

--Do the products being purchased again have better sales than others?
--sum of sales between products purchased again vs not purchased again
--result: Products not purchased again have higher sales than products purchased again, but noy by a lot
SELECT purchased_again, SUM(sales) as total_sales
FROM pet_sales
GROUP BY purchased_again
ORDER BY SUM(sales) DESC;

--What products are more likely to be purchased again for different types of pets?

--products with highest sales grouping by pet_type and product_category
SELECT pet_type, product_category, SUM(sales)
FROM pet_sales
WHERE purchased_again = 'yes'
GROUP BY pet_type, product_category
ORDER BY pet_type, SUM(sales) DESC


--What products are more likely to be purchased again for different types of pets?
WITH RANKED_PETS AS
--products with highest sales grouping by pet_type and product_category
(SELECT pet_type, product_category, SUM(sales),
DENSE_RANK() OVER(PARTITION BY pet_type ORDER BY SUM(sales) DESC) as RANK
FROM pet_sales
WHERE purchased_again = 'yes'
GROUP BY pet_type, product_category
ORDER BY pet_type, SUM(sales) DESC)

SELECT *
FROM ranked_pets
WHERE RANK BETWEEN 1 and 3;

--Sales between pet type
--cat and dog pet type have significantly higher sales
SELECT pet_type, SUM(sales) as total_sales
FROM pet_sales
GROUP BY pet_type
ORDER BY total_sales DESC;

