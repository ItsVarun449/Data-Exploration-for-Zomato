

SELECT *
FROM product;

SELECT *
FROM sales;

SELECT *
FROM users;

SELECT *
FROM goldusers_signup;



-- 1. What is a total amount each customer spent on zomato?

SELECT a.userid, a.product_id, b.price
FROM sales a
JOIN product b ON a.product_id = b.product_id

SELECT a.userid, SUM(b.price) AS Total
FROM sales a
JOIN product b ON a.product_id = b.product_id
GROUP BY a.userid;

-- 2. For how many days has each customer visited zomato

SELECT userid, COUNT(DISTINCT created_date) AS 'Number of days users visited Zomato'
FROM sales
GROUP BY userid;

-- 3. What was the first product purchased by each customer?
SELECT *
FROM
(SELECT *, RANK() OVER(PARTITION BY userid ORDER BY created_date) AS ranking FROM sales) a
WHERE ranking = 1;

-- 4. Find out the most purchased item in the menu and how many times it has been purchased by each user?


SELECT userid, COUNT(product_id) AS product_purchased_numberoftimes FROM sales 
WHERE product_id = (SELECT TOP 1 product_id
FROM sales
GROUP BY product_id
ORDER BY COUNT(product_id) DESC)
GROUP BY userid;

-- 5. Which item was most popular for each customer?
SELECT * FROM
(SELECT *, RANK() OVER(PARTITION BY userid ORDER BY Count_popular_item DESC) Ranking FROM
(SELECT userid, product_id, COUNT(product_id) AS Count_popular_item FROM sales GROUP BY userid, product_id) a) b
WHERE Ranking = 1;

-- 6. Which Item was first purchased by user after they became gold member?

SELECT * FROM 
(SELECT c. *, RANK() OVER(PARTITION BY userid ORDER BY created_date) ranking FROM
(SELECT a.userid, a.created_date, a.product_id, b.gold_signup_date 
FROM sales a INNER JOIN goldusers_signup b ON a.userid = b.userid AND created_date >= gold_signup_date) c) d WHERE ranking = 1;

-- 7. Which Item was last purchased by user just before becoming a golden member?

SELECT * FROM 
(SELECT c. *, RANK() OVER(PARTITION BY userid ORDER BY created_date DESC) ranking FROM
(SELECT a.userid, a.created_date, a.product_id, b.gold_signup_date 
FROM sales a INNER JOIN goldusers_signup b ON a.userid = b.userid AND created_date < gold_signup_date) c) d WHERE ranking = 1;




