# Notes: Subqueries

**IN vs JOIN:** deciding factor is whether the output needs columns from the other table.
- Only filtering → IN (or EXISTS). Simpler, avoids row-duplication risk if the subquery table has repeat keys.
- Need combined columns in output → JOIN.
- Optimizers often rewrite IN into a semi-join anyway — choice is about intent/readability more than raw speed.

**Derived table (subquery in FROM/JOIN) vs scalar subquery (in SELECT):**
- Derived table = a real second data source, joined per row via a key. Alias just names it.
- Scalar subquery in SELECT = independent, returns one value, repeats on every row (if non-correlated).
- Alias doesn't "create" the second data source — JOIN does. Alias is just the reference name.

**Correlated vs non-correlated:**
- Non-correlated: subquery has no reference to the outer query. Runs once.
- Correlated: subquery references an outer column (e.g. `e.emp_no`). Re-evaluated per row — similar effect to a join, but row-by-row.
