# Covid-project

*********************************************
This is a data analysis of the covid dataset from the beginning till today, provided from the Our World in Data organisation.


*********************************************

project.sql:

The DataSet used is https://ourworldindata.org/covid-deaths here. Although some changes have been done to the file for better organization which information is in which table.
There are two tables 1. CovidDeaths table which contains the nescessary information to extract information about deaths
                     2. CovidVaccinations table which contains data irellevant to the deaths , such as diabetes, e.t.c.

***************************************************************************************************************************************

extra.sql:

It provides Queries from the original dataset downloaded from the https://ourworldindata.org/covid-deaths , where I try to gain some interesting insights about the Covid-19 pandemic. Questions arrise such us; does income affects the death rate per country, does the age? what other factors do exists?

## ChangeLog

* Used the **project.sql** file where advanced queries on SQL Server exists builted from me. 

* Exported the Data from the queries to make visualizations using Tableau Pupblic.

* Updated the *project.sql* file with more context, and more temp tables, CTEs, e.t.c.

* Created the **extra.sql** for further analysis on the covid-19 DataSet.

* Created more advanced queries on the *extra.sql* file.

* Updated the extra.sql with more queries and transformed the file to be more structured.

* Used the owid_covid_data.csv file provided from the OurWorldInData organization, that allowed to use less often the INNER JOIN method on each Table. 

* Downloaded the international_travel_controls provided by OurWorlInData, where it counts the restrictions each country had per day during the pandemic.

* Downloaded the INCOME_PER_COUNTRY_CLASS.xlsx from the WorldBank, where it provided usefull information about the distribution of each country's income (Low, Middle, Upper Midle, High income)
