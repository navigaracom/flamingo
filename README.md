# Flamingo

Claude Code plugin that turns vague ideas into structured work items
(user story, bug report, epic, project brief, initiative) through an
adaptive interview, then files them to Linear or Akiflow via MCP or
emits markdown.

What it does:

- **Adaptive interview** — question depth follows the chosen template
  (a bug report asks 2–3 things, an epic gets a thorough grilling), one
  question at a time, in your language; output in the configured language.
- **Codebase-aware** — when the idea touches code in the current repo, a
  quick read-only scan makes the questions and decomposition concrete.
- **Elaboration** — after a draft is approved, child items (projects,
  issues) can be fleshed out into full drafts recursively, in one run.
- **Export** — Linear (issues, epics with sub-issues, projects, initiatives),
  Akiflow (tasks with subtasks), Jira (prepared; needs a Jira MCP), or plain
  markdown. Nothing is created before you approve a preview, and a failed
  export never loses the draft.

## Installation

**As a plugin** (recommended for regular use):

    /plugin marketplace add navigaracom/flamingo
    /plugin install flamingo

Installed this way, invoke it as `/flamingo:flamingo <idea>` (plugin skills
are namespaced), or just describe your idea and let the skill trigger.

**From a clone** (instant updates via `git pull`, invoked as `/flamingo`):

    git clone https://github.com/navigaracom/flamingo.git
    cd flamingo && ./install.sh

## Use

    /flamingo <your vague idea>     # symlink install
    /flamingo en: <idea>            # override output language

Plugin installs get namespaced entry points:

| Entry | What you get |
|---|---|
| `/flamingo:idea` | full workflow, format chosen during the interview |
| `/flamingo:issue` | a single work item (Linear Issue · Jira Story/Bug · Akiflow Task) |
| `/flamingo:epic` | a decomposable batch of work (Jira Epic · Linear parent issue) |
| `/flamingo:project` | a deliverable with milestones (Linear Project) |
| `/flamingo:initiative` | a multi-project strategic effort (Linear Initiative) |
| `/flamingo:settings` | configure defaults and custom templates |
| `/flamingo:help` | explain flamingo, recommend an entry, troubleshoot |

Entries preselect the tier but sanity-check it: if your idea is clearly
bigger or smaller than the entry you picked, flamingo offers the better fit.

## Configuration (optional)

`~/.claude/flamingo/config.md` — default output language, tracker,
Linear team/project. `~/.claude/flamingo/templates/*.md` — custom
templates; same `name` as a built-in replaces it. Both live outside the
plugin, so they survive updates. Flamingo offers to create the config
after your first export.

## Development

    ./install.sh    # symlinks skills/flamingo into ~/.claude/skills

Design spec: `docs/superpowers/specs/2026-08-17-flamingo-design.md` ·
plan: `docs/superpowers/plans/2026-08-17-flamingo.md` · behavioral
verification: `docs/superpowers/specs/2026-08-17-flamingo-verification.md`.
