<p align="center">
  <img src="assets/logo.svg" width="96" alt="Flamingo logo" />
</p>

<h1 align="center">Flamingo</h1>

<p align="center">
Claude Code plugin that turns vague ideas into structured work items —<br>
user stories, bug reports, epics, projects, initiatives —<br>
through an adaptive interview, and files them to Linear or Akiflow, or emits markdown.
</p>

---

## Requirements

- [Claude Code](https://claude.com/claude-code) (CLI, desktop, or IDE extension)
- Optional, for direct export — MCP servers connected in Claude Code:
  - **Linear MCP** for exporting issues, epics, projects, and initiatives to Linear
  - **Akiflow MCP** for exporting tasks with subtasks to Akiflow
  - Jira is prepared but needs a Jira MCP server; until one is connected, Jira export falls back to markdown

Without any MCP server everything still works — the result is markdown you can paste anywhere.

## Installation

**As a plugin** (recommended — versioned updates via `/plugin`):

```
/plugin marketplace add navigaracom/flamingo
/plugin install flamingo
```

**From a clone** (instant updates via `git pull`; skill invoked as plain `/flamingo`):

```
git clone https://github.com/navigaracom/flamingo.git
cd flamingo && ./install.sh
```

## Commands

Plugin installs get namespaced commands. With the clone/symlink install you have plain `/flamingo`, which covers the full workflow; the other entries are a plugin benefit.

| Command | What it does |
|---|---|
| `/flamingo:idea <idea>` | Full workflow — flamingo picks or asks for the right format |
| `/flamingo:issue <idea>` | A single work item; flamingo picks user story vs. bug report (Linear Issue · Jira Story/Bug · Akiflow Task) |
| `/flamingo:epic <idea>` | A decomposable batch of work with child issues (Jira Epic · Linear parent issue) |
| `/flamingo:project <idea>` | A self-contained deliverable with milestones (Linear Project) |
| `/flamingo:initiative <idea>` | A multi-project strategic effort (Linear Initiative) |
| `/flamingo:settings` | View/edit defaults (language, tracker, team) and manage custom templates |
| `/flamingo:help` | Explain flamingo, recommend the right entry for your idea, troubleshoot |

Notes:

- The argument can be as vague as you like — that's the point: `/flamingo:idea občas nám padá checkout, když someone applies a discount`.
- Prefix the idea with a language code to override the output language: `/flamingo:idea en: <český nápad>` → interview in Czech, work item in English.
- Tier entries sanity-check scale both ways: invoke `/flamingo:issue` with an initiative-sized idea and flamingo offers the better fit once — your choice wins.
- You can also just describe your idea in plain words; the main skill triggers itself when it fits.

## How it works

1. **Format** — flamingo proposes a template based on your idea (crash → bug report, multi-part effort → epic/initiative), or you preselect one via a tier command.
2. **Codebase analysis** (conditional) — if the idea concerns code in the current repo, a quick read-only scan (~30–60 s) finds the affected modules so the interview asks informed questions instead of generic ones. Skipped when irrelevant.
3. **Interview** — one question at a time, in your language, with depth matching the template: a bug report gets 2–3 questions, an epic gets a thorough grilling (goals, non-goals, scope, risks, success criteria). Say "enough, write it up" any time — gaps are marked `[assumption: …]`.
4. **Draft preview** — the filled template in the output language. Iterate until you approve. **Nothing is ever created in a tracker before you approve the preview.**
5. **Elaboration** (optional) — if the approved draft has child items (projects, issues), flamingo offers to flesh selected ones out into full drafts, recursively, in the same run — so an initiative exports with real projects and issues, not empty stubs.
6. **Export** — pick a destination; the whole tree is created in one pass and you get the URLs. If a platform can't represent part of the draft, flamingo tells you exactly what will flatten *before* exporting and offers a markdown backup. A failed export always prints the full draft — nothing is ever lost.

## Built-in templates

| Template | Interview depth | Creates |
|---|---|---|
| `user-story` | standard (3–6 questions) | issue — story with acceptance criteria |
| `bug-report` | quick (≤3 questions) | issue — repro steps, expected vs. actual, impact |
| `epic` | deep (6–12 questions) | parent issue + child sub-issues |
| `project-brief` | deep | project with milestones, optionally with issues |
| `initiative` | deep | initiative → projects → issues |

## Export destinations

| Destination | What gets created |
|---|---|
| **Linear** | Issues, epics as parent + sub-issues (any nesting depth), projects with milestones and issues, initiatives with linked projects — full hierarchy, nothing flattens |
| **Akiflow** | Everything as tasks: hierarchy via subtasks at any depth, filed into an existing project of your choice (flamingo never creates Akiflow projects); rich sections flatten into the task description |
| **Jira** | Issue type by template — epic → Epic, user-story → Story, bug-report → Bug, others → Task; children as subtasks; initiative/project collapse into an Epic (with a warning). Requires a Jira MCP server |
| **Markdown** | Always available — print or save to a file; also the automatic fallback whenever an MCP server is missing or errors |

## Configuration

All user data lives in `~/.claude/flamingo/` — outside the plugin, so it survives updates. Flamingo offers to create the config after your first export, or use `/flamingo:settings` any time.

`~/.claude/flamingo/config.md`:

```
output language: en
tracker: linear
linear team: Navigara
linear project: Flamingo
```

All keys are optional. Without a config, the output language matches the language of your idea and the tracker is asked at export time.

### Custom templates

Drop a markdown file into `~/.claude/flamingo/templates/` (or let `/flamingo:settings` scaffold it). Same format as the built-ins — frontmatter drives the interview and export:

```markdown
---
name: spike
description: Timeboxed technical investigation
depth: quick          # quick | standard | deep
target: issue         # issue | project | initiative
---
<!-- HTML comments are interviewer guidance, never emitted to output. -->

# <title>

## Question
<what we need to answer>
```

A custom template with the same `name` as a built-in replaces it.

## Development

```
./install.sh    # symlinks skills/flamingo into ~/.claude/skills
```

The repo doubles as the plugin: `skills/` holds the eight skills, `.claude-plugin/` the manifest and marketplace. Design docs live in `docs/superpowers/` — [spec](docs/superpowers/specs/2026-08-17-flamingo-design.md), [plan](docs/superpowers/plans/2026-08-17-flamingo.md), [behavioral verification](docs/superpowers/specs/2026-08-17-flamingo-verification.md) (18/18 pressure scenarios). Feature ideas arrive as flamingo-authored epics in [`docs/epics/`](docs/epics/).

## License

[MIT](LICENSE) © Navigara
