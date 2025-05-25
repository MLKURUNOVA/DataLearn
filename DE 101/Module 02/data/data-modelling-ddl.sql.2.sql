
drop table if exists calendar_dim cascade;
CREATE TABLE calendar_dim
(
 order_date date NOT NULL,
 ship_date  date NOT NULL,
 year       int NOT NULL,
 quarter    int NOT NULL,
 month      int NOT NULL,
 week       int NOT NULL,
 week_day   varchar(15) NOT NULL,
 CONSTRAINT PK_1 PRIMARY KEY ( order_date, ship_date )
);
truncate table calendar_dim;
insert into calendar_dim (order_date, ship_date, year, quarter, month, week, week_day)
select distinct 
     order_date,
     ship_date, 
     EXTRACT(YEAR FROM order_date) AS year,
     EXTRACT(QUARTER FROM order_date) AS quarter,
     EXTRACT(MONTH FROM order_date) AS month,
     EXTRACT(WEEK FROM order_date) AS week,
     TO_CHAR(order_date, 'Day') AS week_day
from orders;

select * from calendar_dim;

-------------------------------------------------------------------------

drop table if exists product_dim cascade;
CREATE TABLE product_dim
(
 product_id   varchar(20) NOT NULL,
 category     varchar(20) NOT NULL,
 subcategory  varchar(15) NOT NULL,
 segment      varchar(15) NOT NULL,
 product_name varchar(150) NOT NULL,
 CONSTRAINT PK_3 PRIMARY KEY ( product_id )
);
truncate table product_dim;
insert into product_dim (product_id,category,subcategory,segment,product_name)
select distinct on (product_id)
     product_id,
     category,
     subcategory,
     segment,
     product_name
from orders;

select * from product_dim;

-----------------------------------------------------------------------------

drop table if exists shipping_dim cascade;
CREATE TABLE shipping_dim
(
 ship_id   int NOT NULL,
 ship_mode varchar(20) NOT NULL,
 CONSTRAINT PK_5 PRIMARY KEY ( ship_id )
);
truncate table shipping_dim;
insert into shipping_dim
select 100+row_number()over(), 
       ship_mode
from (select distinct ship_mode from orders) a;

select * from shipping_dim;

-----------------------------------------------------------------------------

drop table if exists returns_dim cascade;
CREATE TABLE returns_dim
(
 order_id varchar(20) NOT NULL,
 returned varchar(10) null,
 CONSTRAINT PK_6 PRIMARY KEY ( order_id )
);
truncate table returns_dim;
insert into returns_dim (order_id,returned)
select distinct 
    o.order_id,
    r.returned
from orders o left join (select distinct order_id,returned from returns r ) r on o.order_id=r.order_id;

select * from returns_dim;

-------------------------------------------------------------------------------

drop table if exists customers_dim cascade;
CREATE TABLE customers_dim
(
 customer_id   varchar(50) NOT NULL,
 customer_name varchar(50) NOT NULL,
 CONSTRAINT PK_7 PRIMARY KEY ( customer_id )
);
truncate table customers_dim;
insert into customers_dim (customer_id, customer_name)
select distinct
     customer_id,
     customer_name
from orders;

select * from customers_dim;

---------------------------------------------------------------------------------
         
drop table if exists people_dim cascade;
CREATE TABLE people_dim
(
 region varchar(50) NOT NULL,
 person varchar(50) NOT NULL,
 CONSTRAINT PK_8 PRIMARY KEY ( region )
);
truncate table people_dim;
insert into people_dim
select region,
       person
from (select distinct region, person from people) b;

select * from people_dim;

----------------------------------------------------------------------------------

drop table if exists geographic_dim cascade;
CREATE TABLE geographic_dim
(
 geo_id      int NOT NULL,
 country     varchar(20) NOT NULL,
 city        varchar(20) NOT NULL,
 "state"     varchar(20) NOT NULL,
 region      varchar(20) NOT NULL,
 postal_code int NULL,
 region_1    varchar(50) NOT NULL,
 CONSTRAINT PK_4 PRIMARY KEY ( geo_id ),
 CONSTRAINT FK_1 FOREIGN KEY ( region_1 ) REFERENCES people_mis ( region )
);
truncate table geographic_dim;
insert into geographic_dim
select 10+row_number()over(),
       country,
       city,
       state,
       region,
       postal_code,
       region
from (select distinct country,
                      city,
                      state,
                      region,
                      postal_code
      from orders);

select * from geographic_dim;

-------------------------------------------------------------------------------------

drop table if exists sales_fact cascade;
CREATE TABLE sales_fact
(
 row_id      int NOT NULL,
 order_id    varchar(20) NOT NULL,
 sales       numeric(9,4) NOT NULL,
 profit      numeric(21,16) NOT NULL,
 quantity    int NOT NULL,
 discount    numeric(4,2) NOT NULL,
 order_date  date NOT NULL,
 geo_id      int NOT NULL,
 product_id  varchar(20) NOT NULL,
 ship_id     int NOT NULL,
 customer_id varchar(50) NOT NULL,
 ship_date   date NOT NULL,
 CONSTRAINT PK_2 PRIMARY KEY ( row_id ),
 CONSTRAINT FK_1 FOREIGN KEY ( order_date, ship_date ) REFERENCES calendar_dim ( order_date, ship_date ),
 CONSTRAINT FK_2 FOREIGN KEY ( geo_id ) REFERENCES geographic_dim ( geo_id ),
 CONSTRAINT FK_3 FOREIGN KEY ( product_id ) REFERENCES product_dim ( product_id ),
 CONSTRAINT FK_4 FOREIGN KEY ( ship_id ) REFERENCES shipping_dim ( ship_id ),
 CONSTRAINT FK_5 FOREIGN KEY ( order_id ) REFERENCES returns_dim ( order_id ),
 CONSTRAINT FK_6 FOREIGN KEY ( customer_id ) REFERENCES customers_dim ( customer_id )
);
truncate table sales_fact;
insert into sales_fact 
select o.row_id,
       o.order_id,
       o.sales,
       o.profit,
       o.quantity,
       o.discount,
       cm.order_date,
       g.geo_id,
       pm.product_id,
       sm.ship_id,
       c.customer_id,
       cm.ship_date
from orders o join product_dim pd on o.product_id=pd.product_id and o.product_name=pd.product_name
              join calendar_dim cd on o.order_date=cd.order_date and o.ship_date=cd.ship_date
              join shipping_dim sd on o.ship_mode=sd.ship_mode
              join customers_dim c on o.customer_id=c.customer_id and o.customer_name=c.customer_name
              join geographic_dim g on o.country=g.country and
                                   o.city=g.city and
                                   o.state=g.state and
                                   o.region=g.region and
                                   o.postal_code=g.postal_code;

select * from sales_fact;
