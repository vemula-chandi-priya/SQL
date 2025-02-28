drop table if exists goldusers_signup;
CREATE TABLE goldusers_signup(userid integer,gold_signup_date date); 

INSERT INTO goldusers_signup(userid,gold_signup_date) 
 VALUES (1,'09-22-2017'),
(3,'04-21-2017');

drop table if exists users;
CREATE TABLE users(userid integer,signup_date date); 

INSERT INTO users(userid,signup_date) 
 VALUES (1,'09-02-2014'),
(2,'01-15-2015'),
(3,'04-11-2014');

drop table if exists sales;
CREATE TABLE sales(userid integer,created_date date,product_id integer); 

INSERT INTO sales(userid,created_date,product_id) 
 VALUES (1,'04-19-2017',2),
(3,'12-18-2019',1),
(2,'07-20-2020',3),
(1,'10-23-2019',2),
(1,'03-19-2018',3),
(3,'12-20-2016',2),
(1,'11-09-2016',1),
(1,'05-20-2016',3),
(2,'09-24-2017',1),
(1,'03-11-2017',2),
(1,'03-11-2016',1),
(3,'11-10-2016',1),
(3,'12-07-2017',2),
(3,'12-15-2016',2),
(2,'11-08-2017',2),
(2,'09-10-2018',3);


drop table if exists product;
CREATE TABLE product(product_id integer,product_name text,price integer); 

INSERT INTO product(product_id,product_name,price) 
 VALUES
(1,'p1',980),
(2,'p2',870),
(3,'p3',330);


select * from sales;
select * from product;
select * from goldusers_signup;
select * from users;

--Metrics
-- What is the total amount each customer spends on Zomato?
select a.userid, sum(b.price) as Total_Amount_Spent from sales as a inner join product as b on a.product_id=b.product_id
group by a.userid;

-- How many days has each customer visited Zomato?
select * from sales;
select userid, count(distinct created_date) as distinct_days from sales group by userid;

-- What was the first product purchased by each customer?
select *,rank() over(partition by userid order by created_date) as Ranks from sales;

select * from (
select *,rank() over(partition by userid order by created_date) as Ranks from sales) as A where Ranks=1;

select * from (
select *,rank() over(partition by userid order by created_date) as Ranks from sales) as A where Ranks=2;

select * from (
select *,rank() over(partition by userid order by created_date) as Ranks from sales) as A where Ranks=3;


-- What is the most purchased item on the menu and how many times was it purchased by all customers?
select * from product;
select * from sales;

select product_id, count(product_id) as Product_Bought from sales group by product_id order by count(product_id) desc;

select userid, count(product_id) as Product_Bought from sales where product_id =
(select top 1 product_id from sales group by product_id order by count(product_id) desc)
group by userid;

-- Which item was the most popular among the customers?
select * from sales;
select userid, count(product_id) as Times_Bought, product_id from sales
group by userid, product_id;

select * from (
select *, rank() over(partition by userid order by Times_Bought desc) Ranks from
(select userid, count(product_id) as Times_Bought, product_id from sales
group by userid, product_id)a)b
where Ranks=1;

-- Which item was purchased first by the customer after they became member?
select * from goldusers_signup;
select * from sales;

select Sales.userid, Sales.created_date, Sales.product_id, Gold.gold_signup_date from sales as Sales inner join goldusers_signup as Gold on Sales.userid=Gold.userid
and created_date >= gold_signup_date;

select Prime.*, rank() over(partition by userid order by created_date) Ranks from
(select Sales.userid, Sales.created_date, Sales.product_id, Gold.gold_signup_date from sales as Sales inner join goldusers_signup as Gold on Sales.userid=Gold.userid
and created_date >= gold_signup_date) Prime;

select * from 
(select Prime.*, rank() over(partition by userid order by created_date) Ranks from
(select Sales.userid, Sales.created_date, Sales.product_id, Gold.gold_signup_date from sales as Sales inner join goldusers_signup as Gold on Sales.userid=Gold.userid
and created_date >= gold_signup_date) Prime) Mem where Ranks=1;

--Which item was purchased just before the customer became a member?
select * from users;
select * from sales;

select Sales.userid, Sales.created_date, Sales.product_id, Gold.gold_signup_date from sales as Sales inner join goldusers_signup as Gold on Sales.userid=Gold.userid
and created_date <= gold_signup_date;

select Prime.*, rank() over(partition by userid order by created_date) Ranks from
(select Sales.userid, Sales.created_date, Sales.product_id, Gold.gold_signup_date from sales as Sales inner join goldusers_signup as Gold on Sales.userid=Gold.userid
and created_date <= gold_signup_date) Prime;

