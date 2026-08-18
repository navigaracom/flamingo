# Codebase analysis

Quick read-only reconnaissance of the current repository so the interview
asks informed questions and the decomposition matches the real code
structure. Findings live in the conversation only — they NEVER appear as a
technical section in the drafted work item, and no effort, complexity, or
story-point estimates are derived from them.

## Run the scan

1. Preferred: dispatch one read-only subagent (an explore-type agent if the
   platform has one) with: the idea in one line, the repo root, and this ask —
   "Report briefly: (a) overall structure (main directories/modules and their
   roles), (b) the modules/files this idea would likely touch, (c) existing
   functionality or patterns similar to the idea, (d) anything that makes the
   idea harder or easier than it sounds. Read excerpts, not whole files; this
   is a quick scan (~30–60 s), not an audit. Strictly read-only."
2. Fallback without subagent tooling: do the same scan yourself with a
   handful of read-only commands (list directories, grep for terms from the
   idea); keep it under a minute.
3. If neither is possible, or the scan errors: skip analysis and continue the
   normal flow — analysis must never block or delay the interview by more
   than about a minute. Scope is the current working directory's repo only;
   no external repos, monorepo siblings, or dependencies outside it.

## Use the findings

- **Interview (Phase 2):** replace generic questions with informed ones.
  Instead of "which part of the app does this touch?", ask "this looks like
  it lives in `<real module>`, which also handles `<related thing>` — should
  the change cover both?". Never present findings as certainties — the scan
  is shallow; phrase them as observations the user can correct.
- **Decomposition (Phase 3, templates with a `## Child issues` section):**
  propose child issues that align with the code's real seams (per module,
  layer, or existing pattern found), instead of generic split-by-feature
  guesses. The user still approves the decomposition in the preview.
