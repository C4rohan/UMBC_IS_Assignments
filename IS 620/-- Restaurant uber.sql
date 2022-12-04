-- Restaurant table

create table restaurant(rID number(5) primary key, rName varchar(15),StrAddress varchar2(15),zip number(5));

--Driver table

create table driver(dID number(5) primary key, dFname varchar(10),dLname varchar(10));

--Customer Table

create table customers(cID number(5)primary key, dFname varchar(10),cLname varchar(10), StrAddress varchar2(15),zip number(5));

--Order Table

create table orders(oID number(5) primary key, rID number(5) ,cID number(5), dID number(5), foreign key(rID) references restaurant(rID),foreign key (cID) references customers(cID), foreign key (dID) references  driver(dID), amount number(5)); 


--2a.
insert all into restaurant(rID,rName,StrAddress,zip) values(1000,'Good Food', ' 100 Main St', 21250)
into restaurant(rID,rName,StrAddress,zip) values(2000,'Happy Belly','101 Main St',21043)
into restaurant(rID,rName,StrAddress,zip) values(3000,'Little Italy','200 Plum St',21250)
into restaurant(rID,rName,StrAddress,zip) values(4000,'American','210 Plum St',21250)
select * from dual;

--2b.

insert all into driver(dID,dFName,dLname) values(100,'Jack',' Quick')
into driver(dID,dFName,dLname) values(101,'Joe', 'Tracy')
into driver(dID,dFName,dLname) values(102,'Marie', 'Mac')
into driver(dID,dFName,dLname) values(103,'Pam', 'Bam')
into driver(dID,dFName,dLname) values(105,'Kumar', 'Raut')
select * from dual;

--2c. 
insert all into customers(cID,dFname,cLname,StrAddress,zip) values(500, 'Mary', ' Slim', '10 Main St', 21043)
into customers(cID,dFname,cLname,StrAddress,zip) values(510, 'Jude', 'Bigbell ' , '20 Plenty St',21042)
into customers(cID,dFname,cLname,StrAddress,zip) values(520, 'Pamela', ' Reddy' , '20 Main St',21043)
into customers(cID,dFname,cLname,StrAddress,zip) values(530, 'Ann', ' Phat', '101 Main St',21250)
select * from dual;

--2d.

Insert into orders(oID,amount,rID,cID,dID) select 700,72.80,r.rID,c.cID,d.dID from restaurant r, customers c, driver d where r.rID=1000 and c.dFname='Mary' and d.dFname='Jack'; 
Insert into orders(oID,amount,rID,cID,dID) select 701,99,r.rID,c.cID,d.dID from restaurant r, customers c, driver d where r.rID=1000 and c.dFname='Jude' and d.dFname='Marie'; 
Insert into orders(oID,amount,rID,cID,dID) select 702,150.60,r.rID,c.cID,d.dID from restaurant r, customers c, driver d where r.rID=1000 and c.dFname='Ann' and d.dFname='Pam'; 
Insert into orders(oID,amount,rID,cID,dID) select 703,80,r.rID,c.cID,d.dID from restaurant r, customers c, driver d where r.rID=2000 and c.dFname='Ann' and d.dFname='Kumar'; 
Insert into orders(oID,amount,rID,cID,dID) select 704,90,r.rID,c.cID,d.dID from restaurant r, customers c, driver d where r.rID=3000 and c.dFname='Ann' and d.dFname='Marie';
Insert into orders(oID,amount,rID,cID,dID) select 705,100,r.rID,c.cID,d.dID from restaurant r, customers c, driver d where r.rID=4000 and c.dFname='Pamela' and d.dFname='Joe'; 
Insert into orders(oID,amount,rID,cID,dID) select 706,134,r.rID,c.cID,d.dID from restaurant r, customers c, driver d where r.rID=4000 and c.dFname='Jude' and d.dFname='Jack'; 
Insert into orders(oID,amount,rID,cID,dID) select 707,66.20,r.rID,c.cID,d.dID from restaurant r, customers c, driver d where r.rID=4000 and c.dFname='Ann' and d.dFname='Jack'; 


-- 2.e Tips table
create sequence seq_pid start with 1 increment by 1 nocache nocycle;  --sequence created for pid

create table tips as select seq_pid.nextval as tpid ,o.oID as oID ,o.dID as dID ,(o.amount*20)/100 as tip from orders o;

--Problem 3
--Q1
select rname from restaurant  where zip = '21250';
--Q2
select rName from restaurant r join orders o on r.rID = o.rID join customers c on c.cID = o.cID where c.dFname = 'Jude';
--Q3
select d.dFname as dFname ,d.dLname as Lname ,sum(tip) as tip from driver d join tips t on d.dID = t.dID group by d.dFname, d.dLname order by tip desc;

