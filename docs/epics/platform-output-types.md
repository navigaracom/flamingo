# Distinguishing output type by target platform

## Goal
On export, flamingo will create an object matching the target platform's own
model, not a single universal type. The abstract `target` in templates stays
unchanged; each reference file owns the translation to concrete objects —
Linear (initiative/project/issue), Jira (Epic/Story/Bug), and a new Akiflow
(tasks with subtasks). This includes a full Akiflow exporter, which does not
exist today.

## Why now
Akiflow is in real use, and flamingo currently can't export to it at
all — the missing destination is the main trigger.

## Non-goals
- `target` does not become a per-platform map, and does not gain a
  per-platform override in the frontmatter — the template contract (and
  custom user templates, which override built-ins by `name`) remains
  untouched.
- Tracker selection does not move ahead of template selection; the tracker
  is still chosen at the export phase.
- flamingo does not create Akiflow Projects.
- Jira `target: initiative` and `target: project` are not addressed in this
  epic — they remain as they are today.

## Scope
- Each reference file translates the abstract `target` into objects for its
  own platform; SKILL.md stays tracker-agnostic.
- Jira: add issue-type mapping — `epic.md` → Epic, `user-story.md` → Story,
  `bug-report.md` → Bug.
- Akiflow: new exporter. Everything goes in as tasks, hierarchy via
  `parent_task_id`; on export, existing projects are offered
  (`list_projects`) for assignment.
- Lossy export: for templates richer than the target platform, flamingo
  warns in advance about what will be flattened and offers to save the full
  markdown as a backup.

## Child issues
- Target translation in references — move the abstract `target` mapping
  into the individual reference files and unify their structure
- Jira issue-type mapping — extend `references/jira.md` with type selection
  based on the template used
- Akiflow exporter — new `references/akiflow.md`, tasks with subtasks via
  `parent_task_id`, existing-project selection via `list_projects`
- Wiring Akiflow into SKILL.md — a new destination in the export phase and
  the related user-facing description (README, plugin.json, skill
  description)
- Lossiness warning — a rule for exporting a rich draft to a leaner
  platform, including the offer of a markdown backup

## Risks and open questions
- Akiflow lossiness: a rich draft fits into a task only as text — even with
  a warning, structure may get lost in practice.
- MCP availability: neither Akiflow nor Jira MCP may be connected in a given
  environment — a clean fallback to markdown is needed.

## Success criteria
- A real export to Akiflow creates a task with subtasks in the selected
  project and returns confirmation.
- A pressure-scenario test in the repo verifies target translation for all
  three platforms and passes.