select * from 
(select Prime.*, rank() over(partition by userid order by created_date desc) Ranks from
(select Sales.userid, Sales.created_date, Sales.product_id, Gold.gold_signup_date from sales as Sales inner join goldusers_signup as Gold on Sales.userid=Gold.userid
and created_date <= gold_signup_date) Prime) Mem where Ranks=1;

-- What is the total orders  and amount spent for each customer before they became a member?
select Sales.userid, Sales.created_date, Sales.product_id, Gold.gold_signup_date from sales as Sales inner join goldusers_signup as Gold on Sales.userid=Gold.userid
and created_date <= gold_signup_date;

select * from product;

select Orders.*, Products.price from
(select Sales.userid, Sales.created_date, Sales.product_id, Gold.gold_signup_date from sales as Sales inner join goldusers_signup as Gold on Sales.userid=Gold.userid
and created_date <= gold_signup_date) Orders inner join product Products on Orders.product_id=Products.product_id;

select userid, count(created_date) as Created, sum(price) as Purchased_Price from
(select Orders.*, Products.price from
(select Sales.userid, Sales.created_date, Sales.product_id, Gold.gold_signup_date from sales as Sales inner join goldusers_signup as Gold on Sales.userid=Gold.userid
and created_date <= gold_signup_date) Orders inner join product Products on Orders.product_id=Products.product_id) Before_Purchase
group by userid;

-- If buying each product generates points, for eg- $5=2 Zomato points and each product has different purchasing points,
-- for eg- for P1 $5=1 Zomato point, for P2 $10=5 Zomato point and P3 $5=1 Zomato point

-- We will split the question, calculate the points collected so far by the customers.
select * from sales;
select * from product;

select Sales.*, Products.price from sales as Sales inner join product as Products on Sales.product_id=Products.product_id;

select Users.userid, Users.product_id, sum(price) as Total_Amount from
(select Sales.*, Products.price from sales as Sales inner join product as Products on Sales.product_id=Products.product_id)
Users group by userid, product_id;

--For P1 -> $5=1 Zomato point
--For P2 -> $10=5 Zomato point
--For P3 -> $5=1 Zomato point

select Points.*, case when product_id=1 then 5 when product_id=2 then 2 when product_id=3 then 5 else 0 end as Total_Points from
(select Users.userid, Users.product_id, sum(price) as Total_Amount from
(select Sales.*, Products.price from sales as Sales inner join product as Products on Sales.product_id=Products.product_id)
Users group by userid, product_id) Points;

select Total_Points_Earned.*, Total_Amount/Total_Points as Total_Earned_Points from
(select Points.*, case when product_id=1 then 5 when product_id=2 then 2 when product_id=3 then 5 else 0 end as Total_Points from
(select Users.userid, Users.product_id, sum(price) as Total_Amount from
(select Sales.*, Products.price from sales as Sales inner join product as Products on Sales.product_id=Products.product_id)
Users group by userid, product_id) Points) Total_Points_Earned;

select userid, sum(Total_Earned_Points)*2.5 as Collected_Points from
(select Total_Points_Earned.*, Total_Amount/Total_Points as Total_Earned_Points from
(select Points.*, case when product_id=1 then 5 when product_id=2 then 2 when product_id=3 then 5 else 0 end as Total_Points from
(select Users.userid, Users.product_id, sum(price) as Total_Amount from
(select Sales.*, Products.price from sales as Sales inner join product as Products on Sales.product_id=Products.product_id)
Users group by userid, product_id) Points) Total_Points_Earned)PP
group by userid;

select product_id, sum(Total_Earned_Points) as Collected_Points from
(select Total_Points_Earned.*, Total_Amount/Total_Points as Total_Earned_Points from
(select Points.*, case when product_id=1 then 5 when product_id=2 then 2 when product_id=3 then 5 else 0 end as Total_Points from
(select Users.userid, Users.product_id, sum(price) as Total_Amount from
(select Sales.*, Products.price from sales as Sales inner join product as Products on Sales.product_id=Products.product_id)
Users group by userid, product_id) Points) Total_Points_Earned)PP
group by product_id;

select * from
(select *, rank() over(order by Collected_Points desc) Ranks from
(select product_id, sum(Total_Earned_Points) as Collected_Points from
(select Total_Points_Earned.*, Total_Amount/Total_Points as Total_Earned_Points from
(select Points.*, case when product_id=1 then 5 when product_id=2 then 2 when product_id=3 then 5 else 0 end as Total_Points from
(select Users.userid, Users.product_id, sum(price) as Total_Amount from
(select Sales.*, Products.price from sales as Sales inner join product as Products on Sales.product_id=Products.product_id)
Users group by userid, product_id) Points) Total_Points_Earned)PP
group by product_id) PPP)PPPP where Ranks =1;



