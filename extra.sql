-- Continents View
SELECT iso_code, location, population, SUM(new_deaths) As Deaths
FROM PortfolioProject.dbo.owid_covid_data ocd 
WHERE ocd.iso_code LIKE 'OWID_%'
GROUP BY iso_code, location, population
ORDER BY Deaths DESC


-- Found that High income Countries have more Deaths Per million opposed to Low Income.



-- Continent
SELECT 
	iso_code,
	location,
	SUM(new_deaths) As Deaths,
	MAX(total_deaths_per_million) As Max_DeathsPerMillion,
	AVG(total_deaths_per_million) As AVG_DeathsPerMillion
FROM PortfolioProject.dbo.owid_covid_data ocd 
WHERE ocd.iso_code LIKE 'OWID_%' OR location IN (
										'High income', 
										'Upper middle income',
										'Lower middle income')
GROUP BY iso_code, location, aged_65_older 
ORDER BY AVG_DeathsPerMillion DESC
 
-- Country and Finance
SELECT 
	location,
	gdp_per_capita as GDP,
	CAST(extreme_poverty as float) ExtremePoverty,
	SUM(new_deaths) As Deaths,
	MAX(total_deaths_per_million) As Max_DeathsPerMillion,
	AVG(total_deaths_per_million) As AVG_DeathsPerMillion
FROM PortfolioProject.dbo.owid_covid_data ocd 
WHERE continent NOT LIKE ''
GROUP BY location, gdp_per_capita, extreme_poverty 
ORDER BY CAST(extreme_poverty as float) DESC

-- Country, COUNT the day of restrictions happened.
SELECT 
	location,
	COUNT([Date]) as DaysInRestrictions
FROM PortfolioProject.dbo.international_travel_covid itc 
GROUP BY location












------------------------------------------------------------------------------------------------
-- Question: Policy played role? argument variable: stringency_index
SELECT iso_code, location, AVG(stringency_index)
FROM PortfolioProject.dbo.owid_covid_data ocd 
WHERE iso_code LIKE 'OWID_%'
GROUP BY location, gdp_per_capita 




-- Question: How ICU helped people, did they recover? or high percentage died?
-- Question: How many days were borders in closure on high-middle and low income countries?


-- Taking Data!
 


