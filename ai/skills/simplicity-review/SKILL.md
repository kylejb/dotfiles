---
name: simplicity-review
description: Review a design or change for over-engineering — paths through the core flow, mechanisms doing the same job, a home for the next requirement, and whether a change replaced or stacked. Use before merging a design or significant change, after a redesign or performance fix, at the end of a time box, or when someone asks whether code is over-engineered or too complex.
metadata:
  version: "1"
  updated: "2026-11-03"
---

Judge the code the way a reviewer meets it: a **cold read**, with no design doc and no author to ask. The question is not "is each piece reasonable?" (each usually is) but "is the whole as simple as the problem allows, and easy to change?"

Bugs belong to `code-review`; style belongs to the linter. This skill is about shape.

## Steps

1. **Pin the core flow.** Name the unit of work (a row, a request, a file) and the stages it passes through from input to output. Done when you can state both in one sentence.
2. **Run every check below** against the design or the diff. For each, record a finding with evidence (file:line, a count) or "clear". Done when all seven have an entry.
3. **Name the simpler shape** for each finding: what replaces it and what it deletes. If the complexity earns its place, say what it buys, measured where possible. Done when every finding has one or the other.
4. **Report** findings ranked by how hard a cold reader would trip on them, under 400 words. Edit only when asked, or when a workflow such as `timed-exercise` calls this review.

## Checks

- **Paths.** Count the ways a unit of work can move through the core flow: branches on mode, concurrency or flags. The target is one. A branch on the data is fine when both sides become the same thing (a cache hit and a fresh computation both yield the same result type). An "off" mode is a null component (a no-op client that returns at once); concurrency is a parameter (pool size), never a branch. A sequential copy of the flow kept as a test oracle is a second path: test against literal expected values with a pool of one instead.
- **One job, one mechanism.** List the jobs the code does (dedup, caching, retry, ordering, owning state) and what does each. Two mechanisms on one job is one too many: keep the one that also covers the other's case.
- **Next requirement.** Name two plausible next requirements from the domain, such as a filter at a later stage or a second output. Each needs an obvious home that touches one place. When one has no home, the data or the stages are shaped wrong.
- **Whole data.** The unit of work stays whole until a stage needs less. Folding it early into counts or sets to save memory is a trade-off to state, and it is the usual reason the next requirement has no home.
- **Replaced or stacked.** For each change, list what it made redundant and confirm that is gone. A change that leaves the old mechanism running beside the new one is stacked, and stacked changes are where over-engineering comes from.
- **Surface.** Count flags, config keys, recorded decisions and pages of docs, and set them against the size of the task. Cut first what neither the brief nor the reviewer's guide asks for; what they ask for stays, built as simply as it can be.
- **Cold read.** Run it as the reviewer would: on the inputs exactly as delivered (the original files and formats), and on one bad input of each kind (a malformed line, a missing file, a broken config). Every run ends in the right output or a one-line error, never a traceback or a silently empty result. Every printed number, log line and flag must make sense where the reader meets it, for the flags of that run, without the design doc. A number that looks broken until explained (a counter stuck at zero) is a finding.
