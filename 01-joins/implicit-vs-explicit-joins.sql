-- ============================================
-- Topic: Implicit (comma) joins vs explicit JOIN...ON
-- ============================================

-- IMPLICIT JOIN: comma-separated tables in FROM, condition in WHERE.
-- This is functionally a CROSS JOIN filtered by WHERE.
select dm.*, d.dept_name
from dept_manager dm, (select dept_no, dept_name from departments) d
where dm.dept_no = d.dept_no;

-- EXPLICIT JOIN: same result, clearer separation of join logic (ON) vs filter logic (WHERE)
select dm.*, d.dept_name
from dept_manager dm
join (select dept_no, dept_name from departments) d
  on dm.dept_no = d.dept_no;

-- Note: comma-join syntax can ONLY express inner joins.
-- There is no comma-syntax equivalent for LEFT/RIGHT/FULL OUTER JOIN.
-- That's the main reason explicit syntax is standard in modern SQL.
