-- select FirstName, LastName, Salary, Gender, count(Gender) over (partition by Gender) as totalGender from employeeDemographics demo
-- join employeeSalary sal on demo.EmployeeID = sal.EmployeeID

-- select FirstName, LastName, Salary, Gender, count(Gender) from employeeDemographics demo
-- join employeeSalary sal on demo.EmployeeID = sal.EmployeeID group by FirstName, LastName, Salary, Gender

-- with cte_Employee as ( select FirstName, LastName, Salary, Gender, count(Gender) over (partition by Gender) as totalGender, avg(Salary) over (partition by Salary) as averageSalary from employeeDemographics demo join employeeSalary sal on demo.EmployeeID = sal.EmployeeID where Salary > '45000')
-- select * from cte_Employee

-- CREATE TEMPORARY TABLE temp_employee (
--     EmployeeID INT,
--     JobTitle VARCHAR(100),
--     Salary INT
-- );
-- insert into temp_employee values (
-- '1001', 'HR', '45000'
-- )

-- insert into temp_employee
-- select * from freecodetest.EmployeeSalary

-- create TEMPORARY TABLE temp_employee2(
-- Jobtitile varchar(50),
-- employeesPerJob int,
-- Avgage int,
-- AvgSalary int
-- )

-- insert into temp_employee2(
-- )select Jobtitle, count(Jobtitle), avg(age), avg(salary) from freecodetest.EmployeeDemographics emp join freecodetest.EmployeeSalary sal on emp.EmployeeID = sal.EmployeeID group by JobTitle

-- select * from temp_employee2

-- CREATE TABLE EmployeeErrors (
-- EmployeeID varchar(50)
-- ,FirstName varchar(50)
-- ,LastName varchar(50)
-- );
-- Insert into EmployeeErrors Values 
-- ('1001  ', 'Jimbo', 'Halbert')
-- ,('  1002', 'Pamela', 'Beasely')
-- ,('1005', 'TOby', 'Flenderson - Fired')

-- Select *
-- From EmployeeErrors

-- TRiming
-- select EmployeeID, trim(EmployeeID) as IDtrim from EmployeeErrors;

-- select EmployeeID, ltrim(EmployeeID) as IDltrim from EmployeeErrors;
-- select EmployeeID, rtrim(EmployeeID) as IDrtrim from EmployeeErrors

-- USING REPLACED
-- select LastName, replace(LastName, '- Fired', '') as LastNameFixed from EmployeeErrors

-- Using Substring
-- Select Substring(err.FirstName,1,3), Substring(dem.FirstName,1,3), Substring(err.LastName,1,3), Substring(dem.LastName,1,3)
-- FROM EmployeeErrors err
-- JOIN EmployeeDemographics dem
-- 	on Substring(err.FirstName,1,3) = Substring(dem.FirstName,1,3)
-- 	and Substring(err.LastName,1,3) = Substring(dem.LastName,1,3)

-- UPPER AND LOWERCASE
-- Select firstname, LOWER(firstname)
-- from EmployeeErrors;

-- Select Firstname, UPPER(FirstName)
-- from EmployeeErrors

-- CREATE PROCEDURE Temp_Employee
-- AS
-- DROP TABLE IF EXISTS #temp_employee
-- Create table #temp_employee (
-- JobTitle varchar(100),
-- EmployeesPerJob int ,
-- AvgAge int,
-- AvgSalary int
-- )

-- Subquery in select
-- select employeeID, salary,(select avg(salary) from employeesalary) as averageSal from employeesalary;

-- How to do partionby 

-- select employeeID, salary, avg(salary) over() as averageSal from employeesalary;

-- Select a.EmployeeID, AllAvgSalary
-- From 
-- 	(Select EmployeeID, Salary, AVG(Salary) over () as AllAvgSalary
-- 	 From EmployeeSalary) a
-- Order by a.EmployeeID

-- Select EmployeeID, JobTitle, Salary
-- From EmployeeSalary
-- where EmployeeID in (
-- 	Select EmployeeID 
-- 	From EmployeeDemographics
-- 	where Age > 30)


-- select * from portfolioProject.coviddeath order by 3,4;
-- select * from portfolioProject.covidvacine order by 3,4


-- select location, date, total_cases, new_cases, total_deaths, population from portfolioProject.coviddeath order by 1,2;

-- total case vs total death
-- select location, date, total_cases,  total_deaths,(total_deaths/total_cases)*100 as deathPercentage from portfolioProject.coviddeath where location like '%Africa%'order by 1,5;

-- total cases vs population i.e percentage of people getting covid.
-- select location, date, total_cases, population,  
-- (total_cases/population)*100 
-- as percentageCovid from portfolioProject.coviddeath 
-- where location like '%Africa%'order by 1,3;

-- contry with highest infection rate conpare to polpulation
-- select location,population, max(total_cases), 
-- Max((total_cases/population))*100 
-- as percentagepopulationinf from portfolioProject.coviddeath 
-- group by location, population
-- order by percentagepopulationinf desc;

-- contry with highest death rate conpare to polpulation
-- SELECT location, MAX(CAST(total_deaths AS INT)) AS totaldea 
-- FROM portfolioProject.coviddeath 
-- GROUP BY location 
-- ORDER BY totaldea DESC;

-- SELECT location, MAX(CAST(total_deaths AS INT)) AS totaldea 
-- FROM portfolioProject.coviddeath 
-- where continent is not null
-- GROUP BY location 
-- ORDER BY totaldea DESC;

-- global numbers
-- select date, sum(new_cases), sum(new_deaths),total_cases, population,  
-- (total_cases/population)*100 
-- as percentageCovid from portfolioProject.coviddeath 
-- where continent is not null
-- group by date
-- order by 1,2;

-- select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum
-- (cast(new_deaths as int))/sum(new_cases)*100 as deathPercentage
-- from portfolioProject.coviddeath
-- where continent is not null
-- order by 1,2


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
-- Drop table if exists #percentPopVAcinated
-- Create Table #percentPopVAcinated
-- (
-- continent nvarchar(255),
-- location nvarchar(255),
-- Date datetime,
-- population numeric,
-- new_vaccination numberic
-- peoplevacinated numeric
-- )
-- insert into #percentPopVAcinated
-- select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
-- sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date)
--  as peoplevacinated
--  -- (peoplevacinated/population)*100
-- from portfolioProject.covidvacine vac
-- join portfolioProject.coviddeath dea
-- on dea.location = vac.location
-- and dea.date = vac.date
-- where dea.continent is not null
-- -- order by 2,3
-- )
-- select * , ((peoplevacinated/population)*100) from popVsvac



-- creating view to store data for later visualization
-- create view percentPopVAcinated as 
-- select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
-- sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date)
--  as peoplevacinated
--  -- (peoplevacinated/population)*100
-- from portfolioProject.covidvacine vac
-- join portfolioProject.coviddeath dea
-- on dea.location = vac.location
-- and dea.date = vac.date
-- where dea.continent is not null
-- -- order by 2,3

