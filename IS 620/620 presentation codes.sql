
-- 1.create table Cuisine Type

create table cuisineType(
    cuisine_type_ID int,
    cuisine_name varchar(100),
	primary key(cuisine_type_ID)
);

-- 2.Creation of restaurant table
create table restaurant (
    restaurant_ID int,
    restaurant_name varchar(100),
    cuisine_type_ID int,
    streetAdres varchar(200),
    city varchar(50),
    State varchar(50),
    zip char(5),
primary key(restaurant_ID),
foreign key(cuisine_type_ID) references cuisineType(cuisine_type_ID));

-- 3.Create Waiter table
create table waiters(
  waiter_id int,
  restaurant_id int,
  waiter_name varchar(50),
primary key(waiter_id),
foreign key(restaurant_ID) references restaurant(restaurant_ID)  
);

--------------------------------------------------------------------------------------
---4. Create menu items
create table menu_items(menu_item_id int,cuisine_type_id int,
menu_item_name varchar(50),price number(5,2),
primary key(menu_item_id),
foreign key(cuisine_type_id) 
references cuisineType(cuisine_type_id));
----5. Create Restaurant Inventory----------------------------------------------------------------------------------
create table RESTAURANT_INVENTORY(menu_item_id int,
Restaurant_ID int,menu_item_name varchar(50),
quantity number,
foreign key(Restaurant_ID)
references Restaurant(Restaurant_ID),
foreign key(menu_item_id) 
references menu_items(menu_item_id));


-----------------5. Create customer table---------------------------------------------------------------------

--create table customer
create table customer(
    customer_ID number(10) primary key, 
                      name varchar(25),
                      email varchar2(25),
                      street_address varchar2(20),city varchar2(20),
                      c_state varchar2(20), 
                      zip number(6),
                      credit_card number(16));

--6. reate orders table 
CREATE TABLE Orders (
    order_id int NOT NULL,
	restaurant_ID  int,
	customer_ID  int,
	menu_item_ID int,
	Waiter_id int,
	order_date date,
	amount_paid float,
	tip float,
		FOREIGN KEY(Restaurant_ID) REFERENCES Restaurant(Restaurant_ID),
		FOREIGN KEY (customer_ID) REFERENCES Customer(customer_ID),
		FOREIGN KEY (Menu_item_ID) REFERENCES Menu_items(Menu_item_ID),
		FOREIGN KEY (Waiter_id) REFERENCES Waiters(Waiter_id),
        PRIMARY KEY(Order_id));

create sequence cuisinetype_seq start with 101;
create sequence restaurant_seq start with 1;

create sequence waiters_seq start with 10;

create sequence muid_seq start with 200;

create sequence customerID_seq start with 901;

create sequence OrderID_seq start with 40387;

---procedure for inserting cuisinetype table
create or replace procedure insertcuisinetype(
    c_name in varchar) 
    is
    begin
    insert into cuisinetype values(cuisinetype_seq.nextval, c_name);
    exception
        when no_data_found then
        dbms_output.put_line('Need value for cuisine type');
    end;
/

---procedure of inserting the restaurant table
create or replace procedure insertrestaurant(
r_name in varchar, c_id in int, s_address in varchar, r_city in varchar, r_state in varchar, r_zip in char)
is 
begin
insert into restaurant values(restaurant_seq.nextval, r_name, c_id, s_address, 
    r_city, r_state, r_zip);
    exception
    when no_data_found then
    dbms_output.put_line('Need the appropriate value for the restaurant');
 -- if user is adding the value in unordered form
    when others then
    dbms_output.put_line('Add the value in the order');
End; 
/
 
-- functions for getting cuisinetype id
create or replace function find_cuisine_type_id(c_name in varchar) 
-- returnig the target vairable datatype
return number
is 
c_id number;
begin
-- putting the value of column into variable
select cuisine_type_id into c_id from cuisinetype where cuisine_name=c_name;
return c_id;
exception
    when no_data_found then
    dbms_output.put_line('no such cuisine name');
    return -1;
end;    
/

