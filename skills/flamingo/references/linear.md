# Exporting to Linear

Requires the Linear MCP server (tools named `mcp__linear__*`). If unavailable,
say so and fall back to markdown output — never error out, never lose the draft.

## Resolve destination

1. Team: use the config default if set; otherwise call `list_teams` and let the
   user pick via AskUserQuestion.
2. `target: issue` → a Linear issue. Optionally attach to a project (config
   default, or ask; attaching is optional — skipping is fine).
   `target: project` → a Linear project.

## Create the item

- **Issue** (user-story, bug-report): `save_issue` with `title` = drafted title,
  `description` = full drafted markdown minus the title heading, `teamId` = the
  resolved team. Do not invent labels, priority, estimates, or assignees unless
  the user asked for them.
- **Epic**: create the parent via `save_issue`, then one `save_issue` per line of
  "Child issues" with `parentId` = the parent's id, title = the line, description
  = one sentence linking it to the parent.
- **Project** (project-brief): `save_project` with name, the drafted body as
  description, and the resolved team. If the draft has Milestones, offer to
  create each via `save_milestone` on the new project.

## Report

Give the user the URL(s) of everything created. On any tool error: show the
error, print the full markdown draft, and stop — do not blindly retry writes.
