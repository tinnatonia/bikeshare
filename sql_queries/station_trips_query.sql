select bb.start_time, bb.start_station, bb.end_time, bb.end_station, 
	case
	when date_part('hour', bb.start_time::timestamp) between 6 and 10 then 'AM Commuters'
	when date_part('hour', bb.start_time::timestamp) between 10 and 15 then 'Midday'
	when date_part('hour', bb.start_time::timestamp) between 15 and 19 then 'PM Commuters'
	else 'Night'
	end time_of_day
from(
	select bb16.start_time start_time, bb16.end_time end_time, bb16.start_station_id start_station, bb16.end_station_id end_station 
	from bluebikes_2016 bb16
	where bb16.start_station_id in (74, 67, 58, 36, 22, 42, 53, 20, 60, 47, 23)
		and bb16.user_type ilike 'Customer'
	union
	select bb17.start_time start_time, bb17.end_time end_time, bb17.start_station_id start_station, bb17.end_station_id end_station
	from bluebikes_2017 bb17
	where bb17.start_station_id in (74, 67, 58, 36, 22, 42, 53, 20, 60, 47, 23)
		and bb17.user_type ilike 'Customer'
	union
	select bb18.start_time start_time, bb18.end_time end_time, bb18.start_station_id start_station, bb18.end_station_id end_station
	from bluebikes_2018 bb18
	where bb18.start_station_id in (74, 67, 58, 36, 22, 42, 53, 20, 60, 47, 23)
		and bb18.user_type ilike 'Customer'
	union
	select bb19.start_time start_time, bb19.end_time end_time, bb19.start_station_id start_station, bb19.end_station_id end_station
	from bluebikes_2019 bb19
	where bb19.start_station_id in (74, 67, 58, 36, 22, 42, 53, 20, 60, 47, 23)
		and bb19.user_type ilike 'Customer'
) bb