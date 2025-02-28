-- Using Joins and other SQL functions

select * from project..Data1;

select * from project..Data2;

-- Total Males & Females
-- Joining the table with district as joining with States will join the State entry of other
select Dataset1.District, Dataset1.State, Dataset1.Sex_Ratio/1000, Dataset2.Population from project..Data1 as Dataset1 inner join project..Data2 as Dataset2 on Dataset1.District=Dataset2.District;

-- We know, Females/Males = Sex_Ratio ------- 1 
-- Females + Males = Population -------- 2
-- Females = Population - Males ------ 3
-- (Population - Males) = (Sex_Ratio * Males)
-- Population = (Sex_Ratio * Males) + Males
-- Males = Population/(Sex_Ratio + 1) -------- 4
-- Females = Population - (Population/(Sex_Ratio + 1)) ------- 5

-- Using  equation 4 & 5 we will solve the problem
select Gender_Ratio.District, Gender_Ratio.State, round(Gender_Ratio.Population/(Gender_Ratio.Sex_Ratio + 1), 0) as Male, round(((Gender_Ratio.Population) -((Gender_Ratio.Population)/(Gender_Ratio.Sex_Ratio + 1))), 0) as Female from 
(select Dataset1.District, Dataset1.State, Dataset1.Sex_Ratio/1000 as Sex_Ratio, Dataset2.Population from project..Data1 as Dataset1 inner join project..Data2 as Dataset2 on Dataset1.District=Dataset2.District) as Gender_Ratio;

-- For State Level Data
select State_Level.State, sum(State_Level.Male) as Total_Male, sum(State_Level.Female) as Total_Female from
(select Gender_Ratio.District, Gender_Ratio.State, round(Gender_Ratio.Population/(Gender_Ratio.Sex_Ratio + 1), 0) as Male, round(((Gender_Ratio.Population) -((Gender_Ratio.Population)/(Gender_Ratio.Sex_Ratio + 1))), 0) as Female from 
(select Dataset1.District, Dataset1.State, Dataset1.Sex_Ratio/1000 as Sex_Ratio, Dataset2.Population from project..Data1 as Dataset1 inner join project..Data2 as Dataset2 on Dataset1.District=Dataset2.District) as Gender_Ratio) as State_Level
group by State_Level.State;

-- Total Literacy Rate
select Dataset1.District, Dataset1.State, Dataset1.Literacy as Literacy_Ratio, Dataset2.Population from project..Data1 as Dataset1 inner join project..Data2 as Dataset2 on Dataset1.District=Dataset2.District;

-- Literacy_Ratio = Total_Literate/Population ------ 1
-- Total_Literate = Literacy_Ratio * Population -------- 2
-- Total_Illiterate = 1 - Literacy_Ratio) * Population ------ 3

-- We will use Equation 2 & 3 to solve the problem
select Literacy_Distribution.District, Literacy_Distribution.State, round((Literacy_Distribution.Literacy_Ratio * Literacy_Distribution.Population), 0) as Literate, round((1 - Literacy_Distribution.Literacy_Ratio) * Literacy_Distribution.Population,0) as Illiterate from
(select Dataset1.District, Dataset1.State, Dataset1.Literacy/100 as Literacy_Ratio, Dataset2.Population from project..Data1 as Dataset1 inner join project..Data2 as Dataset2 on Dataset1.District=Dataset2.District) as Literacy_Distribution;

-- By State Level
select State_Level.State, sum(Literate) as Total_Literate_Population, sum(Illiterate) as Total_Illiterate_Population from
(select Literacy_Distribution.District, Literacy_Distribution.State, round((Literacy_Distribution.Literacy_Ratio * Literacy_Distribution.Population), 0) as Literate, round((1 - Literacy_Distribution.Literacy_Ratio) * Literacy_Distribution.Population,0) as Illiterate from
(select Dataset1.District, Dataset1.State, Dataset1.Literacy/100 as Literacy_Ratio, Dataset2.Population from project..Data1 as Dataset1 inner join project..Data2 as Dataset2 on Dataset1.District=Dataset2.District) as Literacy_Distribution) as State_Level
group by State_Level.State;