-- function for getting retaurant ID
create or replace function find_restaurant_id(r_name in varchar)
return number
is
r_id number;
begin
select restaurant_id into r_id from restaurant where restaurant_name = r_name;
return r_id;
    exception
    when no_data_found then
    dbms_output.put_line('No such restaurant name');
    return -1;
end;
/

create or replace procedure insertwaiters(r_id in int, w_name in varchar)
is
begin
insert into waiters values(waiters_seq.nextval,r_id,w_name);
exception
 when no_data_found then
 dbms_output.put_line('Not inserted');
end;
/
Create or replace function FIND_WAITER_ID (w_name in varchar) return number
IS
w_id number;
BEGIN
    select waiter_ID into w_id from Waiters where waiter_name = w_name;
    return w_id;
exception
    when no_data_found then
    dbms_output.put_line('no such data found');
    return -1;
End;
/

------------------------------Procedure for Menu items--------------------------------------------------------
create or replace procedure insert_menu_item( cuisine_name varchar, menu_name varchar, price_of_menu float)
as
cuisine_id int;
begin
    cuisine_id := FIND_CUISINE_TYPE_ID(cuisine_name);
    insert into MENU_ITEMS values(MUID_SEQ.nextval, cuisine_id, menu_name, price_of_menu);
end;
/
-------------------Fuction for Menu Items-------------------------------------------------------------------
Create or replace function FIND_MENU_ITEM_ID(mu_item_name varchar)
return int
IS
menuitem_id int;
Begin
Select max(menu_item_id) as mid into menuitem_id from menu_items where menu_item_name=mu_item_name;
return menuitem_id;
End;
/
-----------------------Procedure for Restaurant Inventory---------------------------------------------------------------

Create or Replace Procedure INSERT_RESTAURANT_INVENTORY(restaurant_name varchar,menu_name varchar,quantity int)
AS
menu_id int;
restaurant_id int; 
Begin
menu_id := Find_menu_item_id(menu_name);
restaurant_id := find_restaurant_id(restaurant_name);
insert into Restaurant_inventory values(menu_id,restaurant_id,menu_name,quantity);
end;
/

--create procedure for inserting values into CUSTOMER table

create or replace procedure insertcustomerID(
cs_name in customer.name%type,
email in customer.email%type,
street_address in customer.street_address%type,
city in customer.city%type,
state in customer.c_state%type,
zip in customer.zip%TYPE,
cc in customer.credit_card%type)
is
begin
insert into customer(customer_ID,name,email,street_address,city,c_state,zip,credit_card) values(customerID_seq.nextval,cs_name,email,street_address,city,state,zip,cc);
exception
 when no_data_found then
 dbms_output.put_line('Need value for customer');
 when others then 
 dbms_output.put_line('Add the value in order ');
 commit;
end;
/



-- function Helper_ID for customer_ID
set serveroutput on;
create or replace function find_customer_id(cs_name in customer.name%type)
return number
is
cs_id number;
begin
select customer_ID into cs_id from customer where name =cs_name; 
return cs_id;
exception
when no_data_found then
dbms_output.put_line('no such customer');
end;
/
-- Needs to update this
create or replace procedure insertorders(
Rest_name in varchar,
cust_name in varchar,
Menu_item_name in varchar,
Waiter_name in varchar,
order_date in string,
amount in float,
tip in float)
is
rest_id number;
cust_id number;
menu_id number;
w_id number;
begin
Rest_ID:=find_restaurant_id(Rest_name);
cust_ID:=find_customer_id(cust_name);
Menu_ID:=find_menu_item_id(Menu_item_name);
W_id:=find_waiter_id(Waiter_name);
if Rest_ID > 0 and cust_ID > 0 and Menu_ID > 0 and W_id > 0 then
insert into Orders values(OrderID_seq.nextval, Rest_ID, cust_ID,Menu_ID, W_id, TO_DATE(order_date,'YYYY/MM/DD'),amount,tip);
commit;
ELSE
dbms_output.put_line('NO DATA FOUND');
END IF;
    exception
    when no_data_found then
    dbms_output.put_line('Insert a valid input/values for the Orders');
    when others then
    dbms_output.put_line('Insert the data in a valid order');
