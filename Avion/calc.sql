--Display all airplanes where the number of seats in the "Economy" class is greater than the average for all airplanes
select a.model, count(s.seat_no) as seats_count,
	   round(avg(count(s.seat_no)) over(), 2) as avg_economy_seats
from aircrafts as a
left join seats as s
on a.aircraft_code = s.aircraft_code
where s.fare_conditions = 'Economy'
group by a.model
;

--Find the number of airplanes that do not have seats in the "Comfort" class
select a.model, count(distinct a.aircraft_code) as number_of_planes
from aircrafts as a
left join seats as s
on a.aircraft_code = s.aircraft_code
and s.fare_conditions = 'Comfort'
where s.aircraft_code isnull
group by a.model
;

--Show all airplanes that have "Business" class but do not have "Economy" class
select a.model
from aircrafts as a
left join seats as s
on a.aircraft_code = s.aircraft_code
and s.fare_conditions = 'Business'
where s.fare_conditions <> 'Economy'
or s.fare_conditions isnull
group by a.model
;

--Find the average flight range for each service class ("Business," "Comfort," "Economy") across all airplanes
select s.fare_conditions, round(avg(a.range)) as avg_range
from aircrafts as a
left join seats as s
on a.aircraft_code = s.aircraft_code
where s.fare_conditions notnull
group by s.fare_conditions
;

--Display all seats in airplanes that have the same comfort conditions as seats in '763'
select s.seat_no, s.fare_conditions
from seats as s
left join aircrafts as a
on a.aircraft_code = s.aircraft_code
where s.fare_conditions in (
	select fare_conditions
	from seats
	where aircraft_code = '763')
and a.aircraft_code <> '763'
;

--Find the longest flight and the airplane model for each type of service
select a.model, s.fare_conditions, max(a.range) as max_flight
from aircrafts as a
left join seats as s
on a.aircraft_code = s.aircraft_code
group by a.model, s.fare_conditions
order by max_flight desc
;

--Which airplane models offer all three service classes (Business, Comfort, Economy)
select a.model
from aircrafts as a
left join seats as s
on a.aircraft_code = s.aircraft_code
where s.fare_conditions in ('Business', 'Comfort', 'Economy')
group by a.model
having count(distinct s.fare_conditions) = 3
;

--Display all seats that have not been booked yet 
--> NA since there's no data

--Find the most common seat type in the "Economy" class
select fare_conditions, seat_no, count(substring(seat_no, 0, 0)) as most_common_seat
from seats
where fare_conditions = 'Economy'
group by fare_conditions, seat_no
order by most_common_seat desc
;

--How many total seats are there in each service class across all airplanes
select a.model, s.fare_conditions, count(s.seat_no) as seats_count
from seats as s
join aircrafts as a 
on a.aircraft_code = s.aircraft_code
group by a.model, s.fare_conditions
order by a.model asc
;