--SELECT *
--FROM PortfolioProject..CovidDeaths
--order by 3, 4

--SELECT *
--FROM PortfolioProject..CovidVaccinations
--order by 3, 4


-- Select Data that we are going to be using

SELECT continent, MAX(total_cases) As TotalCases, MAX(total_deaths) As TotalDeaths, MAX(Population) As Population
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT Null
GROUP BY continent


-- LOOKING AT:  Total Cases vs. Population
	-- Shows the likelihood of dying if you contract covid in Greece

SELECT continent, MAX(total_cases) as TotalCases, MAX(total_deaths) as TotalDeaths,  (Max(total_deaths) / CAST(MAX(total_cases) as float)) * 100 As DeathPercentage 
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent



-- LOOKING AT: Total Cases vs. Population 
	-- Shows what percentage of population got Covid
SELECT continent, Max(total_cases) As TotalCases, MAX(total_deaths) As TotalDeaths, MAX(Population) As Population, 
	ROUND((CAST(MAX(total_cases) As Float) / CAST(MAX(Population) as float))*100, 2) As PercentagePopulationInfected
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT Null
GROUP BY continent


-- LOOKING AT: Countries with Highest Infection Rate compared to Population
SELECT Location, Population, MAX(total_cases) As HighestInfectionCount,  MAX(((CAST(total_cases As Float)/CAST(Population as float))*100)) As PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT Null 
GROUP BY Location, Population
--HAVING HighestInfectionCount = NULL --Clears some data
ORDER BY PercentPopulationInfected, HighestInfectionCount DESC





-- LOOKING AT: Countries with Highest Death Count per Population
SELECT Location, MAX(total_deaths) As TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY Location, Population
ORDER BY TotalDeathCount DESC




-- LET'S BREAK THINGS DOWN BY CONTINENT
-- LOOKING AT: Showing continents with the highest DeathCount
SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL 
GROUP BY continent
ORDER BY TotalDeathCount DESC

-- GLOBAL NUMBERS
-- (PerDay)
SELECT date, SUM(new_cases) CasesPerDay, SUM(new_deaths) DeathsPerDay, (SUM(new_deaths) / CAST(SUM(new_cases) as float)) * 100 As DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths 
WHERE continent IS NOT NULL
GROUP BY date


-- Looking at Total Population vs Vaccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS float)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.date) As VaccinatedTillThen
FROM PortfolioProject.dbo.CovidDeaths dea
JOIN PortfolioProject.dbo.CovidVaccinations vac
	ON dea.location = vac.location 
	and dea.date = vac.date 
WHERE dea.continent IS NOT NULL
ORDER BY 2, 3


-- USE CTE 

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS (
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS float)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.date) As VaccinatedTillThen
FROM PortfolioProject.dbo.CovidDeaths dea
JOIN PortfolioProject.dbo.CovidVaccinations vac
	ON dea.location = vac.location 
	and dea.date = vac.date 
WHERE dea.continent IS NOT NULL -- Doesn't count continents but only countries.
		)

SELECT *, ROUND((RollingPeopleVaccinated/CAST(Population as float))*100,4) PercentVaccinatedTillThen
FROM PopvsVac
ORDER BY Continent, Location, Date


-- TEMP TABLE
DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
	Continent nvarchar(255),
	Location nvarchar(255),
	Data datetime,
	Population numeric,
	New_vaccinations numeric,
	RollingPeopleVaccinated numeric 	
		)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(CAST(vac.new_vaccinations as float)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.date) As VaccinatedTillThen
FROM PortfolioProject.dbo.CovidDeaths dea
JOIN PortfolioProject.dbo.CovidVaccinations vac
	ON dea.location = vac.location 
	and dea.date = vac.date 
WHERE dea.continent IS NOT NULL -- Doesn't count continents but only countries.

SELECT *
FROM #PercentPopulationVaccinated
WHERE RollingPeopleVaccinated <> 0



-- CREATING: View to store data for later visualizations
CREATE View PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, CAST(vac.new_vaccinations as int) New_Vaccinations 
, SUM(CAST(vac.new_vaccinations as float)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.date) As VaccinatedTillThen
FROM PortfolioProject.dbo.CovidDeaths dea
JOIN PortfolioProject.dbo.CovidVaccinations vac
	ON dea.location = vac.location 
	and dea.date = vac.date 
WHERE dea.continent IS NOT NULL -- Doesn't count continents but only countries.









