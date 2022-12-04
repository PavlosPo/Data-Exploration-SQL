SELECT continent, new_deaths As DeathsThatDay, new_cases ,date
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL 
GROUP BY continent, new_deaths, new_cases, date
ORDER BY new_deaths DESC


-- who had the most deaths in a day.
SELECT location , max(new_deaths) maxDeaths
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER BY MAX(new_deaths) DESC

-- Are the Positive rate correlated with the Deaths?
SELECT location ,AVG(CAST(positive_rate as float)), MAX(CAST(positive_rate as float)), COUNT(CAST(positive_rate as float))
FROM PortfolioProject.dbo.CovidVaccinations
GROUP BY location
ORDER BY COUNT(CAST(positive_rate as float)) DESC

-- Create Bed and Deaths temp table? 
DROP TABLE IF EXISTS #beds
CREATE  TABLE  #beds (location varchar(50), BedPT float)
INSERT INTO #beds
SELECT cd.location, MAX(hospital_beds_per_thousand) BedsPT
FROM PortfolioProject.dbo.CovidVaccinations cv
INNER JOIN PortfolioProject.dbo.CovidDeaths cd
	ON cv.location = cd.location 
WHERE cd.location <> 'OWID'
GROUP BY cd.location, hospital_beds_per_thousand  



DROP TABLE IF EXISTS #deaths


CREATE TABLE #deaths (location varchar(50), TotalDeaths int)
INSERT INTO #deaths
SELECT location, sum(new_deaths) as TotalDeaths
FROM PortfolioProject.dbo.CovidDeaths 
GROUP BY location

-- Taking Data!
 -- ! TO DO : Create a table to export location, deathTotal, death rate, BedsPerThousands. WITHOUT THE 'OWID'
DROP TABLE IF EXISTS PortfolioProject.dbo.DataToExport
CREATE TABLE PortfolioProject.dbo.DataToExport ( location varChar(50), BedsPerThousand float, TotalDeaths int)
INSERT INTO PortfolioProject.dbo.DataToExport
SELECT bd.location, bd.BedPT, db.TotalDeaths
FROM dbo.#beds bd
INNER JOIN dbo.#deaths db
	ON db.location = bd.location
INNER JOIN (SELECT iso_code, location 
			FROM PortfolioProject.dbo.CovidDeaths 
			) cd
	ON cd.location = db.location
WHERE cd.iso_code  <> 'OWID'
ORDER BY BedPT  DESC, TotalDeaths ASC

SELECT location, BedsPerThousand, TotalDeaths 
FROM PortfolioProject.dbo.DataToExport dte 
GROUP BY location , BedsPerThousand , TotalDeaths 







-- Death rate per country
SELECT location , MAX(CAST(population as float)) Population,
			SUM(CAST(new_deaths as int)) TotalDeaths, SUM(CAST(new_cases as int)) TotalCases, 
			SUM(CAST(new_deaths as float)) / SUM(CAST(new_cases as float)) DeathRate
FROM PortfolioProject.dbo.CovidDeaths
WHERE iso_code <> 'OWID'
GROUP BY location
ORDER BY DeathRate DESC


