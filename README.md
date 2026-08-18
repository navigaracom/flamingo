# Flamingo

Claude Code plugin that turns vague ideas into structured work items
(user story, bug report, epic, project brief) through an adaptive
interview, then files them to Linear or Akiflow via MCP or emits markdown.

## Use

    /flamingo <your vague idea>
    /flamingo en: <idea>        # override output language

## Configuration (optional)

`~/.claude/flamingo/config.md` — default output language, tracker,
Linear team/project. `~/.claude/flamingo/templates/*.md` — custom
templates; same `name` as a built-in replaces it.

## Development

    ln -s "$(pwd)/skills/flamingo" ~/.claude/skills/flamingo

Design spec: `docs/superpowers/specs/2026-08-17-flamingo-design.md`.
