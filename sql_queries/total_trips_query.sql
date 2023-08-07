select bb16.start_time, bb16.start_station_id
from bluebikes_2016 bb16
union
select bb17.start_time, bb17.start_station_id
from bluebikes_2017 bb17
union
select bb18.start_time, bb18.start_station_id
from bluebikes_2018 bb18
union
select bb19.start_time, bb19.start_station_id
from bluebikes_2019 bb19
