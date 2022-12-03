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

-- Beds and deaths? 

SELECT gdp_per_capita
FROM PortfolioProject.dbo.CovidVaccinations 
GROUP BY gdp_per_capita 

-- Death rate per country
SELECT location , MAX(CAST(population as float)) Population,
			SUM(CAST(new_deaths as int)) TotalDeaths, SUM(CAST(new_cases as int)) TotalCases, 
			SUM(CAST(new_deaths as float)) / SUM(CAST(new_cases as float)) DeathRate
FROM PortfolioProject.dbo.CovidDeaths
WHERE iso_code <> 'OWID'
GROUP BY location
ORDER BY DeathRate DESC
