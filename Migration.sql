--Migration Data Table
SELECT *
  FROM [PortfolioProject].[dbo].[Estimates$]

--Checking how data is divided
SELECT distinct type
  FROM [PortfolioProject].[dbo].[Estimates$]

SELECT distinct [Region, subregion, country or area *]
  FROM [PortfolioProject].[dbo].[Estimates$]
  WHERE type='Country/Area'
  order by [Region, subregion, country or area *]

--Net Number of Migrants among Continents
SELECT [Region, subregion, country or area *], SUM([Net Number of Migrants (thousands)]) AS Net_Migration
  FROM [PortfolioProject].[dbo].[Estimates$]
  WHERE type='Region' 
  GROUP BY [Region, subregion, country or area *],[ISO3 Alpha-code]
  ORDER BY Net_Migration DESC

--Net Number of Migrants among Countries
SELECT [Region, subregion, country or area *],[ISO3 Alpha-code], SUM([Net Number of Migrants (thousands)]) AS Net_Migration
  FROM [PortfolioProject].[dbo].[Estimates$]
  WHERE type='Country/Area' 
  GROUP BY [Region, subregion, country or area *],[ISO3 Alpha-code]
  ORDER BY Net_Migration

--As the country 'Holy See' has zero migrants, it is exculded
SELECT [Region, subregion, country or area *],[ISO3 Alpha-code], SUM([Net Number of Migrants (thousands)]) AS Net_Migration
  FROM [PortfolioProject].[dbo].[Estimates$]
  WHERE type='Country/Area' AND [Region, subregion, country or area *] != 'Holy See'
  GROUP BY [Region, subregion, country or area *],[ISO3 Alpha-code]
  ORDER BY Net_Migration

--Net Migration Rate (per 1,000 population) among countries
SELECT [Region, subregion, country or area *],[ISO3 Alpha-code], AVG([Net Migration Rate (per 1,000 population)]) AS Avg_Migration
  FROM [PortfolioProject].[dbo].[Estimates$]
  WHERE type='Country/Area' AND [Region, subregion, country or area *] != 'Holy See'
  GROUP BY [Region, subregion, country or area *],[ISO3 Alpha-code]
  ORDER BY Avg_Migration desc


--GDP per Capita Table 
SELECT *
  FROM [PortfolioProject].[dbo].[GDP$]

--Tranforming columns to rows using UNPIVOT
SELECT [Country Name],[Country Code],GDP, Year from
	(SELECT *
	FROM [PortfolioProject].[dbo].[GDP$]) GDP_Table
		UNPIVOT
		(GDP for Year IN ([1960],[1961],[1962],[1963],[1964],[1965],[1966],[1967],[1968],[1969],[1970],[1971],[1972],[1973],[1974]
		,[1975],[1976],[1977],[1978],[1979],[1980],[1981],[1982],[1983],[1984],[1985],[1986],[1987],[1988],[1989],[1990],[1991],[1992]
		,[1993],[1994],[1995],[1996],[1997],[1998],[1999],[2000],[2001],[2002],[2003],[2004],[2005],[2006],[2007],[2008],[2009],[2010]
		,[2011],[2012],[2013],[2014],[2015],[2016],[2017],[2018],[2019],[2020],[2021])
	  ) as GDPNEW


--Use CTE
WITH GDP_New([Country Name],[Country Code],GDP, Year)
as( 
SELECT [Country Name],[Country Code],GDP, Year from
	(SELECT *
	FROM [PortfolioProject].[dbo].[GDP$]) GDP_Table
		UNPIVOT
		(GDP for Year IN ([1960],[1961],[1962],[1963],[1964],[1965],[1966],[1967],[1968],[1969],[1970],[1971],[1972],[1973],[1974]
		,[1975],[1976],[1977],[1978],[1979],[1980],[1981],[1982],[1983],[1984],[1985],[1986],[1987],[1988],[1989],[1990],[1991],[1992]
		,[1993],[1994],[1995],[1996],[1997],[1998],[1999],[2000],[2001],[2002],[2003],[2004],[2005],[2006],[2007],[2008],[2009],[2010]
		,[2011],[2012],[2013],[2014],[2015],[2016],[2017],[2018],[2019],[2020],[2021])
	  ) as GDPNEW
)

--Joining both Tables using Year and Country Code
SELECT m.[Region, subregion, country or area *],m.[ISO3 Alpha-code],m.Year,m.[Net Migration Rate (per 1,000 population)],m.[Net Number of Migrants (thousands)],g.GDP
FROM Gdp_New AS g
RIGHT JOIN [PortfolioProject].[dbo].[Estimates$] AS m
ON g.[Country Code]=m.[ISO3 Alpha-code] AND g.Year=m.Year
WHERE type='Country/Area' AND m.[Region, subregion, country or area *] != 'Holy See'
order by m.[Region, subregion, country or area *]


