USE [LinkedIn_Growth_Analytics];

CREATE TABLE users(

user_id INT PRIMARY KEY,
user_name VARCHAR(50),
country VARCHAR(30),
premium_user VARCHAR(10),
join_date DATE

);

CREATE TABLE posts(

post_id INT PRIMARY KEY,
user_id INT,
post_date DATE,
likes INT,
comments INT,
shares INT,
job_category VARCHAR(50),

FOREIGN KEY(user_id)
REFERENCES users(user_id)

);

INSERT INTO users VALUES

(101,'Ava','USA','Yes','2024-01-01'),
(102,'Noah','India','No','2024-01-10'),
(103,'Emma','UK','Yes','2024-01-20'),
(104,'Liam','Germany','No','2024-02-01'),
(105,'Sophia','India','Yes','2024-02-10'),
(106,'James','Canada','No','2024-02-15');

INSERT INTO posts VALUES

(1,101,'2025-01-01',400,60,20,'Data'),
(2,101,'2025-02-01',700,120,50,'AI'),

(3,102,'2025-01-01',300,40,15,'HR'),
(4,102,'2025-02-01',500,60,20,'SQL'),

(5,103,'2025-01-01',800,130,70,'AI'),
(6,103,'2025-02-01',1200,250,100,'AI'),

(7,104,'2025-01-01',200,30,10,'Finance'),
(8,104,'2025-02-01',250,35,12,'Finance'),

(9,105,'2025-01-01',900,180,90,'Analytics'),
(10,105,'2025-02-01',1100,220,120,'Analytics'),

(11,106,'2025-01-01',350,50,25,'Data'),
(12,106,'2025-02-01',450,60,35,'SQL');

SELECT * FROM [dbo].[posts];
SELECT * FROM [dbo].[users];