select *
from Portfolio_project..CovidDeaths 
Where continent is not null
order by 3,4

--select *
--from Portfolio_project..CovidVaccinations
--order by 3,4

select Location, date, total_cases, new_cases, total_deaths, population
from Portfolio_project..CovidDeaths
order by 1,2

--Looking at total cases Vs total deaths

select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from Portfolio_project..CovidDeaths
where Location like 'Tunisia'
order by 1,2


--Looking at total cases Vs population
select Location, date, total_cases, population, (total_cases/population)*100 as CovidPercentage
from Portfolio_project..CovidDeaths
where Location like 'Tunisia'
order by 1,2

--Looking at countries with highest infection rate copmared to population
select Location, Max(total_cases) as TotalInfectionCount, population, Max((total_cases/population)*100) as HighestCovidPercentage
from Portfolio_project..CovidDeaths
group by population,Location
order by HighestCovidPercentage desc

--looking at the countries with the highest death count 
select Location, Max(cast(total_deaths as int)) as TotalDeathCount
from Portfolio_project..CovidDeaths
Where continent is not null
group by Location
order by TotalDeathCount desc

--Continents with highest death count per population

select continent, Max(cast(total_deaths as int)) as TotalDeathCount
from Portfolio_project..CovidDeaths
Where continent is not null
group by continent
order by TotalDeathCount desc



select date, sum (new_cases)as total_cases, sum(cast (new_deaths as int)) as totalDeaths, (sum(cast (new_deaths as int))/sum(new_cases))*100 as InfectionDeathPercentage
from Portfolio_project..CovidDeaths
where continent is not null
group by date 
order by 1,2

--Total population vs vaccinations
select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.date) as cumulatedVac
from Portfolio_project..CovidDeaths dea
join  Portfolio_project..CovidVaccinations$ vac
   on dea.location = vac.location
   and dea.date= vac.date
where dea.continent is not null
order by 1,2,3

-- CTE use 

with PopVsVac (continent, location, date, population, cumulatedVac, new_vaccinations)
as 
(
select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.date) as cumulatedVac
from Portfolio_project..CovidDeaths dea
join  Portfolio_project..CovidVaccinations$ vac
   on dea.location = vac.location
   and dea.date= vac.date
where dea.continent is not null 
)
select *, (cumulatedVac/population)*100
from PopVsVac

--creating view to store data for future visualizations

create view PercentagePopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.date) as cumulatedVac
from Portfolio_project..CovidDeaths dea
join  Portfolio_project..CovidVaccinations$ vac
   on dea.location = vac.location
   and dea.date= vac.date
where dea.continent is not null

select * 
from PercentagePopulationVaccinated