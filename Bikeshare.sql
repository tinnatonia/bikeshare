--Total rides (is this good enough or do I have to sort by start_time||end time distinct count?)
select count(bike_id)
from bluebikes_2019;
	/*total records: (rides)
	2016 - 1236203
	2017 - 1313774
	2018 - 1767806
	2019 - 2522537
	*/
	
--Top Stations and location lat/long
select st.latitude lat, st.longtitude lon, st.id id, count(bb.start_station_id)
from bluebikes_stations as st
	join bluebikes_2019 as bb
	on bb.start_station_id = st.id
group by lat, lon, id
order by count(bb.start_station_id) desc
limit 100;

--Total number stations
select count(distinct id)
from bluebikes_stations;
	--336 station ids (no duplicates)

--Monthly rides (sub out 2016, 2017, 2018, 2019)
select date_part('month', start_time) as month_ride, count(bike_id)
from bluebikes_2016
group by Month_Ride;
	--i might want to even break this down into weekly to show exact weather patterns! that would be cool

--Time of Day vs frequency of rides
select count(distinct bb.bike_id||'-'||bb.start_time),
case
	when date_part('hour', bb.start_time::timestamp) between 5 and 8 then 'Early Morning'
	when date_part('hour', bb.start_time::timestamp) between 8 and 11 then 'Morning'
	when date_part('hour', bb.start_time::timestamp) between 11 and 12 then 'Late Morning'
	when date_part('hour', bb.start_time::timestamp) between 12 and 15 then 'Early Afternoon'
	when date_part('hour', bb.start_time::timestamp) between 15 and 17 then 'Afternoon'
	when date_part('hour', bb.start_time::timestamp) between 17 and 21 then 'Evening'
	else 'Night'
	end as time_of_day
from bluebikes_2016 bb
group by time_of_day
order by 1 desc;
		/*
		256885	"Evening"
		249117	"Afternoon"
		212951	"Early Morning"
		209360	"Early Afternoon"
		177428	"Morning"
		67367	"Late Morning"
		63095	"Night"*/


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
order by count_rides desc
limit 10;




	

	


