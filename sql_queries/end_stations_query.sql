
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