End;

-- Entering the data for cuisinetype
exec insertcuisinetype('American');
exec insertcuisinetype('Italian');
exec insertcuisinetype('Indian');
exec insertcuisinetype('BBQ');
exec insertcuisinetype('Ethiopian');

-- Entering the data for restaurant
exec insertrestaurant('Ribs_R_US', find_cuisine_type_id('American'), '400 Hahn dr', 'Catonsville', 'MD',  '21250');
exec insertrestaurant('Bella Italia', find_cuisine_type_id('Italian'), '103 Independence Ave', 'columbia', 'MD', '21043');
exec insertrestaurant('Roma', find_cuisine_type_id('Italian'), '105 Light str', 'columbia', 'MD', '21043');
exec insertrestaurant('Bull Roast', find_cuisine_type_id('BBQ'), '10140 Reisterstown Rd', 'Pulaski', 'NY', '10013');
exec insertrestaurant('Taj Mahal', find_cuisine_type_id('Indian'), '9419 common brook Rd', 'Owings Mills', 'NY', '10013');
exec insertrestaurant('Selasie', find_cuisine_type_id('Ethiopian'), '9419 common brook Rd', 'Pittsburg', 'PA', '16822');
--- Add this line
exec insertrestaurant('Ethiop', find_cuisine_type_id('Ethiopian'), '1023 peidominant dr', 'Pittsburg', 'PA', '16822');


-- Values are inserting in to the waiters table using exec

exec insertwaiters(find_restaurant_id('Ribs_R_US'),'Jack');
exec insertwaiters(find_restaurant_id('Ribs_R_US'),'Jill');
exec insertwaiters(find_restaurant_id('Ribs_R_US'),'Wendy');
exec insertwaiters(find_restaurant_id('Ribs_R_US'),'Hailey');
exec insertwaiters(find_restaurant_id('Bella Italia'),'Mary');
exec insertwaiters(find_restaurant_id('Bella Italia'),'Pat');
exec insertwaiters(find_restaurant_id('Bella Italia'),'Michael');
exec insertwaiters(find_restaurant_id('Bella Italia'),'Rakesh');
exec insertwaiters(find_restaurant_id('Bella Italia'),'Verma');
exec insertwaiters(find_restaurant_id('Roma'),'Mike');
exec insertwaiters(find_restaurant_id('Roma'),'Judy');
exec insertwaiters(find_restaurant_id('Selasie'),'Trevor');
-- Add this line
exec insertwaiters(find_restaurant_id('Ethiop'), 'Trudy');
exec insertwaiters(find_restaurant_id('Ethiop'), 'Trisha');
exec insertwaiters(find_restaurant_id('Ethiop'), 'Tariq');
------------
exec insertwaiters(find_restaurant_id('Taj Mahal'),'Chap');
exec insertwaiters(find_restaurant_id('Bull Roast'),'Hannah');


set serveroutput on;
exec insert_menu_item('American','Burger',10);
exec insert_menu_item('American','fries',5);
exec insert_menu_item('American','pasta',15);
exec insert_menu_item('American','salad',10);
exec insert_menu_item('American','salmom',20);
exec insert_menu_item('Italian','Lasagna',15);
exec insert_menu_item('Italian','Meatballs',10);
exec insert_menu_item('Italian','Spaghetti',15);
exec insert_menu_item('Italian','Pizza',20);
exec insert_menu_item('BBQ','Steak',25);
exec insert_menu_item('BBQ','Burger',10);
exec insert_menu_item('BBQ','Pork_Loin',15);
exec insert_menu_item('BBQ','Fillet_Mignon',30);
exec insert_menu_item('Indian','Dal_Soup',10);
exec insert_menu_item('Indian','Rice',5);
exec insert_menu_item('Indian','Tandoori_Chicken',10)
exec insert_menu_item('Indian','Samosa',8);
exec insert_menu_item('Ethiopian','Meat_Chunks',12);
exec insert_menu_item('Ethiopian','Legume_Stew',10);
exec insert_menu_item('Ethiopian','Flatbread',3);

-----------------------

/

