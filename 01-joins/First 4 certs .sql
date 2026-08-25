-- This script demonstrates the basic usage of SQL joins.
-- includes how the structure of sql and what the common rules are

select customerlastname, customerfirstname, ordernum, orddate 
from customers 
join orders
on customers.customerid = orders.customerid
order by customerlastname;

------------------------------------------------------------------------------

-- Now this the start of the sql joins
-- I learn how to use the inner join, left join, right join 
-- Understand and able to use self-joins and cross joins
-- Understand and be ale to utalize the union and union all statements

-- Joins are used to join 2 or more collums together in a db
--Inner join is used to return rows when there is a match in both tables
--Sometimes we use the use; function to specify the database we are using, but in this case we are not using it because we are already in the database we want to use

use bookstore 
select orderinfo.itemid, customer.customername 
from orderinfo 
inner join customer in on orderinfo.customerid = customer.customerid;

--Alias are used to give a table or a column a temporary name. This is often used to make column names more readable.
select o.itemid, c.customername
from orderinfo as o 
inner join customer as c 
ON o.customerid = c.customerid;

--Left join is used to return all rows from the left table, and the matched rows from the right table. If there is no match, the result is NULL on the right side.
select i.booktitle, a.authorname
from item as i 
left join author as a 
on i.authorid = a.authorid
order by i.booktitle;

--right join is used to return all rows from the right table, and the matched rows from the left table. If there is no match, the result is NULL on the left side.
select i.booktitle, a.authorname
from item as i
right join author as a
on i.authorid = a.authorid
order by i.booktitle;

--Self join is used to join a table to itself as if the table were two tables, temporarily renaming at least one table in the SQL statement.
select e.firstname as EmployeeName, em.firstname as ManagerName
from employees as e
inner join employees as em
on em.employeeid = e.managerid; ALTER

--Cross join is used to return the Cartesian product of the two tables involved in the join. This means that it will return all possible combinations of rows from both tables.
select * 
from item 
cross join author;

--Union combines the result set of two or more SELECT statements (only distinct values)
--it wont return duplicate values, and the number of columns and their data types must be the same in all SELECT statements.
select city from customers
union select city from supplier
order BY city;

--Union all returns all results in result set even if there are duplicates. The number of columns and their data types must be the same in all SELECT statements.
select customername from customer
union 
select firstname from employees
order by customername;

--Minipulating data w sql
--Primary keys uniquely identify each record in a database table. 
--Foreign keys are used to link two tables together. 

--Fimilarise yourself with the different rows. 
-- Ask yourself: how many feilds in a table 
-- what data type is each feild and the max size of each feild
-- which fileds have constraints and if so what are they
-- what is the order of the feilds in the table

insert into product -- tells DBMAS where to insert the data
values  (377,'Outdoor 2 - Gallon CollerPack', 'ny10', 20.20, 2020-05-15); -- values tells dbms a list of values follows if the field has 5 values the field will have 5 values in the same order as the feilds in the table.

 int -- values without quotes 
 char -- values, with quotes
 dec -- values without quotes

--Date values are read in the format YYYY-MM-DD. 

--------------------------------------------------------------------------------

--Update Command = everytime data changes it must get updated e.g. employee changes address, phone number, email address etc. 
-- e.g. shipping costs rise by 7%. How would you overwrite the old shipping cost with the new shipping cost?
update product
set prodCost = (prodCost * 1.07);

--Delete command & Drop command = delete command is used to delete a record from a table. Drop command is used to delete a table from the database.

-- To ensure that data is deleted safely, it is a good practice to have backups. 


--------------------------------------------------------------------------------

select lastname, firstname, orderid
from employees 
inner join oders
on employees.employeeid = orders.employeeid
order by lastname, firstname;


--After changes 

select lastname, firstname, ordes.orderid, products.productid, quantity, price %
from employees
inner join orders
on employees.employeeid = orders.employeeid
inner join orderdetails 
on orders.orderid = orderdetails.orderid
inner join products
on orderdetails.productid = products.productid
order by lastname, firstname; 


--Aggregate functions are used to perform calculations on multiple values and return a single value. Common aggregate functions include COUNT, SUM, AVG, MIN, and MAX.
sum()
count()
avg()
min()
Max()

-- Specify which fields the aggregate function should be applied to within paretheses. 
-- Use group by = collapse rows, metrics 
-- Use order by = sort rows (alphabetically, numerically), metric
-- It is key to use group by first. 
-- Limit = limit the number of rows returned in the result set.
-- Having = filter after aggregate functions have been applied. 




