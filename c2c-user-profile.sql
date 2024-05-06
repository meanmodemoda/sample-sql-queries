Step 1: load csv data into SQL
CREATE TABLE c2c_users (
  id VARCHAR(50),
  country VARCHAR(50),
  language VARCHAR(50),
  socialNbFollowers INT,
 	socialNbFollows INT,
  socialProductsLiked INT,
  productsListed INT,
  productsSold INT,
  productsPassRate FLOAT,
  productsWished INT,
  productsBought INT,
  gender VARCHAR(50),
  hasAnyApp BOOLEAN,
  hasAndroidApp BOOLEAN,
  hasIosApp BOOLEAN,
  hasProfilePicture BOOLEAN,
  daysSinceLastLogin INT,
  seniority INT,
  seniorityAsMonths FLOAT,
  seniorityAsYears FLOAT,
  countryCode VARCHAR(50),
  PRIMARY KEY(id)
  );

  
COPY c2c_users
FROM '/Users/yangzhao/Desktop/SQL/Vestiaire/c2c_data.csv'
DELIMITER ','
CSV HEADER;

Step 2: EDA and project scoping
The goal of this project is to identify high level user trends. The EDA will explore the following questions.

1. Breakdown of users by country in pct to total, also calculate running total.
Top 7 countries account for 81% users.

SELECT
countrycode,
pct_total,
SUM(pct_total) OVER(ORDER BY rank) AS pct_running_total,
rank
FROM 
(SELECT 
countrycode, 
COUNT(DISTINCT id)/SUM(count(DISTINCT id)) OVER() AS pct_total,
DENSE_RANK()OVER(ORDER BY COUNT(DISTINCT id)DESC ) AS rank
FROM c2c_users
GROUP BY 1
ORDER BY pct_total DESC) 
ORDER BY pct_total DESC

2. Breakdown of users by seniority in pct to total, also calculate running total.

Dataset is for users who have been on the platform for 5-10 years.

SELECT 
CASE WHEN seniorityasyears <=1 THEN 'less than 1 year'
WHEN seniorityasyears <=3 THEN '1 to 3 years'
WHEN seniorityasyears<=5 THEN '3 to 5 years'
WHEN seniorityasyears<=8 THEN '5 to 8 years'
WHEN seniorityasyears<=10 THEN '8 to 10 years'
ELSE 'greater than 10 years' END as seniority, 
COUNT(DISTINCT id)/SUM(count(DISTINCT id)) OVER() AS pct_total
FROM c2c_users
GROUP BY 1
ORDER BY pct_total DESC


3. Breakdown of users by App. 

SELECT
SUM(CASE WHEN hasandroidapp='true' AND hasiosapp='false' THEN 1 ELSE 0 END)::FLOAT/COUNT(DISTINCT id) as android_pct,
SUM(CASE WHEN hasandroidapp='false' AND hasiosapp='true' THEN 1 ELSE 0 END)::FLOAT/COUNT(DISTINCT id) as ios_pct,
SUM(CASE WHEN hasandroidapp='true' AND hasiosapp='true' THEN 1 ELSE 0 END)::FLOAT/COUNT(DISTINCT id) as both,
SUM(CASE WHEN hasandroidapp='false' AND hasiosapp='false' THEN 1 ELSE 0 END)::FLOAT/COUNT(DISTINCT id) as neither
FROM c2c_users

4. Breakdown of sell-through by country, seniority.

SELECT SUM(productssold)::FLOAT/SUM(productslisted+productssold)
FROM c2c_users

SELECT
countrycode,
SUM(productssold) AS sum_sold,
AVG(productssold::FLOAT/(productslisted+productssold)) avg_sell_thru
FROM c2c_users
WHERE productslisted+productssold>0
GROUP BY 1
ORDER BY sum_sold DESC


5. Pct of sellers who are also buyers, Pct of buyers who are also sellers, further breakdown by country and seniority.

SELECT
COUNT(CASE WHEN productslisted>0 AND productsbought>0 THEN id ELSE NULL END)::FLOAT/COUNT(CASE WHEN productsbought>0 THEN id ELSE NULL END) pct_buyer_is_seller,
COUNT(CASE WHEN productslisted=0 AND productsbought>0 THEN id ELSE NULL END)::FLOAT/COUNT(CASE WHEN productsbought>0 THEN id ELSE NULL END) pct_only_buys,
COUNT(CASE WHEN productslisted>0 AND productsbought>0 THEN id ELSE NULL END)::FLOAT/COUNT(CASE WHEN productslisted>0 THEN id ELSE NULL END) pct_seller_is_buyer,
COUNT(CASE WHEN productslisted>0 AND productsbought=0 THEN id ELSE NULL END)::FLOAT/COUNT(CASE WHEN productslisted>0 THEN id ELSE NULL END) pct_only_sells
FROM c2c_users

6. Correlation between followers and sell-through (further drill down by gender)

7. Correlation between products wished and products bought (further drill down by gender)

8. Correlation between sell-through and passrate.

9. Cluster Analysis of highly engaged users to luggards.

10. Active users by last login. 

