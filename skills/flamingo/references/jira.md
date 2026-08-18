# Exporting to Jira

## Destination mapping

Check for Jira MCP tools first (ToolSearch for "jira"); none → see Report &
errors. Issue type by the chosen template's `name`: `epic` → Epic,
`user-story` → Story, `bug-report` → Bug; any other template with
`target: issue` → Task (tell the user which type was picked). For
`target: project` or `target: initiative`: most Jira MCP servers cannot
create projects or initiatives — create an Epic instead and say so.

## Create

Create the issue with the mapped type: summary = drafted title, description =
full drafted markdown minus the title heading. If the draft has a section
corresponding to the template's `## Child issues` (whatever its translated
heading), create children per line (title = the line without its bullet
marker) as subtasks or linked issues, per what the connected server supports.
Children with an approved sub-draft (Phase 3.5) get the sub-draft's title and
full body as `description` instead of a bare line. Items nested under those
children (child-of-child) become subtasks where the server supports subtasks
on a subtask; where it does not, fold them into their parent subtask's
description per the depth cap below.

## Lossiness

Milestones and initiative→project structure flatten into the Epic's
description. Warn before exporting a `target: project|initiative` draft (see
SKILL.md Phase 4) and offer the markdown backup.

Depth cap: Epic → issue → subtask is the deepest reliable Jira hierarchy —
any level below an elaborated subtask flattens into that subtask's
description (trigger the Phase 4 warning and markdown backup when this
happens).

## Report & errors

Report created issue URL(s)/key(s). No Jira MCP connected: say so, print the
final markdown for copy-paste, and mention that connecting a Jira MCP server
enables direct creation. On any tool error: show the error, print the full
markdown draft, stop — no blind retries.

Create the tree top-down, parent before children. On a mid-tree tool error,
report what was already created (names + URLs/ids), print every
not-yet-exported sub-draft as markdown so nothing is lost, and stop — no
blind retries, no rollback attempts.
