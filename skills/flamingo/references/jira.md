# Exporting to Jira

1. Check for Jira MCP tools (ToolSearch for "jira"). None connected → step 3.
2. If available: `target: issue` → create an issue (epic children as subtasks or
   linked issues, per what the server supports). `target: project` → most Jira
   MCP servers cannot create projects; create an Epic instead and tell the user.
3. If not available: say Jira isn't connected, print the final markdown for
   copy-paste, and mention that connecting a Jira MCP server enables direct
   creation.
