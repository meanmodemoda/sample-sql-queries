Step 1: load csv data into SQL

  CREATE TABLE window_function (
  index VARCHAR(50),
  year INT,
 month INT,
  level VARCHAR(50),
  net_new INT,
  total INT,
  PRIMARY KEY(index)
  );

COPY window_function
FROM '/Users/yangzhao/Documents/GITHUB/sample sql/window_function.csv'
DELIMITER ','
CSV HEADER;


SELECT * FROM
window_function