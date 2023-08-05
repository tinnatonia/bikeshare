--Total rides
select count(bike_id)
from bluebikes_2019;
	/*total records: (rides)
	2016 - 1236203
	2017 - 1313774
	2018 - 1767806
	2019 - 2522537
	*/
	
select bb.user_type, count(bb.user_type)
from(
	select user_type
	from bluebikes_2016 bb16
	union all
	select user_type
	from bluebikes_2017 bb17
	union all
	select user_type
	from bluebikes_2018 bb18
	union all
	select user_type
	from bluebikes_2019 bb19) as bb
group by user_type;

select 1326499::integer/5513821::integer
--Top ten stations and location lat/long in 2019
470

select st.latitude lat, st.longtitude lon, st.id station_id, count(bb.start_station_id)
from bluebikes_stations as st
	join bluebikes_2019 as bb
	on bb.start_station_id = st.id
group by lat, lon, id
order by count(bb.start_station_id) desc
limit 10;

--top start stations 2016-2019 and coordinates - customers
select st.latitude lat, st.longtitude lon, st.id start_station_id, count(bb.start_station_id)
from(
	select bb16.start_station_id, bb16.user_type
	from bluebikes_2016 bb16
	union all
	select bb17.start_station_id, bb17.user_type
	from bluebikes_2017 bb17
	union all
	select bb18.start_station_id, bb18.user_type
	from bluebikes_2018 bb18
	union all
	select bb19.start_station_id, bb19.user_type
	from bluebikes_2019 bb19) as bb
join bluebikes_stations as st
	on bb.start_station_id = st.id
where bb.user_type ilike 'customer'
group by lat, lon, id
order by count(bb.start_station_id) desc;


--top end stations 2016-2019 and coordinates - customers
select en.latitude lat, en.longtitude lon, en.id start_station_id, count(bb.end_station_id)
from(
	select bb16.end_station_id, bb16.user_type
	from bluebikes_2016 bb16
	union all
	select bb17.end_station_id, bb17.user_type
	from bluebikes_2017 bb17
	union all
	select bb18.end_station_id, bb18.user_type
	from bluebikes_2018 bb18
	union all
	select bb19.end_station_id, bb19.user_type
	from bluebikes_2019 bb19) as bb
join bluebikes_stations as en
	on bb.end_station_id = en.id
where bb.user_type ilike 'customer'
group by lat, lon, id
order by count(bb.end_station_id) desc;

select to_char(date_trunc('month', bb.start_time), 'YYYY-MM') month_day, count(bb.bike_id)
from(
select bb16.bike_id, bb16.start_time, bb16.user_type
	from bluebikes_2016 bb16
	union
	select bb17.bike_id, bb17.start_time, bb17.user_type
	from bluebikes_2017 bb17
	union
	select bb18.bike_id, bb18.start_time, bb18.user_type
	from bluebikes_2018 bb18
	union
	select bb19.bike_id, bb19.start_time, bb19.user_type
	from bluebikes_2019 bb19) bb
Group by month_day
order by month_day;









select bb.user_type, count(bb.bike_id) number_of_rides
from(
	select bb16.user_type, bb16.bike_id, bb16.start_time
	from bluebikes_2016 bb16
	union all
	select bb17.user_type, bb17.bike_id, bb17.start_time
	from bluebikes_2017 bb17
	union all
	select bb18.user_type, bb18.bike_id, bb18.start_time
	from bluebikes_2018 bb18
	union all
	select bb19.user_type, bb19.bike_id, bb19.start_time
	from bluebikes_2019 bb19) as bb
where date_part('month', bb.start_time) in (5,6,7,8)
group by bb.user_type;


--top end stations 2016-2019 and coordinates
select en.latitude lat, en.longtitude lon, en.id end_station_id, count(bb.end_station_id)
from(
	select bb16.end_station_id, bb16.user_type 
	from bluebikes_2016 bb16
	union all
	select bb17.end_station_id, bb17.user_type 
	from bluebikes_2017 bb17
	union all
	select bb18.end_station_id, bb18.user_type 
	from bluebikes_2018 bb18
	union all
	select bb19.end_station_id, bb19.user_type 
	from bluebikes_2019 bb19) as bb
join bluebikes_stations as en
	on bb.end_station_id = en.id