exec INSERT_RESTAURANT_INVENTORY('Ribs_R_US','Burger',50);
exec INSERT_RESTAURANT_INVENTORY('Ribs_R_US','fries',150);
exec INSERT_RESTAURANT_INVENTORY('Bella Italia','Lasagna',10);
exec INSERT_RESTAURANT_INVENTORY('Bella Italia','Meatballs',5);
exec INSERT_RESTAURANT_INVENTORY('Bull Roast','Steak',15);
exec INSERT_RESTAURANT_INVENTORY('Bull Roast','Pork_Loin',50);
exec INSERT_RESTAURANT_INVENTORY('Bull Roast','Fillet_Mignon',5);
exec INSERT_RESTAURANT_INVENTORY('Taj Mahal','Dal_Soup',50);
exec INSERT_RESTAURANT_INVENTORY('Taj Mahal','Rice',500);
exec INSERT_RESTAURANT_INVENTORY('Taj Mahal','Samosa',150);
exec INSERT_RESTAURANT_INVENTORY('Selasie','Meat_Chunks',150);
exec INSERT_RESTAURANT_INVENTORY('Selasie','Legume_Stew',150);
exec INSERT_RESTAURANT_INVENTORY('Selasie','Flatbread',500);
-- Add this line
exec insert_restaurant_inventory('Ethiop','Meat_Chunks',150);
exec insert_restaurant_inventory('Ethiop','Legume_Stew',150);
exec insert_restaurant_inventory('Ethiop','Flatbread',500);

---------------------Member 4------------------------------------

exec insertorders('Bella Italia','Cust1','Pizza','Mary', '2022/03/10', 20, (20*0.2));
commit;
exec insertorders('Bella Italia','Cust11','Spaghetti','Mary', '2022/03/15',30,(30*0.2));
commit;
exec insertorders('Bella Italia','Cust11','Pizza','Mary', '2022/03/15',20,(20*0.2));
commit;
exec insertorders('Bull Roast', 'CustNY1', 'Fillet_Mignon', 'Hannah','2022/04/01', 60,(60*0.2));
commit;
exec insertorders('Bull Roast', 'CustNY1', 'Fillet_Mignon', 'Hannah','2022/04/02', 60,(60*0.2));
commit;
exec insertorders('Bull Roast', 'CustNY2', 'Pork_Loin', 'Hannah','2022/04/01', 15,(15*0.2));
commit;
-- Add this lines
exec insertorders('Ethiop', 'CustPA1', 'Meat_Chunks', 'Trisha','2022/04/01', 120,(120*0.2));
commit;
exec insertorders('Ethiop', 'CustPA1', 'Meat_Chunks', 'Trisha','2022/05/01', 120,(120*0.2));
commit;
exec insertorders('Ethiop', 'CustPA1', 'Meat_Chunks', 'Trisha','2022/05/10', 120,(120*0.2));
commit;
exec insertorders('Ethiop', 'CustPA2', 'Legume_Stew', 'Trevor','2022/05/01', 100,(100*0.2));
commit;
exec insertorders('Ethiop', 'CustPA2', 'Legume_Stew', 'Trevor','2022/05/11', 100,(100*0.2));
commit;



-- Insert customer 
exec insertcustomerID('Cust1','billu@umbc.edu','5003 westland','Baltimore','MD',21045,1234123412341234);
exec insertcustomerID('Cust11','Cust11@umbc.edu','Maiden Choice','Baltimore','MD',21045,0987098709870987);
exec insertcustomerID('Cust3','Cust3@umbc.edu','Back Market','Baltimore','MD',21046,0987098709870987);
exec insertcustomerID('Cust111','Cust111@umbc.edu','Eldon Street','Baltimore','MD',21045,1234123412341234);
exec insertcustomerID('CustNY1','CustNY1@umbc.edu','Gopal Marg','New York','NY',10045,1234123412341037);
exec insertcustomerID('CustNY2','CustNY2@umbc.edu','Brown Street','New York','NY',10045,1234123412347090);
exec insertcustomerID('CustNY3','CustNY3@umbc.edu','Malibu Street','New York','NY',10045,1234123412341000);
exec insertcustomerID('CustPA1','CustPA1@umbc.edu','Marc Street','Philedelphia','PA',16822,1234123412341234);
exec insertcustomerID('CustPA2','CustPA2@umbc.edu','Belwood Street','Philedelphia','PA',16822,1234123412341234);
exec insertcustomerID('CustPA3','CustPA3@umbc.edu','Gabbar Street','Philedelphia','PA',16822,1234123412341234);
-- Add this lines--------------
exec insertcustomerID('CustPA4','CustPA4@umbc.edu','Red Label Street','Philedelphia','PA',16822,1234123412341037);
exec insertcustomerID('CustPA5','CustPA5@umbc.edu','Goa Street','Philedelphia','PA',16822,12345635672123456);
exec insertcustomerID('CustPA6','CustPA6@umbc.edu','Vile Parle Street','Philedelphia','PA',16822,9876545678654324);



