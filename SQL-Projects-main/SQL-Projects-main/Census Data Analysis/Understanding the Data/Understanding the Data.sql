-- Basic Data Analysis

-- Upload/Import the data (Steps)
-- 1. Create a database of your own and name it. To create a database, right click on database and click 'New Database'
-- 2. Name your database and save it.
-- 3. Right click on the created database and search for the 'Tasks'
-- 4. Scroll down and you will see import data, click on that.
-- 5. Click 'Next', select the type of data source and the version and 'Finish'
-- 6. You will be able to see your imported dataset now

-- Visualise the dataframe
select * from project.dbo.Data1;
select * from project.dbo.Data2;

-- number of rows in our dataset
select count (*) from project..Data1;
select count (*) from project..Data2;

-- Generate data for only 2 states
select * from project..Data1 where State in ('Maharastra', 'West Bengal');

-- Population of India
select * from project..Data2;
select sum(Population) as Population from project..Data2;

-- Average growth in India
select * from project..Data1;
select * from project..Data2; -- Growth column exists only in Data1
select avg(Growth)*100 as Avg_Growth from project..Data1;

-- Average Growth by State
select * from project..Data1;
select State, avg(Growth)*100 as Avg_Growth from project..Data1 group by State;

-- Average Sex Ratio per State
select * from project..Data1;
select State, round(avg(Sex_Ratio), 0) as Avg_SexRatio from project..Data1 group by State;
select State, round(avg(Sex_Ratio), 0) as Avg_SexRatio from project..Data1 group by State order by Avg_SexRatio desc;

-- Average Literacy Rate
select State, round(avg(Literacy), 0) as Avg_Literacy from project..Data1 group by State order by Avg_Literacy desc;

-- Literacy Ratio greater than 90
select State, round(avg(Literacy), 0) as Avg_LiteracyRatio from project..Data1 
group by State having round(avg(literacy),0)>90 order by Avg_LiteracyRatio desc;

-- Top 3 States which has highest growth % ratio
select top 3 State, avg(Growth)*100 as Avg_Growth from project..Data1 group by State order by Avg_Growth desc;

-- Using the same with Limit function
select State, avg(Growth)*100 as Avg_Growth from project..Data1 group by State order by Avg_Growth desc limit 3;

-- Lowest 3 States showing sex ratio
select top 3 State, round(avg(Sex_Ratio), 0) as avg_SexRatio from project..Data1 group by State order by avg_SexRatio asc;

-- Top and Bottom 3 States in Literacy Rate

--Top
select * from project..Data1;

drop table if exists Top_Literacy;

create table Top_Literacy
(State nvarchar(255), Top_States float)

insert into Top_Literacy
select State, round(avg(literacy), 0) as avg_LiteracyRatio from project..Data1
group by State order by avg_LiteracyRatio desc;

select * from Top_Literacy;
select top 3 * from Top_Literacy order by Top_States desc;

-- Bottom
select * from project..Data1;

drop table if exists Bottom_Literacy;

create table Bottom_Literacy
(State nvarchar(255), Bottom_States float)

insert into Bottom_Literacy
select State, round(avg(literacy), 0) as avg_LiteracyRatio from project..Data1
group by State order by avg_LiteracyRatio desc;

select * from Bottom_Literacy;
select top 3 * from Bottom_Literacy order by Bottom_States asc;

-- Using Union operator to join both top & bottom tables -> This operator is only used when the number 
-- of columns are same in both the created tables
select * from (
select top 3 * from Bottom_Literacy order by Bottom_States asc) a
union
select * from (
select top 3 * from Top_Literacy order by Top_States desc) b;

-- Filter out data of states starting with letter A
select * from project..Data1 where State like '%A';