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

## Result

4/4 PASS at first run — no SKILL.md changes required.
