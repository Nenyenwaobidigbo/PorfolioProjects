
Select *
From Coviddeaths
Where continent is not null
Order by 3,4

--Select *
--From Covidvaccinations
--Order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
From Coviddeaths
Where continent is not null
Order by 1,2

Select Location, date, total_cases, total_deaths, (CONVERT(float,total_deaths))/NULLIF(CONVERT(float,total_cases),0)*100 as DeathPercentage
From Coviddeaths
Where Location like '%Nigeria%'
and continent is not null
Order by 1,2

Select Location, date, total_cases, Population, (CONVERT(float,total_cases))/NULLIF(CONVERT(float,population),0)*100 as PercentPopulationInfected
From Coviddeaths
--Where Location like '%Nigeria%'
Where continent is not null
Order by 1,2


Select Location, Population, MAX(cast(total_cases as int))as HighestInfectionCount,MAX(CONVERT(float,total_cases))/NULLIF(CONVERT(float,population),0)*100 as PercentPopulationInfected
From Coviddeaths
--Where Location like '%Nigeria%'
Where continent is not null
Group by location, population
Order by PercentPopulationInfected desc


Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From Coviddeaths
--Where Location like '%Nigeria%'
Where continent is not null
Group by location
Order by TotalDeathCount desc


Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From Coviddeaths
--Where Location like '%Nigeria%'
Where continent is not null
Group by continent
Order by TotalDeathCount desc


Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/NULLIF(SUM(new_cases),0)*100 as DeathPercentage
From Coviddeaths
--Where Location like '%Nigeria%'
Where continent is not null
Group by date
Order by 1,2

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/NULLIF(SUM(new_cases),0)*100 as DeathPercentage
From Coviddeaths
--Where Location like '%Nigeria%'
Where continent is not null
--Group by date
Order by 1,2



With PopvsVac(Continent, Location, Date, Population,New_Vaccinations, RollingPeopleVaccinated)
as

(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,
 dea.Date) as RollingPeopleVaccinated
From Coviddeaths dea
Join Covidvaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *,(RollingPeopleVaccinated/Population)*100
From Popvsvac

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,
 dea.Date) as RollingPeopleVaccinated
From Coviddeaths dea
Join Covidvaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,
 dea.Date) as RollingPeopleVaccinated
From Coviddeaths dea
Join Covidvaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *
From PercentPopulationVaccinated
















