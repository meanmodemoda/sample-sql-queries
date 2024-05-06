
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