--- Member 1 tasks----------

---- Select everying from restaurant
select * from restaurant;

-- Display restaurant by cuisine name


create or replace procedure return_restaurant_info (cuisine in varchar)
AS
cursor c1 is select restaurant_name, city from restaurant, cuisinetype
where restaurant.cuisine_type_id = cuisinetype.cuisine_type_id and cuisinetype.cuisine_name= cuisine;
restname varchar(30);
resaddr varchar(30);
begin
open c1;
loop
    fetch c1 into restname, resaddr;
    exit when c1%notfound;
    dbms_output.put_line('Restaurant Name: ' ||restname || ', Restaurant city:' || ' ' || resaddr);
end loop;
close c1;
end;
/

exec return_restaurant_info('Italian');
exec return_restaurant_info('Ehopian');

-----------------REPORT BY MEMBER 1 ----------------------------------
create or replace procedure income_by_state
is
cursor c1 is select state, sum(amount_paid)
from restaurant, orders
where restaurant.restaurant_id = orders.restaurant_id
group by state;
r_state varchar(30);
total number;
begin
dbms_output.put_line('-------------------------- REPORT BY MEMBER 1 ---------------');
open c1;
loop
    fetch c1 into r_state, total;
    exit when c1%notfound;
    dbms_output.put_line(r_state || ' state income is ' ||  total);
end loop;
end;
/

exec income_by_state;


--------------------------Member 2 taks-------------------------------

-----First Task-------------

create or replace procedure waiters__list(rest_name in varchar)-- this procedure is used to find the list of waiters in the restaurant
is
r_id int := find_restaurant_id(rest_name);
Begin
dbms_output.put_line(' -------------------------- REPORTS BY MEMBER 2 ---------------');
for a in (select waiter_id,restaurant_id,waiter_name from waiters where  restaurant_id = r_id)
    loop
   dbms_output.put_line('waitersid :' || a.waiter_id || '  restaurantIDs :' || a.restaurant_id|| ' waitersname :  ' || a.waiter_name);
    end loop;
exception
when others then
dbms_output.put_line('Nothing');
END;
/

exec waiters__list ('Ethiop');



---Second Task (Report tips)----------------------
create or replace procedure w_tip
is
cursor tipper1 is select waiters.waiter_id, sum(orders.tip) as tip_amount from waiters,orders
where waiters.waiter_id=orders.waiter_id
group by waiters.waiter_id;
begin
for t1 in tipper1
loop
dbms_output.put_line('WaiterID is '|| t1.waiter_id    ||  ' TotalTIP of waiter ' || t1.tip_amount);
End loop;
Exception
when no_data_found then
dbms_output.put_line('No Such Data Found');
END;
/

----Tips, waiters names and waiters id will be obtained based on this exec command
Exec w_tip;

------ Third Task(Report tips by state)-------------------

--- To know the tips individually by state this procedure is used based on the orders and restaurant tables
create or replace procedure wtip_by_state
is
cursor tipper2 is select restaurant.state, sum(orders.tip) as total from orders,restaurant
where orders.restaurant_id=restaurant.restaurant_id
group by restaurant.state;
begin
for t2 in tipper2
loop
dbms_output.put_line('StateNAME is ' || t2.state || ' Amount is ' || t2.total);
END loop;
Exception
when no_data_found then
dbms_output.put_line('No Such Data Found');
END;

