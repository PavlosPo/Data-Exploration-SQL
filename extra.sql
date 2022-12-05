-- Continents View
SELECT iso_code, location, population, SUM(new_deaths) As Deaths
FROM PortfolioProject.dbo.owid_covid_data ocd 
WHERE ocd.iso_code LIKE 'OWID_%'
GROUP BY iso_code, location, population
ORDER BY Deaths DESC


-- Death Per Million to correlate high-low income Deaths.
-- Found that High income Countries have more Deaths Per million opposed to Low Income.
SELECT 
	iso_code,
	location,
	SUM(new_deaths) As Deaths,
	MAX(total_deaths_per_million) As Max_DeathsPerMillion,
	AVG(total_deaths_per_million) As AVG_DeathsPerMillion
FROM PortfolioProject.dbo.owid_covid_data ocd 
WHERE ocd.iso_code LIKE 'OWID_%' AND location IN (
										'High income', 
										'Upper middle income',
										'Lower middle income')
GROUP BY iso_code, location
ORDER BY Deaths DESC
 



-- Question: How many days were borders in closure on high-middle and low income countries?


-- Taking Data!
 


