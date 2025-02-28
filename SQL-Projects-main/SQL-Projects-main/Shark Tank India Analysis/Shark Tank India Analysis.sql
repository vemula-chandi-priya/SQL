-- Why this project?
-- Area of interest, to know about the shark tank

-- Data Source - The data was not available on the internet hence it is prepared thorugh every episodes of Shark Tank India.

-- Data Analysis & Calculations of Shark Tank India Dataset

-- Viewing the data
select * from SharkTank..Shark;

-- Column description
-- 1. Ep - Episode Number
-- 2. Brand - Startup brand for funding
-- 3. Male & Female - Company representatives
-- 4. Location - Headquarters of the startup
-- 5. Idea - Business model/idea
-- 6. Sector - Industry sector
-- 7. Deal - Secured deal among the sharks or not
-- 8. Amount Invested - Net amount invested 
-- 9. Amount Asked - Net amount asked by the management
-- 10. Equity Asked & Taken % - Equity % taken by the sharks vs asked by the management
-- 11. Avg Age - Startup average employee age
-- 12. Team members - Senior management count
-- 13. Sharks amount invested & equity taken - Names and their amount invested
-- 14. Total investors - How many sharks got in
-- 15. Partners - Shark combined

-- Initiation of Data Analysis
-- Total episodes
select count(distinct EpNo) as Total_Episodes from SharkTank..Shark;

-- Pitches - Total number of pithes done in this season
select distinct Brand from SharkTank..Shark;
select count(distinct Brand) as Total_Brands from SharkTank..Shark;

-- Pitches to investment conversion

select AmountInvestedlakhs, case when AmountInvestedlakhs > 0 then 1 else 0 end as Pitch_Converted from SharkTank..Shark;

-- Total Funding with Pitches given
select sum(Funds.Pitch_Converted) as Funding, count(*) as Total_Pitches from (
select AmountInvestedlakhs, case when AmountInvestedlakhs > 0 then 1 else 0 end as Pitch_Converted from SharkTank..Shark) Funds;

-- % of conversion
select cast(sum(Funds.Pitch_Converted) as float)/cast(count(*) as float) from (
select AmountInvestedlakhs, case when AmountInvestedlakhs > 0 then 1 else 0 end as Pitch_Converted from SharkTank..Shark) as Funds;

-- Total number of male & Female participants
select * from SharkTank..Shark;
select sum(Male) as Total_Male from SharkTank..Shark;
select sum(Female) as Total_Female from SharkTank..Shark;

-- Gender Ratio
select sum(Male)/sum(Female) as Gender_Ratio from SharkTank..Shark;

-- Total Amount Invested 
select sum(AmountInvestedlakhs) from SharkTank..Shark;

-- Average equity taken
select * from SharkTank..Shark;
select * from SharkTank..Shark where EquityTaken > 0;

select avg(Equity.EquityTaken) as Total_Equity_Taken from
(select * from SharkTank..Shark where EquityTaken > 0) as Equity;

-- Highest Deal Taken
select * from SharkTank..Shark;
select max(AmountInvestedlakhs) as Highest_Deal from SharkTank..Shark;

-- Highest Equity Taken
select * from SharkTank..Shark;
select max(EquityTaken) as Highest_Equity_Taken from SharkTank..Shark;

-- At least one female contestant
select Female, case when Female > 0 then 1 else 0 end as Female_Count from SharkTank..Shark;

select sum(Candidate.Female_Count) from (
select Female, case when Female > 0 then 1 else 0 end as Female_Count from SharkTank..Shark) Candidate;

-- Pitches converted having at least one women
select * from SharkTank..Shark;

-- Getting all the No Deal Pitches
select * from SharkTank..Shark where Deal != 'No Deal'; -- Deal done startups

select More_Female.*, case when More_Female.Female > 0 then 1 else 0 end as Female_Count from (
select * from SharkTank..Shark where Deal != 'No Deal') as More_Female; -- Have Female candidate

select sum(One_Female.Female_Count) as Have_One_Female_Candidate from (
select More_Female.*, case when More_Female.Female > 0 then 1 else 0 end as Female_Count from (
select * from SharkTank..Shark where Deal != 'No Deal') as More_Female) as One_Female;-- How many of the startups

-- Average Team Members
select avg(Teammembers) as Average_Team from SharkTank..Shark;