/

---- By the exec command the tips based on different states are obtained
Exec wtip_by_state;

-------------------Member 3 task------------------------------

--- First task  (Initial)--------------------

create or replace procedure show_restaurant_inventory(res_name varchar)
as
cursor c1 is select menu_item_id,a.Restaurant_ID,menu_item_name,quantity from restaurant_inventory a ,restaurant b where a.Restaurant_ID=b.restaurant_ID and restaurant_name =res_name;
begin
dbms_output.put_line('---------------  Initial Inventory for Ethiop restaurant -------------------');
dbms_output.put_line('The information for Restaurant ' || res_name ||' is: ');
for r in c1 loop

dbms_output.put_line('  Menu Item Id is: '||r.menu_item_id);
dbms_output.put_line('  Restaurant ID is: '|| r.Restaurant_id);
dbms_output.put_line('  Menu_item name is: '||r.menu_item_name);
dbms_output.put_line('  Quantity is: '||r.quantity);

end loop;

end;
/

exec show_restaurant_inventory('Ethiop');

-----------Updated (Final Inventory for Ethiop restaurant)------------------

create or replace procedure manage_restaurant_inventory(res_name varchar,menu_name varchar, reduce_inventory int)
as
--cursor c1 is select menu_item_id,a.Restaurant_ID,menu_item_name,quantity from restaurant_inventory a ,restaurant b where a.Restaurant_ID=b.restaurant_ID and restaurant_name =res_name;
r_id int;
qty int;
begin
dbms_output.put_line(---------------  Final Inventory for Ethiop restaurant -------------------');
select max(a.Restaurant_ID) as res_id into r_id from restaurant_inventory a ,restaurant b where a.Restaurant_ID=b.restaurant_ID and restaurant_name =res_name;
select quantity into qty from restaurant_inventory where Restaurant_ID=r_id and menu_item_name=menu_name;
dbms_output.put_line('The original invetory for '||menu_name||' in restaurant '|| res_name ||' is: '||qty);
if (qty - reduce_inventory)>0 then
update restaurant_inventory set quantity = quantity - reduce_inventory where Restaurant_ID=r_id and menu_item_name=menu_name;
select quantity into qty from restaurant_inventory where Restaurant_ID=r_id and menu_item_name=menu_name;
dbms_output.put_line('The updated invetory for '||menu_name||' in restaurant ' || res_name ||' is: '||qty);
else
dbms_output.put_line('INVENTORY IS LOW');
end if;
end;
/

exec manage_restaurant_inventory('Taj Mahal','Rice',25);
exec manage_restaurant_inventory('Selasie','Meat_Chunks',50);
exec manage_restaurant_inventory('Bull Roast','Fillet_Mignon',2); 

exec manage_restaurant_inventory('Bull Roast','Fillet_Mignon',2);

exec manage_restaurant_inventory('Ethiop','Meat_Chunks',30);

exec manage_restaurant_inventory('Ethiop','Meat_Chunks',30);

exec manage_restaurant_inventory('Ethiop','Legume_Stew',20);


 --------------------task 3 (Report menu items) -----------------------------

create or replace procedure report_menu_items
as
cursor c1 is select menu_item_id,cuisine_type_id,menu_item_name,price from menu_items;
begin


dbms_output.put_line('===================Reporting all menu items==================');
for r in c1 loop

dbms_output.put_line('Menu Item id: '||r.menu_item_id|| ', Cuisine type id :'||r.cuisine_type_id||', Item name: '||r.menu_item_name||', and Price: '||r.price);
end loop;
end;
/

exec report_menu_items;

--------------------------Member 4-----------------


-------First task (most populars)--------------- 


create or replace procedure MOST_POPULAR_MENU_ITEM_ORDERED
is
cursor c1 is select m_item.menu_item_name,c_type.cuisine_name,count(ord.menu_item_id) as item_count from orders ord INNER JOIN menu_items m_item ON m_item.menu_item_id=ord.menu_item_id
INNER JOIN cuisinetype c_type ON m_item.cuisine_type_id =c_type.cuisine_type_id
group by menu_item_name,cuisine_name;
M_ITEM_NAME varchar(30);
C_CUISINE_NAME varchar(30);
POPULAR number;
begin
dbms_output.put_line('-------------------------- REPORT BY MEMBER 4 ---------------');
open c1;
loop
    fetch c1 into M_ITEM_NAME,C_CUISINE_NAME, POPULAR;
       dbms_output.put_line('menu_item_name=   ' ||M_ITEM_NAME ||' '||'cuisine_name=   '||C_CUISINE_NAME||' '|| 'item_count=   '||POPULAR);
     exit when c1%notfound;
end loop;
end;
/
commit;
/

exec MOST_POPULAR_MENU_ITEM_ORDERED;


---------Second Task (top 3 restaurants of each state)--------------------

create or replace procedure TOP_THREE_RESTAURANTS
is
cursor c1 is select restaurant.restaurant_name,restaurant.state,sum(orders.amount_paid) order_sum from restaurant, orders
where restaurant.restaurant_id = orders.restaurant_id
group by restaurant.state,restaurant.restaurant_name order by order_sum desc;
rest_NAME varchar(50);
resstate_NAME varchar(50);
amount float;
begin
open c1;
loop
    fetch c1 into rest_NAME,resstate_NAME, amount;
       dbms_output.put_line('restaurant_name=   ' ||rest_NAME ||' '||'state=   '||resstate_NAME||' '|| 'order_sum=   '||amount);
     exit when c1%notfound;
end loop;
end;
/
commit;
/
exec TOP_THREE_RESTAURANTS;


-------------------------Member 5----------------------------------------

-- report of Most(top 3) and least(bottom 3) money spent
create or replace procedure report_Most_least_money
is
cursor c1 is select c.name,o.amount_paid from customer c join orders o on o.customer_ID=c.customer_ID 
    where o.amount_paid >=(select max(o.amount_paid) from orders o
    where o.amount_paid < (select max(o.amount_paid) from orders o
    where o.amount_paid < (select max(o.amount_paid) from orders o))) and rownum<=3  
    order by o.amount_paid desc ;

cursor c2 is select c.name,o.amount_paid from customer c join orders o on o.customer_ID=c.customer_ID 
    where o.amount_paid >=(select max(o.amount_paid) from orders o
    where o.amount_paid < (select max(o.amount_paid) from orders o
    where o.amount_paid < (select max(o.amount_paid) from orders o))) and rownum<=3  
    order by o.amount_paid asc ;
 
c_name varchar(30);
c_amount_paid number;
cs_name varchar(30);
cs_amount_paid number;

begin
open c1;
open c2;
dbms_output.put_line('-------------------------- REPORTS BY MEMBER 5 ---------------');
dbms_output.put_line('Customers who Spent the most:');
loop 
    fetch c1 into c_name,c_amount_paid;
    exit when c1%notfound;
    
    dbms_output.put_line(c_name || ' '||c_amount_paid||'');
   
end loop;
dbms_output.put_line('Customers who Spent the Least:');
loop
 fetch c2 into cs_name,cs_amount_paid;
    exit when c2%notfound;
    
    dbms_output.put_line(cs_name || ' '||cs_amount_paid||'');
end loop;

end;
/


exec report_Most_least_money;

-- States of generous customers. 


create or replace procedure report_state_of_genrous_cs
is
cursor c3 is select c.c_state ,sum(o.tip) as amount 
from customer c join orders o on o.customer_ID=c.customer_ID 
 group by c.c_state order by sum(o.tip) desc;
 
c_state varchar(30);
c_amount_paid number;

begin
open c3;
dbms_output.put_line('-------------------------- REPORTS BY MEMBER 5 ---------------');
dbms_output.put_line('States of generous customers:');
loop 
    fetch c3 into c_state,c_amount_paid;
    exit when c3%notfound;
    
    dbms_output.put_line(c_state || ' '||c_amount_paid||'');
   
end loop;

end;
/

exec report_state_of_genrous_cs;



