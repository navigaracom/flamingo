# Flamingo — design

**Date:** 2026-08-17
**Status:** draft awaiting approval

## Purpose

Flamingo is a Claude Code plugin that turns vague ideas into structured work items
(user story, bug report, epic, project brief…) through an adaptive interview. It shows
the user the result as a preview, lets them refine it, and after approval files it in
the tracker (today Linear via MCP; Jira prepared for later) or emits it as markdown.

## Decisions from brainstorming

- **Output:** always preview first + iterative refinement; export to the tracker only after approval.
- **Formats:** built-in templates + custom user templates (custom ones override built-ins).
- **Interview:** adaptive depth based on the target format (bug = 2–3 questions, epic = thorough grilling).
- **Language:** default output language in config, overridable by argument; the interview happens in the user's language.
- **Packaging:** plugin structure from the start (name **flamingo**), for development a symlink of the skill
  into `~/.claude/skills/`, so changes take effect immediately.

## Repo structure

```
flamingo/                          ← this repo
  .claude-plugin/
    plugin.json                    ← manifest: name "flamingo", version, description
  skills/
    flamingo/
      SKILL.md                     ← the whole workflow
      templates/                   ← built-in templates
        user-story.md
        bug-report.md
        epic.md
        project-brief.md
        initiative.md
      references/
        linear.md                  ← mapping of template fields to Linear MCP tools
        jira.md                    ← procedure for Jira (today falls back to markdown)
        codebase-analysis.md       ← read-only repo survey for an informed interview
        akiflow.md                 ← export to Akiflow (tasks with subtasks)
  docs/superpowers/specs/          ← this document
```

Development symlink: `~/.claude/skills/flamingo → <repo>/skills/flamingo`.
Invocation: `/flamingo <idea>`.

Distribution later: add `marketplace.json`, colleagues install via `/plugin`.
The skill's content doesn't change as a result.

## User data (outside the repo and the plugin)

`~/.claude/flamingo/`:

- `config.md` — default output language, default tracker, default Linear team/project.
- `templates/*.md` — custom templates; a file with the same name as a built-in template overrides it.

Reason for the separation: a plugin update overwrites its cache, but the user's config and
templates must survive. If the config doesn't exist, the skill works with sensible defaults
(output language = input language, tracker chosen at export time) and offers to create the
config at the end of the first run.

## Template format

Markdown with frontmatter; the frontmatter drives both the interview and the export:

```markdown
---
name: user-story
description: A user story with acceptance criteria
depth: standard          # quick | standard | deep — interview depth
target: issue            # issue | project | initiative — what gets created in the tracker
---
## Story
As a <role> I want <goal>, so that <benefit>.

## Acceptance criteria
- …
```

- `depth: quick` — 2–3 questions targeting only critical gaps (typically bug-report).
- `depth: standard` — covers all sections of the template (user-story).
- `depth: deep` — grill-me-style questioning: goals, non-goals, scope, risks,
  acceptance criteria, edge cases (epic, project-brief).

The template body is the skeleton of the output; `<!-- -->` comments in the body can carry
instructions for the interviewer (what to ask, what's required) and never make it into the output.

## Skill workflow

1. **Input.** `/flamingo <idea>`; without an argument, it asks for the idea.
   Output-language override via prefix, e.g. `/flamingo en: …`.
2. **Format selection.** Loads the config and templates (built-in ∪ custom). If the format
   is clearly implied by the input, it's proposed for confirmation; otherwise a selection is
   offered (AskUserQuestion).
3. **Interview.** Questions one at a time, with multiple-choice options where possible, in the
   language the user writes in. Depth per `depth`. The user can say "that's enough, write it up"
   at any point — undetermined information is explicitly marked in the draft as `[assumption: …]`.
4. **Draft and refinement.** Fills in the template in the output language, shows a preview, iterates
   on feedback until the user approves.
5. **Export.** Offers destinations:
   - **Linear** (MCP): `save_issue` / `save_project` / `save_initiative` based on
     `target`; team/project from config, otherwise asked (`list_teams` /
     `list_projects`). Hierarchy: epic = parent issue with sub-issues; project
     (project-brief) optionally with issues inside (`## Child issues` section);
     initiative = `save_initiative` → per-project `save_project` linked to the
     initiative → per-issue `save_issue` with team and project. Issues per
     project are optional at the initiative level — the interview doesn't force them, they
     get added later in separate runs. Returns the URL of everything created.
   - **Jira**: issue type based on template — `epic` → Epic, `user-story` → Story,
     `bug-report` → Bug, other templates with `target: issue` → Task;
     `target: initiative/project` stay as they are today (Epic + explanation).
     Without MCP, falls back to markdown (procedure in `references/jira.md`).
   - **Akiflow** (`references/akiflow.md`): everything as tasks, hierarchy via
     `parent_task_id` (parent → subtasks; for an initiative, projects become subtasks
     and their issues one level below). On export, existing projects are offered
     via `list_projects`; Akiflow projects are never created; without a chosen
     project the task goes to the inbox. Without MCP, falls back to markdown.
   - **Markdown**: print / save to a file — always works, even without any MCP.

   Translating the abstract `target` into concrete objects is owned by each reference
   file (a unified structure: mapping → creation → lossiness → report and
   errors); SKILL.md stays tracker-agnostic. **Lossiness:** if the target
   platform can't represent part of the draft (e.g. a rich project-brief into an
   Akiflow task), the skill states what will be flattened before exporting and
   offers to save the full markdown as a backup.

