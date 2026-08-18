# Codebase analysis in flamingo

## Goal
When flamingo processes an idea related to code in the current repository, it
should automatically recognize the relevance and perform a quick read-only
survey of the codebase. It uses the findings in two ways: to ask informed
questions during the interview (instead of generic ones), and to propose a
decomposition into child issues that matches the real structure of the code.

## Why now
A strategic step in flamingo's evolution — not a response to an acute pain
point, but the next logical step toward higher-quality output for
code-related ideas.

## Non-goals
- No standalone technical section (files/modules) in the output work item —
  the analysis serves only the interview and the decomposition.
- No estimates of effort, complexity, or story points.
- No code changes — the analysis is strictly read-only.
- Only the current repo is analyzed; external repos, monorepo siblings, and
  dependencies outside the working directory are out of scope.

## Scope
- Relevance detection for the idea against the code in the current
  directory — if irrelevant, the analysis is skipped and the flow is
  unchanged.
- Quick (~30–60 s) read-only survey via a subagent: repo structure, affected
  modules, existing similar functionality.
- Wiring the findings into the interview phase and into the proposed child
  issues in the draft.
- [assumption: implementation will mean an update to SKILL.md and a new
  reference file, following the repo's established pattern of
  spec → SKILL.md → reference → test scenario]

## Child issues
- Relevance detection — logic that recognizes an idea relates to code in the
  current repo and decides whether to trigger the analysis
- Quick survey agent — read-only survey of the repo (structure, affected
  modules, existing similar functionality) and the output format for
  findings
- Interview integration — informed questions derived from the findings
- Decomposition integration — the proposed child issues in the draft derive
  from the real code structure

## Risks and open questions
- Incorrect relevance detection: the analysis runs for an irrelevant idea
  (wasted time), or fails to run for a relevant one.
- Misleading findings: a shallow survey returns a poor picture of the code,
  and the interview or decomposition heads in the wrong direction.
- Environment dependency: the skill must work even where a read-only
  subagent isn't available — a fallback is needed.

## Success criteria
- A new pressure-scenario test in the repo verifies the entire flow
  (relevant idea → analysis → informed interview → code-based decomposition)
  and passes.
