# Exporting to Linear

Requires the Linear MCP server (tools named `mcp__linear__*`). If unavailable,
say so and fall back to markdown output — never error out, never lose the draft.

## Resolve destination

1. Team: use the config default if set; otherwise call `list_teams` and let the
   user pick via AskUserQuestion.
2. `target: issue` → a Linear issue. Optionally attach to a project (config
   default, or ask via `list_projects`; attaching is optional — skipping is
   fine). `target: project` → a Linear project.

## Create the item

- **Issue** (`target: issue`): `save_issue` with `title` = drafted title,
  `description` = full drafted markdown minus the title heading, `team` = the
  resolved team (`save_issue` takes `team`, not `teamId`). Do not invent
  labels, priority, estimates, or assignees unless the user asked for them.
- **Sub-issues**: if the chosen template has a `## Child issues` section
  (the built-in epic template or any custom template), the item above is the
  parent — after creating it, create one `save_issue` per line in the draft
  section corresponding to the template's `## Child issues` section, whatever
  its translated heading, with `parentId` = the parent's id, title = the line
  without its bullet marker, description = one sentence linking it to the
  parent.
- **Project** (`target: project`): `save_project` with `name` and the drafted
  body as `description`. `save_project` has no `team` field — pass the
  resolved team via `addTeams` (or `setTeams`); `name` plus at least one of
  `addTeams`/`setTeams` is required. If the draft has a section corresponding
  to the template's `## Milestones` section, whatever its translated heading,
  offer to create each via `save_milestone` on the new project —
  `save_milestone` requires its `project` parameter (the new project's name
  or ID).

## Report

Give the user the URL(s) of everything created. On any tool error: show the
error, print the full markdown draft, and stop — do not blindly retry writes.
