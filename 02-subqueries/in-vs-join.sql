-- ============================================
-- Topic: IN (subquery) vs JOIN
-- Deciding factor: do I need columns from the OTHER table in my output?
-- ============================================

-- IN: only filtering dept_emp, no columns from departments needed in output
select * from dept_emp
where dept_no in (select dept_no from departments where dept_name = 'Customer Service');

-- Equivalent using JOIN (works, but pulls in departments just to filter --
-- unnecessary since dept_name isn't needed in the SELECT list)
select de.* from dept_emp de
join departments d on de.dept_no = d.dept_no
where d.dept_name = 'Customer Service';

-- JOIN is the right call when you DO need columns from both tables:
select dm.*, d.dept_name
from dept_manager dm
join departments d on dm.dept_no = d.dept_no;
