---
name: flamingo
description: Use when the user has a vague idea, feature request, or bug they want turned into a structured work item (user story, bug report, epic, project brief) — runs an adaptive interview, drafts the item from a template in the configured output language, and after approval files it to Linear via MCP or emits markdown.
---

# Flamingo — from vague idea to structured work item

Turn a loosely described idea into a filled-in work item through an adaptive
interview, then file it where the user wants it.

## Hard rules

- NEVER create anything in a tracker before the user approves a preview draft.
- Interview questions go strictly one at a time. Use AskUserQuestion with
  options where choices are enumerable; open questions otherwise.
- Interview in the language the user is writing in. Draft in the output
  language (see Phase 0 and Phase 1).
- If the user says "enough, write it up" (any phrasing), stop interviewing and
  draft immediately, marking unknowns as `[assumption: …]`.
- Never lose a draft: if an export fails, print the full markdown so the user
  can copy it.

## Phase 0 — Load configuration and templates

1. Read `~/.claude/flamingo/config.md` if it exists. It may define: default
   output language, default tracker, default Linear team and project. Missing
   file or missing keys → defaults: output language = the language the idea was
   written in; tracker = ask at export time. Example:

   ```
   output language: English
   tracker: linear
   linear team: Growth
   linear project: Onboarding revamp
   ```
2. Collect templates: built-in ones in `templates/` next to this SKILL.md, plus
   user templates in `~/.claude/flamingo/templates/`. A user template whose
   `name` matches a built-in replaces it.
3. Each template's frontmatter defines: `name`, `description`, `depth`
   (quick|standard|deep), `target` (issue|project|initiative). HTML comments
   in the body are interviewer guidance — never include them in any output.

## Phase 1 — Get the idea and pick a format

- The idea is the skill argument. A leading language-code prefix (`en: `,
  `cs: `, `de: `, …) overrides the output language. No argument → ask for the
  idea first, as a single open question.
- If the idea clearly implies a format (a crash or wrong behavior → bug-report;
  a large multi-part initiative → epic or project-brief; a single capability →
  user-story), propose that template and confirm. Otherwise present the
  template list (each `name` + `description`) via AskUserQuestion.

## Phase 1.5 — Codebase analysis (conditional)

If the idea describes changing, fixing, or extending the behavior of software
whose code plausibly lives in the current working directory (quick check:
source files or a project manifest are present and the idea's domain matches),
read `references/codebase-analysis.md` next to this SKILL.md and follow it
before interviewing. Otherwise skip this phase entirely — the flow is
unchanged. When unsure, skip; a generic interview beats a misleading scan.

## Phase 2 — Adaptive interview

Depth comes from the chosen template's `depth`:

- `quick` — at most 2–3 questions, only on gaps that block a useful item (see
  the template's interviewer comment). Do not grill.
- `standard` — cover each template section the idea doesn't already answer.
  Typically 3–6 questions.
- `deep` — thorough grilling: goals, non-goals, scope boundaries, risks,
  success criteria, decomposition. Challenge vague answers ("everyone" is not
  a user; "soon" is not a deadline). Typically 6–12 questions, still one at a
  time.

Rules:
- One question per message, most important gap first.
- Never ask about something the idea already states — restate it back instead.
- Track template sections left unanswered; they become `[assumption: …]` lines
  in the draft.
- With codebase-analysis findings available, prefer informed questions that
  name the real modules over generic ones, and ground proposed child issues
  in the code's actual structure (see the reference's "Use the findings").

## Phase 3 — Draft and refine

1. Fill the template body in the output language, translating section headings
   into that language as well. Drop sections that are genuinely inapplicable
   instead of leaving placeholders. Mark guesses as `[assumption: …]`. Even
   when headings are translated, each remaining section still corresponds to
   the same section in the template — export logic (see
   `references/linear.md`) matches sections by that template correspondence,
   never by the rendered heading text.
2. Show the complete draft as a fenced markdown preview.
3. Ask whether to approve or what to change. Every edit request produces an
   updated full preview. Iterate until the user approves.

## Phase 4 — Export

After approval, offer destinations, config default first:

- **Linear** — read `references/linear.md` next to this SKILL.md and follow it.
- **Jira** — read `references/jira.md` and follow it.
- **Markdown** — print the final document; offer to save it to a file the user
  names. Always available, and the fallback whenever a tracker is unreachable.

After a successful tracker export, report the created item's URL(s).

After the first successful export of any kind — Linear, Jira, or markdown —
if `~/.claude/flamingo/config.md` does not exist yet, offer once to create it
with the choices just used (output language, tracker, team/project) as
defaults — write it only if the user agrees.
