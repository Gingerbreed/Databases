﻿DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS agents;
DROP TABLE IF EXISTS products;


-- Customers --
CREATE TABLE customers (
  cid      char(4) not null,
  name     text,
  city     text,
  discount decimal(5,2),
 primary key(cid)
);


-- Agents --
CREATE TABLE agents (
  aid     char(3) not null,
  name    text,
  city    text,
  percent real,
 primary key(aid)
);        


-- Products --
CREATE TABLE products (
  pid      char(3) not null,
  name     text,
  city     text,
  quantity integer,
  priceUSD numeric(10,2),
 primary key(pid)
);


-- Orders -- 
CREATE TABLE orders (
  ordno   integer not null,
  mon     char(3),    
  cid     char(4) not null references customers(cid),
  aid     char(3) not null references agents(aid),
  pid     char(3) not null references products(pid),
  qty     integer,
  dollars numeric(12,2),
 primary key(ordno)
);



-- SQL statements for loading example data into the CAP2 database
-- Tested on Postgres 9.3.2
-- Connect to your Postgres server and set the active database to CAP2.  Then . . .

-- Customers --
INSERT INTO Customers( cid, name, city, discount )
  VALUES('c001', 'Tiptop', 'Duluth', 10.00);

INSERT INTO Customers( cid, name, city, discount )
  VALUES('c002', 'Basics', 'Dallas', 12.00);

INSERT INTO Customers( cid, name, city, discount )
  VALUES('c003', 'Allied', 'Dallas', 8.00);

INSERT INTO Customers( cid, name, city, discount )
  VALUES('c004' ,'ACME' ,'Duluth', 8.00);

INSERT INTO Customers( cid, name, city, discount )
  VALUES('c005' ,'Weyland-Yutani', 'Acheron', 0.00);

INSERT INTO Customers( cid, name, city, discount )
  VALUES('c006' ,'ACME' ,'Kyoto' ,0.00);


-- Agents --
INSERT INTO Agents( aid, name, city, percent )
  VALUES('a01', 'Smith', 'New York', 6 );

INSERT INTO Agents( aid, name, city, percent )
  VALUES('a02', 'Jones', 'Newark', 6 );

INSERT INTO Agents( aid, name, city, percent )
  VALUES('a03', 'Brown', 'Tokyo', 7 );

INSERT INTO Agents( aid, name, city, percent )
  VALUES('a04', 'Gray', 'New York' ,6 );

INSERT INTO Agents( aid, name, city, percent )
  VALUES('a05', 'Otasi', 'Duluth', 5 );

INSERT INTO Agents( aid, name, city, percent )
  VALUES('a06', 'Smith', 'Dallas', 5 );

INSERT INTO Agents( aid, name, city, percent )
  VALUES('a08', 'Bond', 'London', 7 );


-- Products --
INSERT INTO Products( pid, name, city, quantity, priceUSD )
  VALUES('p01', 'comb', 'Dallas', 111400, 0.50 );

INSERT INTO Products( pid, name, city, quantity, priceUSD )
  VALUES('p02', 'brush', 'Newark', 203000, 0.50 );

INSERT INTO Products( pid, name, city, quantity, priceUSD )
  VALUES('p03', 'razor', 'Duluth', 150600, 1.00 );

INSERT INTO Products( pid, name, city, quantity, priceUSD )
  VALUES('p04', 'pen', 'Duluth', 125300, 1.00 );

INSERT INTO Products( pid, name, city, quantity, priceUSD )
  VALUES('p05', 'pencil', 'Dallas', 221400, 1.00 );

INSERT INTO Products( pid, name, city, quantity, priceUSD )
  VALUES('p06', 'folder','Dallas', 123100, 2.00 );

INSERT INTO Products( pid, name, city, quantity, priceUSD )
  VALUES('p07', 'case', 'Newark', 100500, 1.00 );

INSERT INTO Products( pid, name, city, quantity, priceUSD )
  VALUES('p08', 'clip', 'Newark', 200600, 1.25 );


-- Orders --
INSERT INTO Orders( ordno, mon, cid, aid, pid, qty, dollars )
  VALUES(1011, 'jan', 'c001', 'a01', 'p01', 1000, 450.00);