where bb.user_type ilike 'customer'
group by lat, lon, id
order by count(bb.end_station_id) desc;

--Total number stations
select count(distinct id)
from bluebikes_stations;
	--336 station ids (no duplicates)

--Monthly rides (sub out 2016, 2017, 2018, 2019)
select date_part('year', bb.start_time) as year_ride, date_part('month', bb.start_time) as month_ride, count(bb.bike_id)
from(
	select bb16.start_time, bb16.bike_id
	from bluebikes_2016 bb16
	union
	select bb17.start_time, bb17.bike_id
	from bluebikes_2017 bb17
	union
	select bb18.start_time, bb18.bike_id
	from bluebikes_2018 bb18
	union
	select bb19.start_time, bb19.bike_id
	from bluebikes_2019 bb19) as bb
	group by year_ride, month_ride
	order by year_ride, month_ride;


	--i might want to even break this down into weekly to show exact weather patterns! that would be cool
	
--rides by day of year 2016-2019 -- can i compare this to weather data somehow?
select date_part('doy', t1.start_time) as day_of_year, count(bike_id)
from(
	select bb16.bike_id, bb16.start_time
	from bluebikes_2016 bb16
	union
	select bb17.bike_id, bb17.start_time
	from bluebikes_2017 bb17
	union
	select bb18.bike_id, bb18.start_time
	from bluebikes_2018 bb18
	union
	select bb19.bike_id, bb19.start_time
	from bluebikes_2019 bb19) t1
group by day_of_year
order by day_of_year;







--Time of Day vs frequency of rides 2016-2019
select count(distinct t1.bike_id||'-'||t1.start_time),
case
	when date_part('hour', t1.start_time::timestamp) between 5 and 8 then 'Early Morning'
	when date_part('hour', t1.start_time::timestamp) between 8 and 11 then 'Morning'
	when date_part('hour', t1.start_time::timestamp) between 11 and 12 then 'Late Morning'
	when date_part('hour', t1.start_time::timestamp) between 12 and 15 then 'Early Afternoon'
	when date_part('hour', t1.start_time::timestamp) between 15 and 17 then 'Afternoon'
	when date_part('hour', t1.start_time::timestamp) between 17 and 21 then 'Evening'
	else 'Night'
	end as time_of_day
from(
	select bb16.bike_id, bb16.start_time, bb16.user_type
	from bluebikes_2016 bb16
	union
	select bb17.bike_id, bb17.start_time, bb17.user_type
	from bluebikes_2017 bb17
	union
	select bb18.bike_id, bb18.start_time, bb18.user_type
	from bluebikes_2018 bb18
	union
	select bb19.bike_id, bb19.start_time, bb19.user_type
	from bluebikes_2019 bb19) t1
where date_part('month', t1.start_time) in (6,7,8)
group by time_of_day
order by 1 desc;
		/*1443952	"Evening"
		1367094	"Afternoon"
		1174908	"Early Morning"
		1136575	"Early Afternoon"
		981435	"Morning"
		369832	"Night"*/

--year-long 6,473,796
--summer 2,043,052
select (2043052::num/6473796::num)

--average user gender info 
select user_type, 
case
	when user_gender = 0 then 'Unkown'
	when user_gender = 1 then 'Male'
	when user_gender = 2 then 'Female'
	end as usergender
	,count(bike_id||'-'||start_time) as count_rides
from bluebikes_2016
group by user_gender, user_type
order by count_rides desc;


--average age and all age info:
select avg(bb)
from(
	select bb16.user_birth_year
	from bluebikes_2016 bb16
	where bb16.user_birth_year <> '\N' and bb16.user_type ilike 'Subscriber'
	union all
	select bb17.user_birth_year
	from bluebikes_2017 bb17
	where bb17.user_birth_year <> '\N' and bb17.user_type ilike 'Subscriber'
	union all
	select bb18.user_birth_year
	from bluebikes_2018 bb18
	where bb18.user_birth_year <> '\N' and bb18.user_type ilike 'Subscriber'
	union all
	select bb19.user_birth_year
	from bluebikes_2019 bb19
	where bb19.user_birth_year <> '\N' and bb19.user_type ilike 'Subscriber') bb;


select user_birth_year
from bluebikes_2016
limit 100;




	

	


