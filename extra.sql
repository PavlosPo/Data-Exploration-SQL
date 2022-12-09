-- Found that High income Countries have more 
-- Deaths Per million opposed to Low Income.



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


-- 4.Temp Table with Restriction Power and DaysInRestrictions
DROP TABLE IF EXISTS #restrict_table
CREATE TABLE #restrict_table( 	
						location varchar(50),
						RestrictPower int,
						DaysInRestrictions int
						)

INSERT INTO  #restrict_table  -- Table for Restriction Info
SELECT 
	ocd.location,
	itc.international_travel_controls As RestrictionPower,
	COUNT( DISTINCT itc.date ) As DaysInRestrictions
FROM PortfolioProject.dbo.owid_covid_data ocd 
LEFT JOIN PortfolioProject.dbo.international_travel_covid itc 
	ON ocd.location = itc.location 
GROUP BY ocd.location, itc.international_travel_controls
ORDER BY location, RestrictionPower ASC

-- 5.Temp Table of many Variables(Info)

DROP TABLE IF EXISTS #info_table
CREATE TABLE #info_table (
						location varchar(50),
						TotalDeaths float,
						DeathsPerMillion float,
						GDP float,
						PovertyPercent float,
						DiabetesPrevalence float,
						Cardiovasc_Death_Rate float,
						Life_Expectancy float,
						Median_Age float,
						Aged_65_older float,
						Aged_75_older float
				)
				

INSERT INTO #info_table  -- Table for many variables of covid-19
SELECT 
	location, 
	MAX(total_deaths) as TotalDeaths,
	MAX(total_deaths_per_million) as DeathsPerMillion,
	MAX(gdp_per_capita) as GDP,
	MAX(extreme_poverty) as Poverty,
	diabetes_prevalence as DiabetesPrevalence, 
	cardiovasc_death_rate as Cardiovasc_Death_Rate, 
	life_expectancy as Life_Expectancy,
	median_age as Median_Age,
	aged_65_older as Aged_65_older,
	aged_70_older as Aged_75_older
FROM owid_covid_data ocd 
GROUP BY 
	location, 
	diabetes_prevalence , 
	cardiovasc_death_rate , 
	life_expectancy ,
	median_age,
	aged_65_older,
	aged_70_older

	
SELECT *
FROM #info_table


------------------------------------------------------------------------------------------------
-- 1.Question: Policy played role? argument variable: stringency_index
------------------------------------------------------------------------------------------------
SELECT iso_code, location, AVG(stringency_index)
FROM PortfolioProject.dbo.owid_covid_data ocd 
WHERE iso_code LIKE 'OWID_%'
GROUP BY location, gdp_per_capita 



------------------------------------------------------------------------------------------------
-- 2.Question: How ICU helped people, did they recover? or high percentage died?
------------------------------------------------------------------------------------------------



------------------------------------------------------------------------------------------------
-- 3.Question: How many days were borders in closure on high-middle and low income countries?
------------------------------------------------------------------------------------------------

SELECT 
	ocd.location,
	rt.RestrictPower,
	rt.DaysInRestrictions 
FROM owid_covid_data ocd
RIGHT JOIN #restrict_table rt
	ON rt.location = ocd.location
WHERE ocd.location IN ('Low income')
GROUP BY ocd.location, rt.RestrictPower, rt.DaysInRestrictions 
 --- TODO! Use the INCOME_Per_Country_Class.xlsx file to cross the data.

------------------------------------------------------------------------------------------------
-- Taking Data!
------------------------------------------------------------------------------------------------


-- Taking the Restriction-Days Data
SELECT *
FROM #restrict_table
ORDER BY location, RestrictPower ASC

-- Taking the info_table Data
SELECT *
FROM #info_table



