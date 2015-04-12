drop table purchases;
drop table suppliers;
drop table clothes;
CREATE TABLE suppliers (
  sid     integer not null,
  name    text,
  street  text,
  city    text,
  state   char(2),
  postal  numeric(5,0),
  contact numeric(10,0),
  payment integer,
 primary key(sid)
); 

CREATE TABLE clothes (
  sku     integer not null,
  description     text,
  quantity integer,
  priceUSD numeric(10,2),
 primary key(sku)
);

CREATE TABLE purchases (
  purchno integer not null,
  sku     integer not null references clothes(sku),
  sid     integer not null references suppliers(sid),
  orderdate date,
  quantity integer,
  priceUSD numeric(10,2),
  comments text,
 primary key(purchno)
);
INSERT INTO suppliers(sid,name, street,city, state, postal, contact, payment )
  VALUES(1,'Tiptop', '1210 Duluth Rd', 'Chicago', 'IL', 23465, 3453424352, 5),
	(2,'Bond','007 James Ct','New York','NY', 20933, 4039158015, 7),
	(3,'Dimitri','300 Colada Way','Los Angeles','CA', 49034, 5784927944, 4);	

INSERT INTO clothes(sku,description, quantity, priceUSD )
  VALUES(4,'Yellow Suit', 39, 150),
	(5,'Purple Haze', 40, 70),
	(6,'Slacks', 34, 50);
INSERT INTO purchases(purchno, sku, sid, orderdate, quantity, priceUSD, comments)
  VALUES(7, 6, 1, '2015-01-08', 40, 1500, 'Pants.'),
	(8, 5, 2, '2015-03-25', 20, 600, 'From Russia With Love.'),
	(9, 4, 3, '2015-04-12', 10, 700, 'Tacky.');
select * from suppliers;
select * from clothes;
select * from purchases;

select c.quantity + p.quantity as Quantity
FROM clothes c, purchases p
WHERE c.sku = p.sku AND c.sku = 5;
	

