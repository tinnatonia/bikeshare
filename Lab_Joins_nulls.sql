--1. show the orders made by customers in the consumer segment, connect keys with 'using', limit 1000 rows, experiment with grouping and order
select o.order_id --o.ship_mode
from orders o
	join customers c using(customer_id)
where c.segment ilike '%cons%'
--group by ship_mode, o.order_id
order by o.sales desc
limit 1000;
--returns 1000 rows due to limit

--2. which orders included photo frame products?
select o.order_id, p.product_name
from orders o
	join products p using(product_id)
where p.product_name ilike '%photo%frame%';
--returns 7018 rows

--3. Which photo frame products were not sold?
select p.product_name, p.product_id, o.order_id
from products p
	left join orders o using(product_id)
where o.order_id is null and p.product_name ilike '%photo%frame%';
--all photo frame products were sold, returns 0 rows

--4. Which unique products were sold in France (don't use distinct)
select p.product_id, p.product_name, rg.country
from products p
	left join orders o using(product_id)
	join regions rg using(region_id)
where rg.country ilike 'France' and o.order_id is not null
group by p.product_id, p.product_name, rg.country;
--9401 unique products sold in france

--5. which recycled products were sold in the united states?
select p.product_id, p.product_name, rg.country
from products p
	left join orders o using(product_id)
	join regions rg using(region_id)
where rg.country ilike 'united states' and o.order_id is not null and p.product_name ilike '%recycle%'
group by p.product_id, p.product_name, rg.country;
--403 recycled products sold in US

--6. which unique products, other than photo frame products, were sold in canada?
select p.product_name, p.product_id
from products p
	left join orders o using(product_id)
	join regions rg using(region_id)
where rg.country ilike 'Canada' and p.product_name not ilike '%photo%frame%' and o.order_id is not null
group by p.product_id, p.product_name;
--returns 4632 items sold

--7. Were there any products that were not sold?
select p.product_id, p.product_name, o.order_id
from products p
	left join orders o using(product_id)
where o.order_id is null;
--yes, 1 item never sold

--8. were there any orders from countries outside of our sales regions?
select o.order_id, o.region_id, rg.region_id, rg.country
from orders o
	left join regions rg using(region_id)
where rg.country is null
--returns 193 rows of items not in sales regions