## Codebase analysis (per docs/epics/codebase-analysis.md)

Between format selection and the interview (phase 1.5): if the idea relates to code
in the current repository (detection: the idea describes a change in software
behavior and the working directory contains matching code), the skill runs a quick
(~30–60 s) read-only survey via a subagent — repo structure, affected modules,
existing similar functionality. The findings serve exactly two purposes:
informed interview questions (instead of generic ones) and decomposition into child
issues that match real seams in the code. No technical section appears in the
output work item; no effort estimates. If irrelevant, the survey is skipped and the
flow is unchanged; without an available subagent, a short direct survey is done instead, or it's
skipped entirely — the analysis never blocks the flow. Procedure in
`references/codebase-analysis.md`.

## Elaborating child items (per docs/epics/child-item-elaboration.md)

A new phase 3.5 between draft approval and export: if the approved draft
contains a section with child items (Projects, Child issues), flamingo
offers a selection of which ones to elaborate into full sub-drafts. Mapping:
a project item → project-brief template, an issue item → user-story (the user
can choose otherwise). Each selected item goes through its own mini-interview
at the `depth` of its template and its own approval; an approved sub-draft with further
child items recursively offers the next level — with no fixed limit,
until the user says enough. Un-elaborated items remain one-liners.

Export creates the whole tree in a single top-down pass: an elaborated item
gets the body of its sub-draft as its description (instead of a one-line reference to
the parent), and its children are created recursively. **Depth lossiness:** each
reference declares the maximum representable depth; deeper levels are
flattened into the description of the deepest representable object (a warning + offer
of a markdown backup, per phase 4). **Mid-export error:** report what has already
been created (URL/id), print the rest of the tree as markdown, stop — nothing is lost.

The initiative template and the verification spec are updated: an empty
issues list is no longer described as an expected state referencing "a later run" —
instead it points to the post-draft elaboration offer. Non-goals: `depth`
remains a template constant; the interview doesn't force issues on an
initiative; existing objects already in the tracker are not filled in further.

## Entry skills (discussed 2026-08-18)

The plugin ships thin entry skills alongside the main `flamingo` skill, giving
plugin users tier-named entry points (`/flamingo:issue`, `/flamingo:epic`,
`/flamingo:project`, `/flamingo:initiative`), a nicer alias for the full flow
(`/flamingo:idea`), and configuration management (`/flamingo:settings`).

- **Tier entries are thin wrappers** (~10 lines): read the main SKILL.md,
  follow its workflow, template preselected, Phase 1 format selection skipped.
  No workflow logic is duplicated. The `issue` entry picks user-story vs
  bug-report from the idea (asking when unclear).
- **Tier names are the union of platform vocabularies** — issue (Linear),
  epic (Jira), project (Linear), initiative (Linear) — one established name
  per tier. No per-platform alias skills: Linear Issue ≈ Jira Story ≈ Akiflow
  Task would triple the entries for the same tiers. Descriptions mention the
  platform synonyms instead, so users find their tier whatever tracker
  vocabulary they think in.
- **Scale check (both directions):** preselection skips the format question,
  not judgment — when the idea's scope clearly mismatches the chosen tier,
  the skill says so once and offers the better-fitting template; the user's
  choice wins. This is the early net for a "wrong alias"; the late net is the
  existing export lossiness warning.
- **Model-trigger stays on the main skill only.** Entry-skill descriptions
  are phrased "use when the user explicitly asks…" so automatic invocation
  doesn't roulette among synonymous entries.
- **`settings`** is the one entry with own logic: show/edit
  `~/.claude/flamingo/config.md` and list or scaffold custom templates. It
  never modifies plugin files.
- Symlink users keep `/flamingo` only; entry skills are a plugin-install
  benefit (generic names like `issue` are too collision-prone as global
  personal skills). Custom user templates get no entry skill — they remain
  reachable through the main flow's template choice.

## Error handling

- Linear MCP unavailable / fails → degrade to markdown output, never lose the draft.
- Interrupted interview: the draft is held in the conversation throughout; the skill never creates
  anything in the tracker without explicit approval of the preview.

## Testing

Per superpowers:writing-skills (TDD for skills): pressure scenarios with subagents —
(a) a vague one-sentence request → bug-report, (b) a big idea → epic with grilling,
(c) Czech input + English output per config, (d) export without Linear MCP available.
Baseline without the skill → skill → compliance verification.

## Out of scope (YAGNI)

- Attachments and images.
- Bulk creation of unrelated issues (except epic → sub-issues).
- Syncing back from the tracker into the document.
- Direct Jira REST API integration with API keys — until there's a real need.
