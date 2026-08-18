# Elaborating child items in a single run

## Goal
After a draft containing child items is approved, flamingo will offer to
elaborate them into full form — each selected item goes through its own
interview based on its template and becomes a full sub-draft. The recursion
continues as long as the user wants. Export then creates the whole tree at
once, so a run never ends with empty projects pointing to "run /flamingo per
project."

## Why now
Encountered in practice — after exporting an initiative, the resulting
projects had no issues, and the breakdown had to be finished manually with
further flamingo runs.

## Non-goals
- Interview depth does not become a user choice — `depth` remains a
  template constant; each sub-draft follows the `depth` of its own template.
- The offer does not appear for drafts without child items.
- The interview for an initiative does not start requiring issues — forcing
  detail during the interview remains rejected; only what follows the draft
  changes.
- Detail is not added to objects that already exist in the tracker.

## Scope
- A new phase between draft approval and export: if the approved draft
  contains a section with child items (Projects, Child issues), flamingo
  offers a selection of which ones to elaborate.
- Each selected item gets its own interview at the `depth` of its template
  (project → project-brief, issue → user-story) and its own approved
  sub-draft.
- Recursion with no fixed limit: after each sub-draft, the next level is
  offered, until the user says enough.
- Export processes the entire tree in one pass.
- The initiative template and the verification spec are updated so an empty
  issues list is no longer described as an expected outcome — instead of
  pointing to a later run, it points to the post-draft elaboration offer.

## Child issues
- Elaboration-offer phase — detecting child items in the approved draft and
  selecting which to elaborate
- Recursive sub-draft loop — mapping an item to its template, a
  mini-interview at its `depth`, approval, and nesting the next level
- Whole-tree export — extending the three reference files (`linear.md`,
  `jira.md`, `akiflow.md`) to create a multi-level hierarchy
- Depth lossiness — a rule for when the tree is deeper than the target
  platform can hold
- Update the initiative template and verification spec — remove the
  description of an empty issues list as expected behavior

## Risks and open questions
- Unbounded recursion vs. the tracker: the tree may exceed the depth a
  tracker can hold (Akiflow handles three levels) — lossiness must be
  handled.
- Context and interruption: a long tree of drafts must survive in context
  until export; an interruption risks losing work in progress.
- Disproportionate export: a single approval can create dozens of objects;
  an error mid-export leaves a partially created tree.

## Success criteria
- An initiative with projects and issues is created in a single flamingo
  run, with no need to run it again.
- A pressure-scenario test in the repo verifies the elaboration offer, the
  recursion, and the whole-tree export, and passes.
