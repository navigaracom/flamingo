---
name: settings
description: Use when the user explicitly asks to configure flamingo — default output language, tracker, Linear team/project — or to manage custom flamingo templates in ~/.claude/flamingo/.
---

# Flamingo — settings

Manage flamingo's user configuration in `~/.claude/flamingo/` (outside the
plugin, so it survives updates). Never modify plugin files.

## Config

1. Read `~/.claude/flamingo/config.md` if it exists and show current values;
   otherwise say none exists yet and offer to create it.
2. Ask what to change, one question at a time: output language, default
   tracker (linear | akiflow | jira | markdown), default Linear team, default
   Linear/Akiflow project.
3. Write simple `key: value` lines (format example in `../flamingo/SKILL.md`
   Phase 0) and show the resulting file.

## Templates

- List templates on request: built-ins from `../flamingo/templates/` plus
  user templates in `~/.claude/flamingo/templates/`; note that a user
  template overrides the built-in with the same `name`.
- To create a custom template, ask for: name, description, depth
  (quick|standard|deep), target (issue|project|initiative), and the sections
  it needs. Compose it in the built-ins' format (frontmatter + body skeleton,
  HTML comments as interviewer guidance), show it for confirmation, then
  write `~/.claude/flamingo/templates/<name>.md`.