-- Average Amount invested per day
select * from SharkTank..Shark where Deal != 'No Deal';

select avg(Amount.AmountInvestedlakhs) as Average_Amount_Invested from (
select * from SharkTank..Shark where Deal != 'No Deal') as Amount;

-- Age Group of the Entreprenuers
select * from SharkTank..Shark;

select Avgage, count(Avgage) as Avg_Age from SharkTank..Shark group by Avgage order by Avg_Age desc;

-- Location where most pitches came from
select Location, count(Location) as Avg_Location from SharkTank..Shark group by Location order by Avg_Location desc;

-- Sector where most industries came from
select Sector, count(Sector) as Avg_Sector from SharkTank..Shark group by Sector order by Avg_Sector desc;

-- Partner Deals
select * from SharkTank..Shark;

select Partners, count(Partners) as PNP from SharkTank..Shark where Partners != '-' group by Partners order by PNP desc;

-- Creation of Matrix
-- Episodes where Ashneer was featured ------ 1
select * from SharkTank..Shark;

-- Number of Pitches Ashneer was present
select count(AshneerAmountInvested) from SharkTank..Shark where AshneerAmountInvested is not null;

-- Ashneer made a deal
select count(AshneerAmountInvested) as Total_Deals_Present from SharkTank..Shark where AshneerAmountInvested is not null and AshneerAmountInvested != 0;

-- Ashneer Total Amount Invested and Equity Taken
select sum(Ashneer.AshneerAmountInvested) as Amount_Invested, Avg(Ashneer.AshneerEquityTaken) as Equity_Taken from
(select * from SharkTank..Shark where AshneerEquityTaken !=0 and AshneerEquityTaken is not null) as Ashneer;

-- Adding Ashneer's name
select 'Ashneer' as keyy, sum(Ashneer.AshneerAmountInvested) as Amount_Invested, Avg(Ashneer.AshneerEquityTaken) as Equity_Taken from
(select * from SharkTank..Shark where AshneerEquityTaken !=0 and AshneerEquityTaken is not null) as Ashneer;


-- Performing Union and Inner join 
select First_Case.keyy, First_Case.Total_Deals_Present , First_Case.Total_Deals, Second_Case.Amount_Invested, Second_Case.Equity_Taken from (
select Ash.keyy, Ash.Total_Deals_Present, Grover.Total_Deals from (
select 'Ashneer' as keyy, count(AshneerAmountInvested) as Total_Deals_Present from SharkTank..Shark where AshneerAmountInvested is not null) as Ash

inner join (
select 'Ashneer' as keyy, count(AshneerAmountInvested) as Total_Deals from SharkTank..Shark 
where AshneerAmountInvested is not null and AshneerAmountInvested != 0) as Grover

on Ash.keyy=Grover.keyy) as First_Case

inner join (
select 'Ashneer' as keyy, sum(Ashneer.AshneerAmountInvested) as Amount_Invested, Avg(Ashneer.AshneerEquityTaken) as Equity_Taken from
(select * from SharkTank..Shark where AshneerEquityTaken !=0 and AshneerEquityTaken is not null) as Ashneer) as Second_Case

on First_Case.keyy=Second_Case.keyy;

-- Episodes where Namita was featured ----- 2
select * from SharkTank..Shark;

-- Number of Pitches Namita was present
select count(NamitaAmountInvested) from SharkTank..Shark where NamitaAmountInvested is not null;

-- Namita made a deal
select count(NamitaAmountInvested) as Total_Deals_Present from SharkTank..Shark where NamitaAmountInvested is not null and NamitaAmountInvested != 0;

-- Namita Total Amount Invested and Equity Taken
select sum(Namita.NamitaAmountInvested) as Amount_Invested, Avg(Namita.NamitaEquityTaken) as Equity_Taken from
(select * from SharkTank..Shark where NamitaEquityTaken !=0 and NamitaEquityTaken is not null) as Namita;

-- Adding Namita's name
select 'Namita' as keyy, sum(Namita.NamitaAmountInvested) as Amount_Invested, Avg(Namita.NamitaEquityTaken) as Equity_Taken from
(select * from SharkTank..Shark where NamitaEquityTaken !=0 and NamitaEquityTaken is not null) as Namita;


