-- inserting values
exec insertcustomerID('Cust1','billu@umbc.edu','5003 westland','Baltimore','MD',21045,1234123412341234)
exec insertcustomerID('Cust11','Cust11@umbc.edu','Maiden Choice','Baltimore','MD',21045,0987098709870987)
exec insertcustomerID('Cust3','Cust3@umbc.edu','Back Market','Baltimore','MD',21046,0987098709870987)
exec insertcustomerID('Cust111','Cust111@umbc.edu','Eldon Street','Baltimore','MD',21045,1234123412341234)
exec insertcustomerID('CustNY1','CustNY1@umbc.edu','Gopal Marg','New York','NY',10045,1234123412341037)
exec insertcustomerID('CustNY2','CustNY2@umbc.edu','Brown Street','New York','NY',10045,1234123412347090)
exec insertcustomerID('CustNY3','CustNY3@umbc.edu','Malibu Street','New York','NY',10045,1234123412341000)
exec insertcustomerID('CustPA1','CustPA1@umbc.edu','Marc Street','Philedelphia','PA',16822,1234123412341234)
exec insertcustomerID('CustPA2','CustPA2@umbc.edu','Belwood Street','Philedelphia','PA',16822,1234123412341234)
exec insertcustomerID('CustPA3','CustPA3@umbc.edu','Gabbar Street','Philedelphia','PA',16822,1234123412341234)
exec insertcustomerID('CustPA4','CustPA4@umbc.edu','Red Label Street','Philedelphia','PA',16822,1234123412341037)
exec insertcustomerID('CustPA5','CustPA5@umbc.edu','Goa Street','Philedelphia','PA',16822,12345635672123456)
exec insertcustomerID('CustPA6','CustPA6@umbc.edu','Vile Parle Street','Philedelphia','PA',16822,9876545678654324)

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
dbms_output.put_line('-------------------------- REPORTS BY MEMBER 5 ---------------')
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


set serveroutput on;
exec report_Most_least_money


-- States of generous customers. 

create or replace procedure report_state_of_genrous_cs
is
cursor c3 is select c.c_state ,sum(o.amount_paid) as amount 
from customer c join orders o on o.customer_ID=c.customer_ID 
 group by c.c_state order by sum(o.amount_paid) desc;
 
c_state varchar(30);
c_amount_paid number;

begin
open c3;
dbms_output.put_line('-------------------------- REPORTS BY MEMBER 5 ---------------')
dbms_output.put_line('States of generous customers:');
loop 
    fetch c3 into c_state,c_amount_paid;
    exit when c3%notfound;
    
    dbms_output.put_line(c_state || ' '||c_amount_paid||'');
   
end loop;

end;
/

exec report_state_of_genrous_cs
