---
name: timed-exercise
description: Run a time-boxed build — interview take-home, live coding round, hackathon — from brief to submission, keeping the design simple enough to survive a cold read. Use when the user mentions a take-home, an interview exercise or a deadline measured in hours, or asks whether a submission meets the bar.
metadata:
  version: "2"
  updated: "2026-11-09"
---

A reviewer reads a time-boxed submission **cold** and judges whether its core flow is easy to follow and change. Simplicity is what they can see; a clever late optimisation that bends the shape costs more than it earns.

## Steps

1. **Set the target.** Save the brief and any guide to `.agent/guidance/` and confirm the list with the user. Write down the start, the end and the **freeze point**, at 75% of the box. Done when the user has confirmed the guidance and all three times are in the plan.
2. **Measure the input** before choosing the unit of work: counts, distinct keys, how they cluster, sizes. A few minutes of `awk`, `sort | uniq -c` or a notebook. Agree the design with the user and save it to `.agent/guidance/` with the commit it was agreed at. Done when the plan names the unit of work, cites the numbers that chose it, and the agreed design is saved.
3. **Build the simplest end-to-end flow first**: one path, one red-to-green slice per checkpoint at minimal depth (`tdd`, at agreed seams), so a tracer bullet runs through all of them before any deepening. Scope is what the brief asks for; extras go on a roadmap list, not into code. Done when every checkpoint runs end to end on the real input.
4. **Deepen inside the shape** until every checkpoint meets the brief, then stop. Finishing early is fine; spare time goes to step 6, not to new features. For performance, measure first, then optimise within the current shape. A fix that needs a new shape, found before the freeze, must replace the old one entirely (`simplicity-review`, "replaced or stacked"). Run `simplicity-review` once the first end-to-end slice works and after any change to the shape; bring off-course findings to the user before continuing.
5. **Freeze the shape** at the freeze point, or as soon as every checkpoint meets the brief if that comes first. From then on the flow's shape is fixed: fix, test, document and polish. A better shape found now goes on the roadmap with its measurements. Done when the shape at submission matches the shape at the freeze.
6. **Review it cold.** Run `simplicity-review` on the whole submission, fix its Defects and take Off course findings to the user; its cold read covers the inputs as delivered and the bad inputs. When real runs are costly (network, quota), make one real run on the delivered inputs and do the rest offline; test interrupts and timeouts against a fake slow dependency, never a real run, and give the reviewer these limits. Put the one sentence that explains any odd output where the reviewer meets it: the summary line, the README or the PR body. Done when nothing on a cold read looks broken or needs the design doc to make sense.
7. **Write it up small.** A README of about 50 lines: how to run it, the output, the trade-offs taken and the roadmap. In the submission, record only the decisions that change the result or that the reviewer confirmed; working notes can hold the rest.

## Judging a submission

When asked whether a submission meets the bar, assess it as the reviewer will: run it, then apply `simplicity-review`. Rank "hard to follow, hard to change, or looks broken on a cold read" above coverage of any checklist or preparation guide. A submission can tick every item in a guide and still lose on shape. Keep what the brief and the guide ask for, built as simply as it can be; cut what neither asks for.
