# Exporting to Akiflow

## Destination mapping

Check for Akiflow MCP tools first (ToolSearch for "akiflow"); none → see
Report & errors. Akiflow has only tasks (with subtasks via `parent_task_id`)
and projects that flamingo never creates. Map by `target`:

- `target: issue` → one task, plus one subtask per line of the draft's
  `## Child issues` section (whatever its translated heading), if present.
- `target: project` → one parent task for the project, plus one subtask per
  line of its `## Child issues` section; its `## Milestones` section (if any)
  flattens into the parent task's description instead of becoming separate
  tasks.
- `target: initiative` → one parent task for the initiative; each
  `### <project name>` subsection of its `## Projects` section becomes a
  subtask of that parent (`parent_task_id` = the initiative task); each issue
  bullet under that subsection becomes a sub-subtask (`parent_task_id` = the
  project subtask).

Ask which existing Akiflow project to file the top-level (parent) task into,
via `list_projects` (offer the config default first if set); none chosen →
leave `project_id` unset. The task still lands in the Inbox because `## Create`
below always sets `status: inbox`, regardless of `project_id`. Caveat: per
the `create_task` schema, a task left without `project_id` "may get a project
predicted for it" — Akiflow itself can still auto-categorize the task into a
project the user never picked; this is outside flamingo's control. Never
create Akiflow projects (epic non-goal).

## Create

`create_task` requires an explicit `status` — there is no default. Use
`status: inbox` for every task flamingo creates (flamingo never schedules or
plans tasks on the user's behalf).

Create the parent task first: `title` = drafted title, `description` = full
drafted markdown minus the title heading, `status: inbox`, `project_id` = the
chosen project's id (omit entirely if none was chosen). Then create each
child in order — title = the line without its bullet marker, `status:
inbox`, `parent_task_id` = the appropriate parent (the top-level task, or for
initiative sub-subtasks, the project subtask created just before it) — and
leave `project_id` unset on every child: Akiflow inherits the parent's
project (and tags) automatically for any field a child call omits, so
children need not, and should not, set it explicitly.

## Lossiness

Everything beyond title, description, and the subtask hierarchy above
flattens into task text: goals, non-goals, risks, success criteria,
acceptance criteria, and milestones survive only as markdown inside the
relevant task's description, never as separate Akiflow objects. Always
triggers the Phase 4 lossiness warning for `target: project|initiative` (see
SKILL.md) and offer the markdown backup.

## Report & errors

Report each created task's title and id (Akiflow's tools return no URL). No
Akiflow MCP connected: say so, print the final markdown for copy-paste, and
mention that connecting the Akiflow MCP enables direct creation. On any tool
error: show the error, print the full markdown draft, and stop — no blind
retries.
