# Notes: Implicit vs Explicit Joins

**Core idea:** `FROM a, b` IS a cross join — not an alternative to one. Old syntax, same operation.

**Why WHERE can act like ON:** WHERE is just a filter applied after the cross join. Filtering on `a.key = b.key` produces the same rows as `JOIN ... ON a.key = b.key`, but it's not a rewrite — it's coincidental equivalence from filtering a cross product.

**Why explicit JOIN is preferred:**
- Forgetting WHERE in comma syntax = silent full cross join (bug risk)
- Explicit syntax separates "how tables relate" from "how to filter results"
- Only explicit syntax supports LEFT/RIGHT/FULL OUTER joins

**Aliasing is independent of join style** — you alias tables the same way regardless of implicit or explicit syntax. Don't conflate the two.
