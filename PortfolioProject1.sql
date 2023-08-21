SELECT * 
FROM PortfolioProject..CovidDeaths
where continent is not null
ORDER BY 3,4

SELECT * 
FROM PortfolioProject..CovidVaccinations
where continent is not null
ORDER BY 3,4

SELECT location, date, total_cases, new_cases, total_deaths , population
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2

--Total Cases V/S Total Deaths 

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage 
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2


--Total Cases V/S Total Deaths in India 

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage 
FROM PortfolioProject..CovidDeaths
WHERE location like 'India'
ORDER BY 1,2


--Total Cases V/S Total Population in India 

SELECT location, date, total_cases, Population, (total_cases/Population)*100 as InfectPercentage 
FROM PortfolioProject..CovidDeaths
WHERE location like 'India'
ORDER BY 1,2

--Countries Affected the most at the peak 

SELECT location, Population, max(total_cases)as max_cases, max((total_cases/Population))*100 as HighestInfectPercentage 
FROM PortfolioProject..CovidDeaths
where continent is not null
GROUP BY location, population
ORDER BY HighestInfectPercentage desc

--Countries with the most death count according to population at the peak 

SELECT location, Population, max(cast(total_deaths as int))as max_deaths, max((total_deaths/Population))*100 as HighestDeathPercentage 
FROM PortfolioProject..CovidDeaths
GROUP BY location, population
ORDER BY HighestDeathPercentage desc


--Global Numbers

SELECT  sum(cast(new_deaths as int))as deaths,sum(new_cases)as Cases,(sum(cast(new_deaths as int))/sum(new_cases))*100 as DeathPercentage 
FROM PortfolioProject..CovidDeaths
Where continent is not null
ORDER BY 1,2

--Population v/s vaccinations

With PopvsVac(continent,location,date,population,new_vaccinations,Rolling_vaccinated)
as
(
Select cd.continent, cd.location,cd.date,cd.population,cv.new_vaccinations
, Sum(convert(int,cv.new_vaccinations)) over 
(partition by cd.location order by cd.location,cd.date) as Rolling_vaccinated
FROM PortfolioProject..CovidDeaths as cd
join PortfolioProject..CovidVaccinations as cv
on cd.location = cv.location and cd.date = cv.date
where cd.continent is not null

)

Select *, (Rolling_vaccinated / population)*100 as Vaccinated_percent
From PopvsVac


--Creating view for later use

Create view PopvsVac as
(
Select cd.continent, cd.location,cd.date,cd.population,cv.new_vaccinations
, Sum(convert(int,cv.new_vaccinations)) over 
(partition by cd.location order by cd.location,cd.date) as Rolling_vaccinated
FROM PortfolioProject..CovidDeaths as cd
join PortfolioProject..CovidVaccinations as cv
on cd.location = cv.location and cd.date = cv.date
where cd.continent is not null

)



 


