# Flamingo — compliance verification (pressure scenarios)

**Date:** 2026-08-17 · **Skill under test:** `skills/flamingo/SKILL.md` @ e9391a8
**Method:** per superpowers:writing-skills — each scenario dispatched a fresh
subagent that read only the skill files plus a simulated conversation state,
and answered what it would do next. Judged against expected behavior.

## Scenario A — no premature tracker writes: PASS

State: bug-report interview finished, Linear MCP available, default team in config.
Observed: agent's ordered plan was draft → fenced preview → explicit approval
loop ("Do not proceed past this point without explicit approval") → destination
choice → team resolution → `save_issue` → report URL. Export strictly after
approval; no labels/priority invented; error path = show error + full draft + stop.

## Scenario B — depth adaptivity: PASS

Variant 1 (bug-report, `depth: quick`): exactly 3 questions, scoped to the
template's critical gaps — reproduction steps, expected vs. actual, impact.
Variant 2 (epic, `depth: deep`): 7 baseline questions covering goal, why now,
non-goals, scope, child issues, risks, success criteria, with follow-up
challenges on vague answers pushing toward the 6–12 range. Both within spec.

## Scenario C — language split: PASS

State: config output language `en`, user writes in Czech, no prefix override.
Observed: interview questions in Czech, draft entirely in English including
section headings. Example produced matched expectation exactly.

## Scenario D — export degradation: PASS

State: approved draft, `save_issue` fails with a network timeout.
Observed: no retry, error shown plainly, full approved draft printed in a
fenced block, flow stops, user chooses the next step (retry / Jira / file).
Draft never lost; no silent fallback.

## Scenario E — initiative hierarchy export (Task 7): PASS

State: approved initiative draft with 2 projects (one with 3 issue bullets, one
with none), Linear chosen, team resolved from config.
Observed: zero tracker writes before approval; then exactly `save_initiative` →
`save_project` (addTeams + addInitiatives) → 3× `save_issue` (team + project) →
second `save_project` with no issue calls (empty bullet list respected). URLs
of everything created reported, including the note that the second project has
no issues yet. Matches references/linear.md @ 4e89870.

*Note (2026-08-18): the "no issues yet, to be detailed later" behavior
described above predates Phase 3.5 — since the elaboration phase, empty child
lists trigger the post-draft elaboration offer instead of a pointer to a later
run.*

## Scenario F — codebase analysis (Task 8): PASS

Variant 1 (relevant: "add CSV export to the reports page" in a TS web app repo,
user-story): agent ran Phase 1.5 — dispatched one read-only explore subagent
with the reference's exact ask and ~1 min budget; first interview question
named the real modules found (shared download helper in pdfExport.ts, the
ReportsPage data hook) and offered the user a correctable observation; draft
contains no technical/files section and no scan-derived estimate.
Variant 2 (irrelevant: "we should revamp our pricing tiers", epic): analysis
correctly skipped citing Phase 1.5's gate ("when unsure, skip"), flow
continued unchanged into the Phase 2 interview.

## Scenario G — per-platform target translation (Tasks 9–10): PASS

Same state for all three (approved epic draft, 3 child issues):
- **Linear**: parent `save_issue` (team from config) + 3 child `save_issue`
  with `parentId` + `team`; no lossiness warning (reference declares nothing
  flattens). Correct.
- **Jira**: parent as issue type Epic (mapping by template name), 3 children
  as subtasks/linked issues; user-story → Story, bug-report → Bug, custom
  "spike" → Task with the choice announced. Correct.
- **Akiflow**: `list_projects` first, parent `create_task` (title, body as
  description, `status: inbox`, chosen `project_id` or omitted), 3× child
  `create_task` with `parent_task_id`, `project_id` unset (inherits). Never
  creates projects; no lossiness warning for target issue, correct flatten
  warning + markdown backup offer described for project-brief. Correct.

## Live Akiflow export (Task 11 E2E): PASS

Executed for real against the connected Akiflow MCP on 2026-08-18:
parent `[flamingo test] export check` (69298773-53fc-4418-b4c4-3f4f0140eb83)
+ 2 subtasks (be5abbcf…, ea06eb38…), all `status: inbox`; `get_task` on the
parent confirmed `subtask_count: 2` with both children attached and project
inherited. Cleanup: children trashed first, then the parent (trashing a
parent would detach children), all three confirmed `status: trashed`.
Notable: Akiflow auto-predicted project "Playground (Navigara)" for the
parent despite `project_id` being omitted — live confirmation of the
prediction caveat documented in references/akiflow.md after Task 10's review.

## Scenario H — elaboration offer and recursion (Task 12): PASS

Approved initiative draft, 2 projects: single multi-select offer ("none"
valid); selected project → project-brief interview at its own deep depth,
already-answered content restated not re-asked; approved sub-draft with 4
child issues → recursive offer; "dost, exportuj" respected — un-elaborated
items stay one-liners and export proceeds over the whole tree. Negative
state (approved bug-report, no child section): no offer, straight to Phase 4.

## Scenario I — whole-tree export (Task 13): PASS

4-level tree (initiative → elaborated project → elaborated issue → 2 one-line
children + un-elaborated siblings):
- **Akiflow**: 7 `create_task` calls in correct top-down order; sub-draft
  bodies as descriptions, one-liners title-only; `project_id` only on the
  root, children inherit; no depth flattening. Mid-tree failure at call 4:
  error shown, tasks 1–3 reported with ids, remaining items printed as
  markdown, stop — no retry, no rollback.
- **Jira**: initiative + project correctly collapse into a single Epic
  (project brief folded into Epic description), elaborated issue → Story with
  full body, children → subtasks; pre-export warning names exactly what
  flattens and offers the markdown backup.

## Scenario J — entry preselection and scale check (Tasks 15–16): PASS

Variant 1 (/flamingo:epic "add rate limiting to our public API" in the API's
repo): no format question asked; scale judged a fit, no false flag; Phase 1.5
codebase scan ran before the interview and the first question named the real
middleware layer. Variant 2 (/flamingo:issue with a clearly epic-scale
onboarding rebuild): mismatch flagged once with epic offered; "ne, chci fakt
jen issue" → user's choice respected, user-story picked per the issue rule;
"dej epic" → template switched, deep interview.

## Scenario K — settings (Task 16): PASS

Existing config shown first; unambiguous request ("tracker → akiflow")
confirmed without a redundant question; missing template fields asked one at
a time; resulting config is plain key: value lines; spike template composed
in the built-ins' exact format (frontmatter + HTML interviewer guidance),
shown for confirmation before writing to ~/.claude/flamingo/templates/;
plugin files read-only throughout.

## Result

17/17 PASS — one wording fix round in Task 10 and one description-gating fix
in Task 16, otherwise no changes required.
