# Exporting to Linear

Requires the Linear MCP server (tools named `mcp__linear__*`). If unavailable,
say so and fall back to markdown output — never error out, never lose the draft.

## Destination mapping

1. `target: issue` → a Linear issue. Optionally attach to a project (config
   default, or ask via `list_projects`; attaching is optional — skipping is
   fine). `target: project` → a Linear project. `target: initiative` → a
   Linear initiative with its projects and their issues.
2. Team: use the config default if set; otherwise call `list_teams` and let the
   user pick via AskUserQuestion.

## Create

- **Issue** (`target: issue`): `save_issue` with `title` = drafted title,
  `description` = full drafted markdown minus the title heading, `team` = the
  resolved team (`save_issue` takes `team`, not `teamId`). Do not invent
  labels, priority, estimates, or assignees unless the user asked for them.
- **Child issues** (sub-issues / project child issues): if the chosen
  template has a `## Child issues` section (the built-in epic template,
  project-brief, or any custom template) and the draft has a section
  corresponding to it, whatever its translated heading, create one
  `save_issue` per line, with `team` = the resolved team (required on
  create) and title = the line without its bullet marker. For an issue
  target (epic), the item above is the parent — each call also sets
  `parentId` = the parent's id and description = one sentence linking it to
  the parent. For a project target (project-brief), create these after the
  project exists and set `project` = the new project's name or ID instead of
  `parentId`. When a child item has an approved sub-draft (Phase 3.5), use
  the sub-draft's title and its full body as the created issue's
  `description` instead of the one-sentence link to the parent, and recurse
  into that sub-draft's own child items the same way — sub-issues may nest
  under sub-issues, each new level's `parentId` pointing at the issue just
  created for its parent.
- **Project** (`target: project`): `save_project` with `name` and the drafted
  body as `description`. `save_project` has no `team` field — pass the
  resolved team via `addTeams` (or `setTeams`); `name` plus at least one of
  `addTeams`/`setTeams` is required. If the draft has a section corresponding
  to the template's `## Milestones` section, whatever its translated heading,
  offer to create each via `save_milestone` on the new project —
  `save_milestone` requires its `project` parameter (the new project's name
  or ID).
- **Initiative** (`target: initiative`): `save_initiative` with `name` =
  drafted title and `description` = the drafted body minus the title heading
  and the section corresponding to the template's `## Projects` section,
  whatever its translated heading. Then, for each `### <project name>`
  subsection of that Projects section: `save_project` with the subsection's
  name, the resolved team via `addTeams`, and `addInitiatives` = the created
  initiative's name (or ID) to link it to the initiative. If that project
  subsection has an approved sub-draft, its title and full body become the
  new project's `description` (instead of the subsection's goal text), and
  the sub-draft's own `## Child issues` section is created inside the new
  project exactly as in the Child issues bullet above, recursing into any of
  those issues' further sub-drafts the same way. Otherwise `description` =
  the subsection's goal text, and each bullet under the subsection becomes
  `save_issue` with `team` = the resolved team (required on create) and
  `project` = the created project's name (or ID), title = the line without
  its bullet marker.

## Lossiness

Linear represents all built-in template structures — nothing flattens.
Linear represents arbitrary issue nesting and initiative → project → issue;
no depth flattening.

## Report & errors

Give the user the URL(s) of everything created. On any tool error: show the
error, print the full markdown draft, and stop — do not blindly retry writes.

Create the tree top-down, parent before children. On a mid-tree tool error,
report what was already created (names + URLs/ids), print every
not-yet-exported sub-draft as markdown so nothing is lost, and stop — no
blind retries, no rollback attempts.
