/*
 * covid-19 data exploration
 */

select * from full_grouped;

select * from worldometer_data;

-- Confirmed vs Recovered all over the world
select [Country/Region],[Date], Confirmed , Recovered, round((Recovered*100)/Confirmed,1) as recovered_Percentage
from projects_db.dbo.full_grouped fg
where Confirmed >= 1
order by [Country/Region];


-- Confirmed vs Deaths all over the world
select [Country/Region],[Date], Confirmed , Deaths, round((Deaths*100)/Confirmed,1) as death_Percentage
from projects_db.dbo.full_grouped fg
where Deaths >= 1 
order by [Date];

-- Confirmed vs Recovered in India
select [Country/Region],[Date], Confirmed , Recovered, round((Recovered*100)/Confirmed,1) as recovered_Percentage
from projects_db.dbo.full_grouped fg
where Confirmed >= 1 and [Country/Region] like '%India%'
order by [Country/Region];

-- Confirmed vs Deaths in India
select [Country/Region],[Date], Confirmed , Deaths, round((Deaths*100)/Confirmed,1) as death_Percentage
from projects_db.dbo.full_grouped fg
where Deaths >= 1 and [Country/Region] like '%India%'
order by [Date];

-- each country
select [Country/Region], Population, TotalCases, coalesce(TotalDeaths,0) as Total_deaths, 
TotalRecovered, coalesce(ActiveCases,0) as Active_cases,
coalesce([Serious,Critical],0) as serious_or_critical
from worldometer_data wd
where Population is not null and TotalCases is not null and TotalRecovered is not null
order by 1;

-- total cases vs total deaths 
select 
[Country/Region], Population, TotalCases, coalesce(TotalDeaths,0) as Total_deaths, round(TotalDeaths*100/TotalCases,1) as death_percentage
from worldometer_data wd
where population is not null
order by 1;

-- Total cases vs population
-- Shows what percentage of population infected with Covid
select 
[Country/Region], Population, TotalCases, round(TotalCases*100.0/Population,3) as PercentPopulationInfected
from worldometer_data wd
where population is not null
order by 1;

-- Countries with Highest Infection Rate compared to Population
select 
[Country/Region], Population, TotalCases, round(TotalCases*100.0/Population,3) as PercentPopulationInfected
from worldometer_data wd 
where Population is not null  
order by PercentPopulationInfected desc;

-- Countries with Highest Death percentage per Population
select 
[Country/Region], Population, coalesce(TotalDeaths,0) as Total_deaths,
COALESCE(round(TotalDeaths*100.0/Population,5),0) as Total_death_percent
from worldometer_data wd 
where Population is not null  
order by Total_death_percent desc;

-- Showing countries with the highest death count per population
select [Country/Region],MAX(Population)as population,coalesce(MAX(TotalDeaths),0) as total_deaths 
from worldometer_data wd 
where [Country/Region] is not null  
group by [Country/Region] 
order by total_deaths desc;

-- Showing Continents with highest death count per population
select Continent, MAX(Population) as Population, coalesce(MAX(TotalDeaths),0) as total_deaths  
from worldometer_data wd 
where Continent is not null and Population is not null
group by Continent 
order by total_deaths desc;

-- Global numbers by date
select [Date], sum(Confirmed) as total_confirmed, sum(Deaths) as total_death,
sum(Recovered) as total_recovered, sum(Active) as total_active
from full_grouped fg  
group by [Date]
order by 1;

-- totally across the world
select sum(Confirmed) as total_confirmed, sum(Deaths) as total_death,
sum(Recovered) as total_recovered, sum(Active) as total_active,
round(sum(Deaths)*100.0/sum(Confirmed),1) as death_percentage
from full_grouped fg 
order by 1,2;








