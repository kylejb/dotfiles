---
name: simplicity-review
description: Review a design or change for over-engineering and drift from its brief — paths through the core flow, mechanisms doing the same job, a home for the next requirement, and whether a change replaced or stacked. Use before merging a design or significant change, after a redesign or performance fix, at a checkpoint or the end of a time box, or when someone asks whether code is over-engineered or too complex.
metadata:
  version: "2"
  updated: "2026-11-09"
---

Judge the code the way a reviewer meets it: a **cold read**, with no author to ask. The question is not "is each piece reasonable?" (each usually is) but "is the whole as simple as the problem allows, and easy to change?"

Bugs outside the guidance belong to `code-review`; style belongs to the linter. This skill is about shape and whether the work still meets its guidance.

## Steps

1. **Start cold.** When you wrote or steered the code under review, hand this review to a subagent and leave out your reasoning. Give it the path to this skill file, the guidance, the commit the design was agreed at, how to run the code, where the delivered inputs are, and the output of any costly runs already done, so it does not repeat them. Without subagents, review in place and say the review was not cold. Done when the reviewer has only those, or the report says it was not cold.
2. **Read the guidance** in `.agent/guidance/` of the main checkout: the brief, any guide and the frozen approved design. When there is none, the Simplicity and Engineering principles in `AGENTS.md` are the guidance, the request or PR stands in for the brief, and the report says so. Done when the report can name what it checked against.
3. **Pin the core flow.** Name the unit of work (a row, a request, a file) and the stages it passes through from input to output. Done when you can state both in one sentence; if you can't, that is the first finding: the flow is hard to follow.
4. **Run the checks below** against the design or the diff, covering everything since the commit the approved design was agreed at, or the whole branch when there is none, rather than only the latest commit. Before the final review, run only Approved shape, Required work, Paths and Replaced or stacked, and mark the rest "not yet". For each, record a finding with evidence (file:line, a count), "clear", or "n/a: reason" when there is nothing to compare against or it could not be run. Done when every check due has an entry.
5. **Name the simpler shape** for each finding: what replaces it and what it deletes. If the complexity earns its place, say what it buys, measured where possible. Done when every finding has one or the other.
6. **Report** in two parts, under 400 words, each ranked by how hard a cold reader would trip. **Off course** holds departures from the approved shape and unmet required work; these stop the work and go to the user to decide. **Defects** holds the rest, as a fix list. A finding that fits both is Off course. Edit only when asked, or when a workflow such as `timed-exercise` calls this review.

## Checks

- **Approved shape.** Trace one unit of work through the code and compare its stages, its paths and where its state lives with the frozen approved design. A departure counts even when it is measurably better and even when a design doc was updated to match: it goes to the user with its measurements. A bug against something the design promises is a defect.
- **Required work.** Check each requirement in the brief and guide against the running code. A requirement is unmet when it is absent, or fails on the inputs as delivered or on ordinary bad input the interface accepts; gaps on rarer inputs are defects. Before the final review, check only what this checkpoint claims and mark the rest "not yet". Where the guide and the brief disagree, follow the brief. Simplicity cuts extras; everything required stays.
- **Paths.** Count the ways a unit of work can move through the core flow: branches on mode, concurrency or flags. The target is one. A branch on the data is fine when both sides become the same thing (a cache hit and a fresh computation both yield the same result type). An "off" mode is a null component (a no-op client that returns at once); concurrency is a parameter (pool size), never a branch. A sequential copy of the flow kept as a test oracle is a second path: test against literal expected values with a pool of one instead.
- **One job, one mechanism.** List the jobs the code does (dedup, caching, retry, ordering, owning state) and what does each. Two mechanisms on one job is one too many: keep the one that also covers the other's case.
- **Next requirement.** Name two plausible next requirements from the domain, such as a filter at a later stage or a second output. Each needs an obvious home that touches one place. When one has no home, the data or the stages are shaped wrong.
- **Whole data.** The unit of work stays whole until a stage needs less. Folding it early into counts or sets to save memory is a trade-off to state, and it is the usual reason the next requirement has no home.
- **Replaced or stacked.** For each change, list what it made redundant and confirm that is gone. A change that leaves the old mechanism running beside the new one is stacked, and stacked changes are where over-engineering comes from.
- **Surface.** Count flags, config keys, recorded decisions and pages of docs, and set them against the size of the task. Cut first what neither the brief nor the reviewer's guide asks for; what they ask for stays, built as simply as it can be.
- **Cold read.** Run it as the reviewer would: on the inputs exactly as delivered (the original files and formats), and on one bad input of each kind it accepts (a malformed line, a missing file, a broken config). Every run ends in the right output or a clear error, never a crash or a silently empty result. Every printed number, log line and flag must make sense where the reader meets it, for the flags of that run, without the design doc. A number that looks broken until explained (a counter stuck at zero) is a finding.