--  Population in Previous Census
select Dataset1.District, Dataset1.State, Dataset1.Growth as Growth_Ratio, Dataset2.Population from project..Data1 as Dataset1 inner join project..Data2 as Dataset2 on Dataset1.District=Dataset2.District;

-- We have population of the current census. So, previous census will be
-- Population = Previous_Census + (Growth * Previous_Census)
-- Previous_Census = Population/(1 + Growth) ------ 1

select Census.District, Census.State, round(Census.Population/(1 + Census.Growth_Ratio), 0) as Previous_Census, Population as Current_Census from
(select Dataset1.District, Dataset1.State, Dataset1.Growth as Growth_Ratio, Dataset2.Population from project..Data1 as Dataset1 inner join project..Data2 as Dataset2 on Dataset1.District=Dataset2.District) as Census;

-- By State Level and Average Growth
select State_Level.State, sum(State_Level.Previous_Census) as Previous_Census, sum(State_Level.Current_Census) as Current_Census from
(select Census.District, Census.State, round(Census.Population/(1 + Census.Growth_Ratio), 0) as Previous_Census, Population as Current_Census from
(select Dataset1.District, Dataset1.State, Dataset1.Growth as Growth_Ratio, Dataset2.Population from project..Data1 as Dataset1 inner join project..Data2 as Dataset2 on Dataset1.District=Dataset2.District) as Census) as State_Level
group by State_Level.State;

-- Population of India in current and previous census
select sum(India.Previous_Census) as Previous_Census, sum(India.Current_Census) as Current_Census from
(select State_Level.State, sum(State_Level.Previous_Census) as Previous_Census, sum(State_Level.Current_Census) as Current_Census from
(select Census.District, Census.State, round(Census.Population/(1 + Census.Growth_Ratio), 0) as Previous_Census, Population as Current_Census from
(select Dataset1.District, Dataset1.State, Dataset1.Growth as Growth_Ratio, Dataset2.Population from project..Data1 as Dataset1 inner join project..Data2 as Dataset2 on Dataset1.District=Dataset2.District) as Census) as State_Level
group by State_Level.State) India;

-- Population v/s Area
-- We have previous and current census population, getting the sum of Area_km2 will be India's Total Area
select * from project..Data2;

-- Previous & Current Census
select sum(India.Previous_Census) as Previous_Census, sum(India.Current_Census) as Current_Census from
(select State_Level.State, sum(State_Level.Previous_Census) as Previous_Census, sum(State_Level.Current_Census) as Current_Census from
(select Census.District, Census.State, round(Census.Population/(1 + Census.Growth_Ratio), 0) as Previous_Census, Population as Current_Census from
(select Dataset1.District, Dataset1.State, Dataset1.Growth as Growth_Ratio, Dataset2.Population from project..Data1 as Dataset1 inner join project..Data2 as Dataset2 on Dataset1.District=Dataset2.District) as Census) as State_Level
group by State_Level.State) India;

-- Total Area
select sum(Area_km2) as Total_Area from project..Data2;

-- Joining both the tables (Census & Area) won't be possible as they don't have any common relation
-- To solve this case, we will assign a key value to both the tables

-- Assigning key to Census Data
select '1' as keyy, Census.*from
(select sum(India.Previous_Census) as Previous_Census, sum(India.Current_Census) as Current_Census from
(select State_Level.State, sum(State_Level.Previous_Census) as Previous_Census, sum(State_Level.Current_Census) as Current_Census from
(select Census.District, Census.State, round(Census.Population/(1 + Census.Growth_Ratio), 0) as Previous_Census, Population as Current_Census from
(select Dataset1.District, Dataset1.State, Dataset1.Growth as Growth_Ratio, Dataset2.Population from project..Data1 as Dataset1 inner join project..Data2 as Dataset2 on Dataset1.District=Dataset2.District) as Census) as State_Level
group by State_Level.State) India) Census;