INSERT INTO Orders( ordno, mon, cid, aid, pid, qty, dollars )
  VALUES(1013, 'jan', 'c002', 'a03', 'p03', 1000, 880.00);

INSERT INTO Orders( ordno, mon, cid, aid, pid, qty, dollars )
  VALUES(1015, 'jan', 'c003', 'a03', 'p05', 1200, 1104.00);

INSERT INTO Orders( ordno, mon, cid, aid, pid, qty, dollars )
  VALUES(1016, 'jan', 'c006', 'a01', 'p01', 1000, 500.00);
  
INSERT INTO Orders( ordno, mon, cid, aid, pid, qty, dollars )
  VALUES(1017, 'feb', 'c001', 'a06', 'p03',  600, 540.00);

INSERT INTO Orders( ordno, mon, cid, aid, pid, qty, dollars )
  VALUES(1018, 'feb', 'c001', 'a03', 'p04',  600, 540.00);

INSERT INTO Orders( ordno, mon, cid, aid, pid, qty, dollars )
  VALUES(1019, 'feb', 'c001', 'a02', 'p02',  400, 180.00);

INSERT INTO Orders( ordno, mon, cid, aid, pid, qty, dollars )
  VALUES(1020, 'feb', 'c006', 'a03', 'p07',  600, 600.00);
  
INSERT INTO Orders( ordno, mon, cid, aid, pid, qty, dollars )
  VALUES(1021, 'feb', 'c004', 'a06', 'p01', 1000, 460.00);

INSERT INTO Orders( ordno, mon, cid, aid, pid, qty, dollars )
  VALUES(1022, 'mar', 'c001', 'a05', 'p06',  400, 720.00);
    
INSERT INTO Orders( ordno, mon, cid, aid, pid, qty, dollars )
  VALUES(1023, 'mar', 'c001', 'a04', 'p05',  500, 450.00);

INSERT INTO Orders( ordno, mon, cid, aid, pid, qty, dollars )
  VALUES(1024, 'mar', 'c006', 'a06', 'p01',  800, 400.00);
  
INSERT INTO Orders( ordno, mon, cid, aid, pid, qty, dollars )
  VALUES(1025, 'apr', 'c001', 'a05', 'p07',  800, 720.00);

INSERT INTO Orders( ordno, mon, cid, aid, pid, qty, dollars )
  VALUES(1026, 'may', 'c002', 'a05', 'p03',  800, 740.00);


-- SQL statements for displaying example data into the CAP2 database
-- Connect to your Postgres server and set the active database to CAP2.  Then . . .

select * from customers;
select * from agents;
select * from products;
select * from orders;


select name,city from customers c
where city in(
	select city from 
		(select count(*) as cnt, city
		from products
		group by city
		order by cnt desc
		limit 1) 
	as max);

select name from 
products where priceUSD in
	(select priceUSD 
	from products
	where priceUSD <
		(select avg(priceUSD)
		from products)
	);

select c.name, o.pid, o.dollars
from customers c inner join orders o
on c.cid =o.cid
order by o.dollars desc;

select coalesce(c.name), sum(o.dollars)
from customers c left outer join orders o
on c.cid = o.cid 
where c.cid in (select cid from customers)
group by c.name;

select c.name,p.name,a.name 
from customers c
join orders o
on c.cid=o.cid
join agents a
on o.aid = a.aid 
join products p
on o.pid= p.pid
where a.city='Tokyo'
order by c.name;


select * from orders o
join products p
on o.pid=p.pid
join customers c
on o.cid=c.cid
WHERE o.dollars!=p.priceUSD*o.qty *(1 - c.discount/100);

-- 7. the difference between a left outer join and a right outer join
-- is which table has all their rows included. If a left outer join is
-- used, the table to the left of the join clause has all rows included.
-- If a right outer join is used, then the table to the right has all rows
-- included. Run the following two queries to see for yourself.

select * 
from customers c left outer join agents a
on c.city = a.city;

select * 
from customers c right outer join agents a
on c.city = a.city;