--Creating VIEW
Create view Migration_GDP as
WITH GDP_New([Country Name],[Country Code],GDP, Year)
as( 
SELECT [Country Name],[Country Code],GDP, Year from
	(SELECT *
	FROM [PortfolioProject].[dbo].[GDP$]) GDP_Table
		UNPIVOT
		(GDP for Year IN ([1960],[1961],[1962],[1963],[1964],[1965],[1966],[1967],[1968],[1969],[1970],[1971],[1972],[1973],[1974]
		,[1975],[1976],[1977],[1978],[1979],[1980],[1981],[1982],[1983],[1984],[1985],[1986],[1987],[1988],[1989],[1990],[1991],[1992]
		,[1993],[1994],[1995],[1996],[1997],[1998],[1999],[2000],[2001],[2002],[2003],[2004],[2005],[2006],[2007],[2008],[2009],[2010]
		,[2011],[2012],[2013],[2014],[2015],[2016],[2017],[2018],[2019],[2020],[2021])
	  ) as GDPNEW
)
SELECT m.[Region, subregion, country or area *],m.[ISO3 Alpha-code] as CountryCode,m.Year,m.[Net Migration Rate (per 1,000 population)],m.[Net Number of Migrants (thousands)],g.GDP
FROM Gdp_New AS g
RIGHT JOIN [PortfolioProject].[dbo].[Estimates$] AS m
ON g.[Country Code]=m.[ISO3 Alpha-code] AND g.Year=m.Year


SELECT * FROM Migration_GDP as mg



--Unemployment Data
SELECT *
FROM [PortfolioProject].[dbo].[Unemployment$]


--Tranforming columns to rows using UNPIVOT
SELECT [Country Name],[Country Code],Year,UnemoploymentRate  from
	(SELECT *
	FROM [PortfolioProject].[dbo].[Unemployment$]) Unemp_Table
		UNPIVOT
		(UnemoploymentRate for Year IN ([1991],[1992],[1993],[1994],[1995],[1996],[1997],[1998],[1999],[2000],[2001],[2002],[2003],[2004],[2005]
		,[2006],[2007],[2008],[2009],[2010],[2011],[2012],[2013],[2014],[2015],[2016],[2017],[2018],[2019],[2020],[2021])
	  ) as UNEMPNEW


--Use CTE
WITH Unemp_New([Country Name],[Country Code],Year,UnemoploymentRate)
as(
SELECT [Country Name],[Country Code],Year,UnemoploymentRate  from
	(SELECT *
	FROM [PortfolioProject].[dbo].[Unemployment$]) Unemp_Table
		UNPIVOT
		(UnemoploymentRate for Year IN ([1991],[1992],[1993],[1994],[1995],[1996],[1997],[1998],[1999],[2000],[2001],[2002],[2003],[2004],[2005]
		,[2006],[2007],[2008],[2009],[2010],[2011],[2012],[2013],[2014],[2015],[2016],[2017],[2018],[2019],[2020],[2021])
	  ) as UNEMPNEW
)


--Joining Unemployment Table to last created VIEW
SELECT mg.[Region, subregion, country or area *],mg.CountryCode,mg.Year,mg.[Net Migration Rate (per 1,000 population)],mg.[Net Number of Migrants (thousands)]
		,mg.GDP as [GDP per Capita], u.UnemoploymentRate
FROM Migration_GDP as mg
LEFT JOIN Unemp_New AS u
ON mg.CountryCode=u.[Country Code] AND mg.Year=u.Year
where mg.Year >1990 and mg.Year<2022 and mg.CountryCode is not null
order by mg.[Region, subregion, country or area *]

DROP VIEW Final_Migration


--Creating the final VIEW for visualization
CREATE VIEW Final_Migration AS
WITH Unemp_New([Country Name],[Country Code],Year,UnemoploymentRate)
as(
SELECT [Country Name],[Country Code],Year,UnemoploymentRate  from
	(SELECT *
	FROM [PortfolioProject].[dbo].[Unemployment$]) Unemp_Table
		UNPIVOT
		(UnemoploymentRate for Year IN ([1991],[1992],[1993],[1994],[1995],[1996],[1997],[1998],[1999],[2000],[2001],[2002],[2003],[2004],[2005]
		,[2006],[2007],[2008],[2009],[2010],[2011],[2012],[2013],[2014],[2015],[2016],[2017],[2018],[2019],[2020],[2021])
	  ) as UNEMPNEW
)
SELECT mg.[Region, subregion, country or area *]as Country,mg.CountryCode,mg.Year,mg.[Net Migration Rate (per 1,000 population)],mg.[Net Number of Migrants (thousands)]
		,mg.GDP as [GDP per Capita(USD)], u.UnemoploymentRate
FROM Migration_GDP as mg
LEFT JOIN Unemp_New AS u
ON mg.CountryCode=u.[Country Code] AND mg.Year=u.Year
where mg.Year >1990 and mg.Year<2022 and mg.CountryCode is not null



select * from Final_Migration
order by Country