-- Assigning key to Area Data
select '1' as keyy, Area.*from
(select sum(Area_km2) as Total_Area from project..Data2) Area;

-- Now we can join the Census & Area Data
select Census_Data.*, Area_Data.*from
(select '1' as keyy, Census.*from
(select sum(India.Previous_Census) as Previous_Census, sum(India.Current_Census) as Current_Census from
(select State_Level.State, sum(State_Level.Previous_Census) as Previous_Census, sum(State_Level.Current_Census) as Current_Census from
(select Census.District, Census.State, round(Census.Population/(1 + Census.Growth_Ratio), 0) as Previous_Census, Population as Current_Census from
(select Dataset1.District, Dataset1.State, Dataset1.Growth as Growth_Ratio, Dataset2.Population from project..Data1 as Dataset1 inner join project..Data2 as Dataset2 on Dataset1.District=Dataset2.District) as Census) as State_Level
group by State_Level.State) India) Census) Census_Data inner join (

select '1' as keyy, Area.*from
(select sum(Area_km2) as Total_Area from project..Data2) Area) Area_Data on Census_Data.keyy = Area_Data.keyy;

-- How much Area has been decreased from the previous population
select (Decreased_Area.Total_Area/Decreased_Area.Previous_Census) as Previous_Census_Population, (Decreased_Area.Total_Area/Decreased_Area.Current_Census) as Current_Census_Population from 
(select Census_Data.*, Area_Data.Total_Area from
(select '1' as keyy, Census.*from
(select sum(India.Previous_Census) as Previous_Census, sum(India.Current_Census) as Current_Census from
(select State_Level.State, sum(State_Level.Previous_Census) as Previous_Census, sum(State_Level.Current_Census) as Current_Census from
(select Census.District, Census.State, round(Census.Population/(1 + Census.Growth_Ratio), 0) as Previous_Census, Population as Current_Census from
(select Dataset1.District, Dataset1.State, Dataset1.Growth as Growth_Ratio, Dataset2.Population from project..Data1 as Dataset1 inner join project..Data2 as Dataset2 on Dataset1.District=Dataset2.District) as Census) as State_Level
group by State_Level.State) India) Census) Census_Data inner join (

select '1' as keyy, Area.*from
(select sum(Area_km2) as Total_Area from project..Data2) Area) Area_Data on Census_Data.keyy = Area_Data.keyy) Decreased_Area;


-- Using Window functions
select * from project..Data1;

-- Give me the output of top 3 States which has highest literacy rate using window function
select District, State, Literacy, rank() over(partition by State order by Literacy desc) Ranks from project..Data1;

-- As we need only top 3 States
select Highest.* from
(select State, District, Literacy, rank() over(partition by State order by Literacy desc) Ranks from project..Data1) Highest
where Highest.Ranks in (1,2,3) order by State;

-- For Bottom 3 States
select Lowest.*from
(select State, District, Literacy, rank() over(partition by State order by Literacy asc) Ranks from project..Data1) Lowest
where Lowest.Ranks in (1,2,3) order by State;

-- Display both Top and Bottom Literacy Rate Districts in one table using Union
select State, District, Literacy, 'Top' AS Rank_Type, Ranks from
(select State, District, Literacy, rank() over (partition by State order by Literacy desc) as Ranks from project..Data1) 
as Highest where Ranks IN (1, 2, 3)

union all

select State, District, Literacy, 'Bottom' AS Rank_Type, Ranks from 
(select State, District, Literacy, rank() over (partition by State order by Literacy asc) as Ranks from project..Data1) AS Lowest
where Ranks in (1, 2, 3) order by State, Rank_Type, Ranks;