-- Performing Union and Inner join 
select First_Case.keyy, First_Case.Total_Deals_Present , First_Case.Total_Deals, Second_Case.Amount_Invested, Second_Case.Equity_Taken from (
select Nam.keyy, Nam.Total_Deals_Present, Thapar.Total_Deals from (
select 'Namita' as keyy, count(NamitaAmountInvested) as Total_Deals_Present from SharkTank..Shark where NamitaAmountInvested is not null) as Nam

inner join (
select 'Namita' as keyy, count(NamitaAmountInvested) as Total_Deals from SharkTank..Shark 
where NamitaAmountInvested is not null and NamitaAmountInvested != 0) as Thapar

on Nam.keyy=Thapar.keyy) as First_Case

inner join (
select 'Namita' as keyy, sum(Namita.NamitaAmountInvested) as Amount_Invested, Avg(Namita.NamitaEquityTaken) as Equity_Taken from
(select * from SharkTank..Shark where NamitaEquityTaken !=0 and NamitaEquityTaken is not null) as Namita) as Second_Case

on First_Case.keyy=Second_Case.keyy;


-- Using Union function to display the matrix for Namita and Ashneer
SELECT 
    First_Case.keyy, 
    First_Case.Total_Deals_Present, 
    First_Case.Total_Deals, 
    Second_Case.Amount_Invested, 
    Second_Case.Equity_Taken
FROM (
    SELECT 
        Ash.keyy, 
        Ash.Total_Deals_Present, 
        Grover.Total_Deals
    FROM 
        (SELECT 'Ashneer' AS keyy, COUNT(AshneerAmountInvested) AS Total_Deals_Present 
         FROM SharkTank..Shark 
         WHERE AshneerAmountInvested IS NOT NULL) AS Ash

    INNER JOIN 
        (SELECT 'Ashneer' AS keyy, COUNT(AshneerAmountInvested) AS Total_Deals 
         FROM SharkTank..Shark 
         WHERE AshneerAmountInvested IS NOT NULL AND AshneerAmountInvested != 0) AS Grover

    ON Ash.keyy = Grover.keyy
) AS First_Case

INNER JOIN (
    SELECT 
        'Ashneer' AS keyy, 
        SUM(Ashneer.AshneerAmountInvested) AS Amount_Invested, 
        AVG(Ashneer.AshneerEquityTaken) AS Equity_Taken
    FROM 
        (SELECT * 
         FROM SharkTank..Shark 
         WHERE AshneerEquityTaken != 0 AND AshneerEquityTaken IS NOT NULL) AS Ashneer
) AS Second_Case

ON First_Case.keyy = Second_Case.keyy

UNION ALL

SELECT 
    First_Case.keyy, 
    First_Case.Total_Deals_Present, 
    First_Case.Total_Deals, 
    Second_Case.Amount_Invested, 
    Second_Case.Equity_Taken
FROM (
    SELECT 
        Nam.keyy, 
        Nam.Total_Deals_Present, 
        Thapar.Total_Deals
    FROM 
        (SELECT 'Namita' AS keyy, COUNT(NamitaAmountInvested) AS Total_Deals_Present 
         FROM SharkTank..Shark 
         WHERE NamitaAmountInvested IS NOT NULL) AS Nam

    INNER JOIN 
        (SELECT 'Namita' AS keyy, COUNT(NamitaAmountInvested) AS Total_Deals 
         FROM SharkTank..Shark 
         WHERE NamitaAmountInvested IS NOT NULL AND NamitaAmountInvested != 0) AS Thapar

    ON Nam.keyy = Thapar.keyy
) AS First_Case

INNER JOIN (
    SELECT 
        'Namita' AS keyy, 
        SUM(Namita.NamitaAmountInvested) AS Amount_Invested, 
        AVG(Namita.NamitaEquityTaken) AS Equity_Taken
    FROM 
        (SELECT * 
         FROM SharkTank..Shark 
         WHERE NamitaEquityTaken != 0 AND NamitaEquityTaken IS NOT NULL) AS Namita
) AS Second_Case

ON First_Case.keyy = Second_Case.keyy;


-- Window functions
select * from SharkTank..Shark;

-- Which startup got highest funding in each sector
select distinct Rankss.* from (
select Brand, Sector, AmountInvestedlakhs, rank() over(partition by Sector order by AmountInvestedlakhs desc) as Ranks
from SharkTank..Shark) as Rankss
where Rankss.Ranks=1;