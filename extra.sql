-- Continents View
SELECT iso_code, location, population, SUM(new_deaths) As Deaths
FROM PortfolioProject.dbo.owid_covid_data ocd 
WHERE ocd.iso_code LIKE 'OWID_%'
GROUP BY iso_code, location, population
ORDER BY Deaths DESC


-- Found that High income Countries have more Deaths Per million opposed to Low Income.



-- 1.Continent and Finance
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
 
-- 2.Country and Finance
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

-- 3.Country and Restrictions Days
SELECT 
	location,
	COUNT([Date]) as DaysInRestrictions
FROM PortfolioProject.dbo.international_travel_covid itc 
GROUP BY location


-- 4.Temp Table with Restriction Power and Days
DROP TABLE IF EXISTS #restrict_table
CREATE TABLE #restrict_table( 	
						location varchar(50),
						RestrictPower int,
						DaysInRestrictions int
						)

INSERT INTO  #restrict_table
SELECT 
	ocd.location,
	itc.international_travel_controls As RestrictionPower,
	COUNT( DISTINCT itc.date ) As DaysInREstrictions
FROM PortfolioProject.dbo.owid_covid_data ocd 
LEFT JOIN PortfolioProject.dbo.international_travel_covid itc 
	ON ocd.location = itc.location 
GROUP BY ocd.location, itc.international_travel_controls
ORDER BY location, RestrictionPower ASC


SELECT *
FROM #restrict_table
ORDER BY location, RestrictPower DESC











------------------------------------------------------------------------------------------------
-- Question: Policy played role? argument variable: stringency_index
SELECT iso_code, location, AVG(stringency_index)
FROM PortfolioProject.dbo.owid_covid_data ocd 
WHERE iso_code LIKE 'OWID_%'
GROUP BY location, gdp_per_capita 




-- Question: How ICU helped people, did they recover? or high percentage died?
-- Question: How many days were borders in closure on high-middle and low income countries?


-- Taking Data!
 


