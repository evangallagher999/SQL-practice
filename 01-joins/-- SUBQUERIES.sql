-- SUBQUERIES 
-- Different data set than the first 4 certs, but the same concepts apply

--WHERE CLAUSE 
-- Retrieves list of all employees that are not managers.
select * from employees
where emp_no NOT IN(SELECT emp_no from dept_manager);

-- 2.1 retrieves all colums in sales table for customers over 60 Years old 
select customer_id, count(*) From sales 
group by customer_id
order by count(*) desc

-- Retrieve list of all managers employed between 01/01/1999 and 01/01/1995
select * from dept_manager
where emp_no IN (SELECT emp_no from employees where hire_date between '1995-01-01' and '1999-01-01');

-----------------------------------------------------------------------------------------------------------

--FROM clause 
-- retrieve list of all customers living in the south region
select * 
from (select * from customers where region = 'south')a; -- this is a source of data

-- list of managers, firstnames, lastnames and their department
select dm.*, e.first_name, e.last_name, d.dept_name
from dept_manager dm, employees e, (select dept_no, dept_name from departments) d
where dm.emp_no = e.emp_no and dm.dept_no = d.dept_no;

------------------------------------------------------------------------------------------------------------

--SELECT clause
-- Takes all colums 

select first_name, last_name, (select round(avg(salary),2) avg_salary
from employees; 

-- 4.1 list of customer_id, product_id, order_line, name 
-- Using sales and customer tables 
select customer_id, product_id, order_line, (select customer_name from customers c where s.customer_id = c.customer_id) as customer_name
from sales s
order by customer_id;


------------------------------------------------------------------------------------------------------------

--SUBQUERIES EX1 
-- retireve list of all employees with salary over 120000 in Finance or human resources department
select emp_no, round(avg(salary),2) as avg_salary from salaries
where salary > 120000 and emp_no IN (select emp_no from dept_emp where dept_no IN (select dept_no from departments where dept_name = 'Finance' or dept_name = 'Human Resources'))
group by emp_no
order by avg_salary desc;

-- alternatively for the query select 
in (select emp_no from dept_emp where dept_no in ('d002', 'd003') -- in an earlier query we find out that the dept_no for Finance is d002 and Human Resources is d003, so we can use this instead of the subquery to get the same result.


------------------------------------------------------------------------------------------------------------

--SUBQUERIES EX2
select e.emp_no, e.first_name, e.last_name, a.emp_avg_salary, (select round(avg(salary),2) from salaries) avg_salary 
from employees e 
join (select e.emp_no, round(avg(salary),2)as emp_avg_salary 
from salaries 
group by emp_no 
order by emp_no) a 
on e.emp_no = a.emp_no 
order by emp_no; 



------------------------------------------------------------------------------------------------------------

--SUBQUERIES EX3


-- Exercise 7.1: Retrieve the salary that occured most
-- Returns a list of the count of salaries

select a.salary from (SELECT salary, COUNT(*) --source of data
FROM salaries
GROUP BY salary
order by Count(*), salary desc
limit 1)a;  --inital work / ideas

-- Exercise 7.2: Find the average salary excluding the highest and
-- the lowest salaries
-- Returns the average salary of all employees

SELECT ROUND(AVG(salary), 2) avg_salary
FROM salaries  --inital work / ideas

SELECT ROUND(AVG(salary), 2) avg_salary
FROM salaries
where salary not in (
	(select min(salary) from salaries), 
	(select max(salary) from salaries)
);

-- Exercise 7.3: Retrieve a list of customers id, name that have
-- bought the most from the store
-- Returns a list of customer counts

SELECT customer_id, COUNT(*) AS cust_count
FROM sales
GROUP BY customer_id
ORDER BY cust_count DESC; --inital work / ideas


SELECT c.customer_id, c.customer_name, a.cust_count
FROM customers c, 
		(select customer_id, count(*) as cust_count
		from sales
		group by customer_id
		order by cust_count desc) as a --second source of data
	where c.customer_id = a.customer_id
order by a.cust_count desc
limit 5;

-- Exercise 7.4: Retrieve a list of the customer name and segment
-- of those customers that bought the most from the store and
-- had the highest total sales
-- Returns a list of customer counts and total sales
select * from sales;

SELECT customer_id, COUNT(*) AS cust_count, SUM(sales) total_sales
FROM sales
GROUP BY customer_id
ORDER BY total_sales DESC, cust_count DESC;--inital work / ideas


select c.customer_id, c.customer_name, c.segment, a.cust_count, a.total_sales
from customers c, 
		(SELECT customer_id, COUNT(*) AS cust_count, SUM(sales) total_sales
		FROM sales
		GROUP BY customer_id
		ORDER BY total_sales DESC, cust_count DESC) as a
	where c.customer_id = a.customer_id 
order by a.total_sales desc, a.cust_count desc
limit 5;

