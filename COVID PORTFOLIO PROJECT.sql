 select * from portfolioProject.coviddeath order by 3,4;
 select * from portfolioProject.covidvacine order by 3,4

 
select location, date, total_cases, new_cases, total_deaths, population from portfolioProject.coviddeath order by 1,2;

-- total case vs total death
select location, date, total_cases,  total_deaths,(total_deaths/total_cases)*100 as deathPercentage from portfolioProject.coviddeath where location like '%Africa%'order by 1,5;

-- total cases vs population i.e percentage of people getting covid.
select location, date, total_cases, population,  
(total_cases/population)*100 
as percentageCovid from portfolioProject.coviddeath 
where location like '%Africa%'order by 1,3;

-- contry with highest infection rate conpare to polpulation
select location,population, max(total_cases), 
Max((total_cases/population))*100 
as percentagepopulationinf from portfolioProject.coviddeath 
group by location, population
order by percentagepopulationinf desc;

-- contry with highest death rate conpare to polpulation
SELECT location, MAX(CAST(total_deaths AS INT)) AS totaldea 
FROM portfolioProject.coviddeath 
GROUP BY location 
ORDER BY totaldea DESC;

SELECT location, MAX(CAST(total_deaths AS INT)) AS totaldea 
FROM portfolioProject.coviddeath 
where continent is not null
GROUP BY location 
ORDER BY totaldea DESC;

-- global numbers
select date, sum(new_cases), sum(new_deaths),total_cases, population,  
(total_cases/population)*100 
as percentageCovid from portfolioProject.coviddeath 
where continent is not null
group by date
order by 1,2;

select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum
(cast(new_deaths as int))/sum(new_cases)*100 as deathPercentage
from portfolioProject.coviddeath
where continent is not null
order by 1,2


-- looking at total population vs vaccination

-- use CTE
with popVsvac (continent, location, date, population, new_vaccination, peoplevacinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date)
 as peoplevacinated
 -- (peoplevacinated/population)*100
from portfolioProject.covidvacine vac
join portfolioProject.coviddeath dea
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
-- order by 2,3
)
select * , ((peoplevacinated/population)*100) from popVsvac



-- Using Temp Table
Drop table if exists #percentPopVAcinated
Create Table #percentPopVAcinated
(
continent nvarchar(255),
location nvarchar(255),
Date datetime,
population numeric,
new_vaccination numberic
peoplevacinated numeric
)
insert into #percentPopVAcinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date)
 as peoplevacinated
 -- (peoplevacinated/population)*100
from portfolioProject.covidvacine vac
join portfolioProject.coviddeath dea
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
-- order by 2,3
)
select * , ((peoplevacinated/population)*100) from popVsvac



creating view to store data for later visualization
create view percentPopVAcinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date)
 as peoplevacinated
 -- (peoplevacinated/population)*100
from portfolioProject.covidvacine vac
join portfolioProject.coviddeath dea
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
-- order by 2,3





