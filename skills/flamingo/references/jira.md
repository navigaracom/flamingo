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

## Lossiness

Milestones and initiative→project structure flatten into the Epic's
description. Warn before exporting a `target: project|initiative` draft (see
SKILL.md Phase 4) and offer the markdown backup.

## Report & errors

Report created issue URL(s)/key(s). No Jira MCP connected: say so, print the
final markdown for copy-paste, and mention that connecting a Jira MCP server
enables direct creation. On any tool error: show the error, print the full
markdown draft, stop — no blind retries.
