/*created database named unemployment*/
create database unemployment;
/*using the database to run further queries*/
use unemployment;

/*Converting date from text to date for unemployment_rate_m_total and changing column data type. */
alter table unemployment_rate_m_total
modify column date date;

update unemployment.unemployment_rate_m_total 
set Date = str_to_date(date,('%Y-%m-%d'));

/*Converting date from text to date for unemployment_rate_m_urban and changing column data type. */
alter table unemployment_rate_m_urban
modify column date date;

update unemployment.unemployment_rate_m_urban 
set Date = str_to_date(date,('%Y-%m-%d'));

/*Converting date from text to date for unemployment_rate_m_rural and changing column data type.*/
alter table unemployment_rate_m_rural
modify column date date;

update unemployment.unemployment_rate_m_rural
set Date = str_to_date(date,('%d-%m-%Y'));

/*Overall india's unemployment in the last 5 years.*/
select year(date) as Year_of_unemployment, 
round(avg(`Estimated Unemployment Rate (%)`),2) as Average_unemployment_rate
from unemployment.unemployment_rate_m_total 
where Region not like 'india'
group by year(date)
order by year(date) desc
limit 5;

/*Urban vs rural unemployment*/

select year(ur.date) as Year_of_unemployment, 
round(avg(ur.`Estimated Unemployment Rate (%)`),2) as Average_unemployment_rate_in_rural,
round(avg(uu.`Estimated Unemployment Rate (%)`),2) as Average_unemployment_rate_in_urban
from unemployment_rate_m_rural as ur join unemployment_rate_m_urban uu using(region)
where Region not like 'india'
group by year(ur.date)
order by year(ur.date);

/*State wise highest and lowest unemployment data.*/

select Region, round(avg(`Estimated Unemployment Rate (%)`),2) as Average_unemployment_rate_in_every_State
from unemployment_rate_m_total
where Region not like 'india'
group by Region;

/*Impact of lockdown in un-employment in 2020-2021 in each state*/
create view `2021` as
select region, round(avg(`Estimated Unemployment Rate (%)`),2) as Average_unemployment_rate_in_every_State_2021
from unemployment_rate_m_total
where Region not like 'india' and year(date)=2021
group by region;
create view `2020` as
select region, round(avg(`Estimated Unemployment Rate (%)`),2) as Average_unemployment_rate_in_every_State_2020
from unemployment_rate_m_total
where Region not like 'india' and year(date)=2020
group by region;

select * from `2020` as a1 join `2021` as a2 using(region);

/*Participation rate in urban vs rural in AVG*/

select year(ur.date) as Year_of_unemployment, 
round(avg(ur.`Estimated Labour Participation Rate (%)`),2) as Average_unemployment_rate_in_rural,
round(avg(uu.`Estimated Labour Participation Rate (%)`),2) as Average_unemployment_rate_in_urban
from unemployment_rate_m_rural as ur join unemployment_rate_m_urban uu using(region)
where Region not like 'india'
group by year(ur.date)
order by year(ur.date) desc
limit 5;
