-- ============================================
-- Topic: Derived table (subquery in JOIN) vs scalar subquery (in SELECT list)
-- Three data sources feeding one query -- worth being able to spot each one.
-- ============================================

SELECT e.emp_no, e.first_name, e.last_name,
       a.emp_avg_salary,                                  -- source 2: per-employee avg, joined in
       (SELECT ROUND(AVG(salary), 2) FROM salaries) avg_salary  -- source 3: company-wide avg, NOT joined
from employees e
join (SELECT emp_no, ROUND(AVG(salary), 2) AS emp_avg_salary   -- source 2 defined here
      from salaries
      group by emp_no
      order by emp_no) a
on e.emp_no = a.emp_no
order by e.emp_no;

-- The scalar subquery above is NON-CORRELATED: it doesn't reference e.emp_no,
-- so it computes once and repeats the same value on every row.

-- A CORRELATED version, for comparison (recomputes per row):
SELECT e.emp_no, e.first_name,
       (SELECT AVG(s.salary) FROM salaries s WHERE s.emp_no = e.emp_no) AS my_avg_salary
from employees e
order by e.emp_no;
