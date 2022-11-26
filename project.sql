--SELECT *
--FROM PortfolioProject..CovidDeaths
--order by 3, 4

--SELECT *
--FROM PortfolioProject..CovidVaccinations
--order by 3, 4


-- Select Data that we are going to be using

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT Null
order by 1, 2


-- LOOKING AT:  Total Cases vs. Population
	-- Shows the likelihood of dying if you contract covid in Greece

SELECT Location, date, total_cases, total_deaths, (CAST(total_deaths As Float) / CAST(total_cases as float))*100 As DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE Location LIKE 'Greece' AND continent IS NOT NULL
ORDER BY date DESC



-- LOOKING AT: Total Cases vs. Population 
	-- Shows what percentage of population got Covid
SELECT Location, date, total_cases, total_deaths, Population, (CAST(total_cases As Float) / CAST(Population as float))*100 As PercentagePopulationInfected
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT Null
ORDER BY date DESC


-- LOOKING AT: Countries with Highest Infection Rate compared to Population
SELECT Location, Population, MAX(total_cases) As HighestInfectionCount,  MAX(((CAST(total_cases As Float)/CAST(Population as float))*100)) As PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT Null
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC


-- LOOKING AT: Countries with Highest Death Count per Population
SELECT Location, MAX(total_deaths) As TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY Location, Population
ORDER BY TotalDeathCount DESC

