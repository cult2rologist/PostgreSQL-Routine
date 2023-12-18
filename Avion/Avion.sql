CREATE TABLE aircrafts
(
    aircraft_code char(4) NOT NULL,
    model text NOT NULL,
    range integer NOT NULL CHECK (range > 0),
    PRIMARY KEY (aircraft_code)
);

INSERT INTO aircrafts (aircraft_code, model, range)
VALUES
    ('773', 'Boeing 777-300', 11100),
    ('763', 'Boeing 767-300', 7900),
    ('733', 'Boeing 737-300', 4200),
    ('320', 'Airbus A320-200', 5700),
    ('321', 'Airbus A321-200', 5600),
    ('319', 'Airbus A319-100', 6700),
    ('CN1', 'Cessna 208 Caravan', 1200),
    ('CR2', 'Bombardier CRJ-200', 2700);

CREATE TABLE seats
(
    aircraft_code char(4) NOT NULL,
    seat_no varchar(4) NOT NULL,
    fare_conditions varchar(10) NOT NULL CHECK (fare_conditions IN ('Economy', 'Comfort', 'Business')),
    PRIMARY KEY (aircraft_code, seat_no),
    FOREIGN KEY (aircraft_code) REFERENCES aircrafts (aircraft_code) ON DELETE CASCADE
);

INSERT INTO seats (aircraft_code, seat_no, fare_conditions)
VALUES
('763', '1A', 'Business'),
('763', '1B', 'Business'),
('763', '10A', 'Economy'),
('763', '10B', 'Economy'),
('763', '10F', 'Economy'),
('763', '20F', 'Economy'),
('773', '1A', 'Economy'),
('773', '1B', 'Economy'),
('773', '1C', 'Comfort'),
('773', '1D', 'Comfort'),
('773', '1E', 'Business'),
('773', '1F', 'Business'),
('773', '2A', 'Economy'),
('773', '2B', 'Economy'),
('773', '2C', 'Comfort'),
('773', '2D', 'Comfort'),
('773', '2E', 'Business'),
('773', '2F', 'Business'),
('773', '3A', 'Economy'),
('773', '3B', 'Economy'),
('773', '3C', 'Comfort'),
('773', '3D', 'Comfort'),
('773', '3E', 'Business'),
('773', '3F', 'Business'),
('733', '1A', 'Economy'),
('733', '1B', 'Economy'),
('733', '1C', 'Comfort'),
('733', '1D', 'Comfort'),
('733', '1E', 'Business'),
('733', '1F', 'Business'),
('733', '2A', 'Economy'),
('733', '2B', 'Economy'),
('733', '2C', 'Comfort'),
('733', '2D', 'Comfort'),
('733', '2E', 'Business'),
('733', '2F', 'Business'),
('320', '1A', 'Economy'),
('320', '1B', 'Economy'),
('320', '1C', 'Comfort'),
('320', '1D', 'Comfort'),
('320', '1E', 'Business'),
('320', '1F', 'Business'),
('320', '2A', 'Economy'),
('320', '2B', 'Economy'),
('320', '2C', 'Comfort'),
('320', '2D', 'Comfort'),
('320', '2E', 'Business'),
('320', '2F', 'Business'),
('321', '1A', 'Economy'),
('321', '1B', 'Economy'),
('321', '1C', 'Comfort'),
('321', '1D', 'Comfort'),
('321', '1E', 'Business'),
('321', '1F', 'Business'),
('321', '2A', 'Economy'),
('321', '2B', 'Economy'),
('321', '2C', 'Comfort'),
('321', '2D', 'Comfort'),
('321', '2E', 'Business'),
('321', '2F', 'Business'),
('319', '1A', 'Economy'),
('319', '1B', 'Economy'),
('319', '1C', 'Comfort'),
('319', '1D', 'Comfort'),
('319', '1E', 'Business'),
('319', '1F', 'Business'),
('319', '2A', 'Economy'),
('319', '2B', 'Economy'),
('319', '2C', 'Comfort'),
('319', '2D', 'Comfort'),
('319', '2E', 'Business'),
('319', '2F', 'Business'),
('CN1', '1A', 'Economy'),
('CN1', '1B', 'Economy'),
('CN1', '1C', 'Comfort'),
('CN1', '1D', 'Comfort'),
('CN1', '1E', 'Business'),
('CN1', '1F', 'Business'),
('CR2', '1A', 'Economy'),
('CR2', '1B', 'Economy'),
('CR2', '1C', 'Comfort'),
('CR2', '1D', 'Comfort'),
('CR2', '1E', 'Business'),
('CR2', '1F', 'Business')

ON CONFLICT (aircraft_code, seat_no) DO NOTHING;

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
