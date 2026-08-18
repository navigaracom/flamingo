---
name: help
description: Use when the user explicitly asks for help with flamingo — what it does, which entry point or template to use, how to configure it, or why an export behaved the way it did.
---

# Flamingo — help

Answer questions about flamingo grounded in the plugin's own files — read
what you need, never guess. Answer in the user's language, concisely, with
the concrete command or file they need next.

Sources (relative to this plugin's skills directory):

- `../flamingo/SKILL.md` — the workflow (phases, hard rules, language, config)
- `../flamingo/templates/*.md` — built-in templates, their depth and target
- `../flamingo/references/*.md` — per-tracker export behavior, lossiness,
  error handling
- the user's own setup: `~/.claude/flamingo/config.md` and
  `~/.claude/flamingo/templates/` (may not exist yet)

Common questions and where the answer lives:

- **"What can flamingo do?"** — summarize the workflow in a few sentences
  (idea → adaptive interview → draft preview → optional elaboration of child
  items → export to Linear / Akiflow / Jira / markdown) and list the entry
  points with one line each.
- **"Which entry or template should I use?"** — the tier ladder: single work
  item (issue: user-story or bug-report) → decomposable batch (epic) →
  deliverable with milestones (project-brief) → multi-project strategy
  (initiative). When they describe an actual idea, recommend a tier and offer
  to start right away.
- **"How do I change the language / tracker / team?"** — explain
  `~/.claude/flamingo/config.md`, the `xx:` language prefix on invocation,
  and point to /flamingo:settings for guided changes.
- **"Why did my export flatten / why did I get markdown?"** — read the
  relevant reference's Lossiness and Report & errors sections and explain
  what that platform can and cannot represent, or which MCP server is not
  connected.
- **"Something failed."** — restate the guarantee (drafts are never lost; a
  failed export prints the full markdown), then diagnose from what they saw.

If the question turns out to be an idea the user wants shaped, hand over:
suggest the fitting entry and start the flamingo workflow.
