--
-- Ricky's Pizzeria Script
-- The script to create the Database for Ricky's Pizzeria
-- By Morgan Baker
--Create the People Table
Create table People (
 people_id SERIAL NOT NULL UNIQUE,
 first_name VARCHAR(15) NOT NULL,
 last_name VARCHAR(15) NOT NULL,
 gender VARCHAR(1) NOT NULL,
 Primary Key (people_id)
);
-- populate the People table
insert into People (first_name, last_name, gender)VALUES
 ('Alan', 'Labouseur', 'M'),
 ('Ricky', 'Taramindo', 'M'),
 ('Morgan', 'Baker', 'M'),
 ('Primrose', 'Serafin', 'F'),
 ('Jade', 'Townsend', 'F'),
 ('Kathryn', 'Adams', 'F'),
 ('Felicia', 'Smith', 'F');
select * from people;

--Create the ZIP table
Create table ZIP(
 ZIPCode NUMERIC(5) NOT NULL UNIQUE,
 City TEXT NOT NULL,
 State VARCHAR(2),
  Primary Key (ZIPCode) 
);
-- Populate the ZIP Table
insert into ZIP (ZIPCode, City, State)VALUES
 (33098, 'DataVille', 'NY'),
 (12601, 'Poughkeepsie', 'NY'),
 (20895, 'Kensington', 'MD')
;
select * from ZIP;

--Create the Customer table
Create table Customers(
 customer_id INT NOT NULL UNIQUE references People(people_id),
 street_Add VARCHAR(30) NOT NULL,
 ZIPCode numeric(5) NOT NULL references ZIP(ZIPCode),
  Primary Key (customer_id)
);
-- Populate the Customers table
insert into Customers(customer_id, street_Add, ZIPCode) VALUES
 (5,'2004 IDK Drive', 33098),
 (3,'3399 North Rd', 12601),
 (4,'9919 Stoneybrook Drive', 20895);
select * from customers order by customer_id;

--Create the Employees table
Create table Employees(
 employee_id INT NOT NULL UNIQUE references People(people_id),
 Salary money NOT NULL,
 Position VARCHAR(20) NOT NULL,
 Boss VARCHAR(20) NOT NULL,
  Primary Key (employee_id)
);
--Populate the Employees table
insert into Employees(employee_id,salary,position,boss)VALUES
(3, 12.50, 'Database Freak', 'Alan Labouseur'),
(6, 15.00, 'Delivery Girl', 'Alan Labouseur'),
(1, 50.34, 'Shift Manager', 'Ricky Taramindo'),
(2, 150.95, 'The Man','Ricky Taramindo');
select * from employees;

--Create the Pizzas Table
Create table Pizzas(
 PizzaName VARCHAR(30) NOT NULL UNIQUE,
 description VARCHAR(120) NOT NULL,
 PriceUSD money NOT NULL,
 Feeds int NOT NULL,
 Primary Key (PizzaName)
);
--Populate the Pizzas table
insert into Pizzas(PizzaName, description, PriceUSD, Feeds)VALUES
('Plain', 'Just good pizza', '10.00', '6'),
('Meat Lovers', 'All types of meat on this one', '15.00', '6'),
('Smorgasbord', 'Can this even be called a pizza anymore?', '40.00', '20');
select * from pizzas;

--Create the Orders Table
Create table Orders(
 Cust_ID int NOT NULL references Customers(customer_id),
 Emp_ID int NOT NULL  references Employees(employee_id),
 Pizza VARCHAR(30) NOT NULL references Pizzas(PizzaName),
 orderdate timestamp NOT NULL,
 Primary Key (Cust_ID, Emp_ID, Pizza, orderdate)
);
--populate Orders Table
insert into Orders(Cust_ID, Emp_ID, Pizza, orderdate)VALUES
(4, 2, 'Plain', now()),
(5, 6, 'Meat Lovers', '2015-04-29 17:40:43.508'),
(3, 1, 'Smorgasbord', '2015-05-01 20:22:32.695'),
(4, 6, 'Meat Lovers', now()),
(5, 1, 'Meat Lovers', '2015-11-29 13:40:43.508'),
(3, 1, 'Plain', '2015-05-02 10:22:32.695');
;
select * from orders;

-- Views 
Create View EmployeeInfo as
	select p.first_name, p.last_name, e.salary, e.position, e.boss
	from employees e, people p
	where p.people_id = e.employee_id 
	order by p.last_name;

select * from EmployeeInfo;

Create View CustomerData as
	select p.first_name, p.last_name, c.street_Add, c.ZIPCode, z.city, z.state
	from people p, customers c, zip z
	where p.people_id = c.customer_id and c.ZIPCode = z.ZIPCode;
select * from CustomerData;

--Queries

--The most popular pizza, along with it's description
select o.pizza, p.description from pizzas p left join orders o 
on p.pizzaname = o.pizza
group by pizza, description
having count(*) = (
  select count(*) from orders
  group by pizza
  order by count(*) desc
  limit 1);

--Show Employees that are also customers
select p.first_name, p.last_name, c.street_add, e.position, e.salary, e.boss
from people p, customers c, employees e
where p.people_id = c.customer_id and p.people_id = e.employee_id and c.customer_id = e.employee_id;

--Stored Procedures!
--This automatically adds a new customer row for every employee)
CREATE OR REPLACE FUNCTION NewCustomer() RETURNS trigger AS
$BODY$
  DECLARE
   added int := (Select people_id 
		 from people p , employees e
		 where people_id = employee_id limit 1)+1;
  BEGIN
	INSERT INTO customers(customer_id, street_Add, ZIPCode)VALUES
	(added, '124 Cherry Lane', 33098);
	Return NEW;
 END;
 $BODY$
 LANGUAGE PLPGSQL;

 CREATE TRIGGER Employee_Customer
 AFTER INSERT ON employees
 FOR EACH ROW 
 EXECUTE PROCEDURE NewCustomer();

Insert into Employees(employee_id, salary, position, boss)VALUES
(7, 30.00, 'Mascot', 'Alan Labouseur');
;
select * from customers;
--This shows all the customers in a zip code
CREATE OR REPLACE FUNCTION ShowZIP (numeric(5), REFCURSOR) 
RETURNS REFCURSOR AS
$$
  DECLARE
   resultset REFCURSOR := $2;
   Code numeric(5) := $1;
  BEGIN
	open resultset for 
	select p.first_name, p.last_name 
	from customers c, people p 
	where customer_id = people_id and ZIPCode = Code;
	return resultset;
 END;
 $$
 LANGUAGE PLPGSQL;

select ShowZIP(33098, 'results');
Fetch all from results;

-- Security Roles

CREATE ROLE Ricky;
GRANT ALL ON ALL TABLES IN SCHEMA PUBLIC 
to Ricky;

CREATE ROLE Advertiser;
GRANT INSERT ON pizzas TO Advertiser;
GRANT UPDATE ON pizzas TO Advertiser;
GRANT SELECT ON pizzas, orders, customers, people TO Advertiser;

CREATE ROLE ShiftManager;
GRANT SELECT ON employees, people, customers, pizzas, orders, ZIP TO ShiftManager;
GRANT INSERT ON employees, people, customers, orders, ZIP TO ShiftManager;
GRANT UPDATE ON employees, customers, orders, ZIP TO ShiftManager;

CREATE ROLE Users;
GRANT SELECT ON people, customers, pizzas, orders, ZIP TO Users;
GRANT INSERT ON people, customers, orders, ZIP TO Users;
GRANT UPDATE ON customers, orders TO Users;
