# SQL Learning Log

A running record of questions I've worked through, what I assumed going in, and what I actually learned. Purpose: track progression and give future-me a reference when the same confusion resurfaces.

---

## Entry 1 — Implicit joins: is WHERE acting like ON?

**Query I was looking at:**
```sql
select dm.*, d.dept_name
from dept_manager dm, (select dept_no, dept_name from departments) d
where dm.dept_no = d.dept_no;
```

**My question:** Is the WHERE clause being turned into an explicit join? Does it act like ON?

**What I learned:**
- `FROM a, b` (comma-separated) is old-style **implicit join syntax** — it produces a cross join (every row of `a` paired with every row of `b`).
- `WHERE dm.dept_no = d.dept_no` then filters that cross join down.
- The *effect* is identical to `JOIN ... ON`, but WHERE isn't being "rewritten" into ON by the engine — it's just an ordinary filter applied after a cross join that happens to produce the same result as an inner join.
- Key limitation: comma-join + WHERE can only express **inner joins** — no LEFT/RIGHT/FULL OUTER equivalent exists in this syntax.

---

## Entry 2 — Why do implicit joins get used at all? Why not just use CROSS JOIN?

**My assumption going in:** I treated implicit joins and cross joins as two different alternative approaches.

**Correction:** They're not alternatives — `FROM a, b` **is** a cross join, just written in older syntax. `FROM a, b WHERE a.id = b.id` and `FROM a CROSS JOIN b WHERE a.id = b.id` do the exact same thing.

**Why the old syntax persists:**
- Predates the ANSI SQL-92 `JOIN` keyword becoming standard.
- Some people/legacy code just never switched.
- Some courses/sample databases use it to teach the underlying concept.

**Why explicit `JOIN ... ON` is preferred today:**
- Separates join logic (`ON`) from filter logic (`WHERE`) — much clearer with 3+ tables.
- Forgetting `WHERE` in comma-syntax silently gives a full cross join with no error — a common bug source. Explicit syntax makes CROSS JOIN a deliberate choice.
- Comma syntax has no equivalent for LEFT/RIGHT/FULL OUTER joins, so explicit syntax is required eventually anyway.

---

## Entry 3 — Aliasing vs. join style (a confusion I had)

**My assumption:** I initially thought using `AS`/aliases (`dm`, `d`) was somehow tied to implicit joins — like "implicit join = join + alias combined."

**Correction:** Aliasing is completely **independent** of join style. You alias tables the same way whether you write:
```sql
from dept_manager dm, departments d          -- implicit
from dept_manager dm join departments d on...  -- explicit
```
An alias is just a nickname for a table (or subquery) — required by SQL syntax when using a derived table (a subquery in `FROM`), but not otherwise connected to implicit vs explicit join mechanics.

**Takeaway:** Implicit/explicit join style, aliasing, and subqueries-as-tables are three separate, independently combinable concepts — I was merging them into one idea.

---

## Entry 4 — When to use IN vs JOIN

**Queries compared:**
```sql
-- Option A: IN
select * from dept_emp
where dept_no in (select dept_no from departments where dept_name = 'Customer Service');

-- Option B: JOIN
select dm.*, d.dept_name from dept_manager dm, (select dept_no, dept_name from departments) d
where dm.dept_no = d.dept_no;
```

**My question:** Why use IN instead of a join?

**What I learned — the deciding factor is: do I need columns from the other table in my output?**
- If I only need to **filter** one table using values from another, and don't need to display any of that other table's columns → `IN` (or `EXISTS`) is simpler and clearer.
- If I need to **combine and display** columns from both tables → I need a join.
- Bonus reasons to prefer `IN` when applicable: avoids accidental row duplication if the subquery table has repeated keys; reads as clear filtering intent rather than implying I want both tables' data.
- Modern optimizers often rewrite `IN (subquery)` into a semi-join internally, so performance is usually comparable — the real distinction is about **intent and output shape**, not speed.

---

## Entry 5 — Subquery in JOIN vs. subquery in SELECT (correlated vs non-correlated)

**Query I was looking at:**
```sql
SELECT e.emp_no, e.first_name, e.last_name, a.emp_avg_salary,
       (SELECT ROUND(AVG(salary), 2) FROM salaries) avg_salary
from employees e 
join (SELECT emp_no, ROUND(AVG(salary), 2) AS emp_avg_salary
      from salaries
      group by emp_no
      order by emp_no) a 
on e.emp_no = a.emp_no 
order by e.emp_no;
```

**My question:** Does the alias after the subquery (in JOIN) allow for a "second source of data"?

**What I learned:**
- Two different subquery types were stacked in this one query:
  1. **Derived table in JOIN** (`... join (...) a on ...`) — a genuine second data source, joined per-employee. The alias `a` just names it so I can reference `a.emp_avg_salary`.
  2. **Scalar subquery in SELECT** (`(SELECT AVG(salary) FROM salaries) avg_salary`) — a *third*, independent data source, but NOT joined. It computes one single value (company-wide average) and repeats it on every row.
- The alias itself isn't what "brings in" the second data source — the `JOIN` does that. The alias is just the nickname.
- **Correlated vs non-correlated subqueries:** the scalar subquery here was non-correlated (no reference to the outer query, same result every row). A correlated version would reference `e.emp_no` inside it and recompute per row — closer in effect to a join, but evaluated row-by-row.

---

## Entry 6 — Self-assessment: where am I on the SQL learning curve?

**Assessment (as of this log):** Beginner solidly established, actively transitioning into intermediate.

**Evidence of intermediate movement:**
- Correctly reasoned that WHERE and ON produce equivalent *effects* despite being structurally different.
- Asked *why* a design choice (implicit joins) persists rather than just accepting it.
- Distinguished when to use `IN` vs `JOIN` based on **output shape needed**, not just syntax memorization.
- Spotted that a single query contained two structurally different subquery patterns and asked precise questions about the mechanism.

**Gaps to close next (not yet covered):** window functions, CTEs, correlated subqueries (own dedicated practice), query execution order, NULL handling in outer joins, indexes/EXPLAIN plans.

---

## Next topics queued up
- [ ] LEFT JOIN + NULL handling
- [ ] Correlated subqueries (dedicated practice, not just recognition)
- [ ] CTEs (`WITH` clause) — rewrite a nested query using one
- [ ] Query execution order deep dive
- [ ] Window functions (`ROW_NUMBER`, `RANK`, `LAG`/`LEAD`)
