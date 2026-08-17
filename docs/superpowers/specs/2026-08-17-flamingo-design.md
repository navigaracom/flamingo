# Flamingo — design

**Datum:** 2026-08-17
**Stav:** návrh ke schválení

## Účel

Flamingo je Claude Code plugin, který přetváří vágní nápady do strukturovaného zadání
(user story, bug report, epic, project brief…) formou adaptivního interview. Výsledek
uživateli ukáže jako náhled, nechá ho doladit, a po schválení ho založí v trackeru
(dnes Linear přes MCP; Jira připravena na později) nebo vydá jako markdown.

## Rozhodnutí z brainstormingu

- **Výstup:** vždy nejdřív náhled + iterativní ladění; export do trackeru až po schválení.
- **Formáty:** vestavěné šablony + vlastní uživatelské šablony (vlastní přepisují vestavěné).
- **Interview:** adaptivní hloubka podle cílového formátu (bug = 2–3 otázky, epic = důkladné grilování).
- **Jazyk:** výchozí jazyk výstupu v configu, override argumentem; interview probíhá v jazyce uživatele.
- **Balení:** od začátku struktura pluginu (název **flamingo**), pro vývoj symlink skillu
  do `~/.claude/skills/`, aby se změny projevily okamžitě.

## Struktura repa

```
flamingo/                          ← toto repo
  .claude-plugin/
    plugin.json                    ← manifest: name "flamingo", verze, popis
  skills/
    flamingo/
      SKILL.md                     ← celý workflow
      templates/                   ← vestavěné šablony
        user-story.md
        bug-report.md
        epic.md
        project-brief.md
      references/
        linear.md                  ← mapování polí šablon na Linear MCP tooly
        jira.md                    ← postup pro Jiru (dnes fallback na markdown)
  docs/superpowers/specs/          ← tento dokument
```

Vývojový symlink: `~/.claude/skills/flamingo → <repo>/skills/flamingo`.
Vyvolání: `/flamingo <nápad>`.

Distribuce později: přidat `marketplace.json`, kolegové instalují přes `/plugin`.
Obsah skillu se přitom nemění.

## Uživatelská data (mimo repo i plugin)

`~/.claude/flamingo/`:

- `config.md` — výchozí jazyk výstupu, výchozí tracker, výchozí Linear team/projekt.
- `templates/*.md` — vlastní šablony; soubor se stejným názvem jako vestavěná šablona ji přepíše.

Důvod oddělení: update pluginu přepíše jeho cache, uživatelův config a šablony musí přežít.
Pokud config neexistuje, skill funguje s rozumnými defaulty (jazyk výstupu = jazyk vstupu,
tracker se vybere při exportu) a na konci prvního běhu nabídne config založit.

## Formát šablon

Markdown s frontmatter; frontmatter řídí interview i export:

```markdown
---
name: user-story
description: Uživatelský příběh s akceptačními kritérii
depth: standard          # quick | standard | deep — hloubka interview
target: issue            # issue | project — co se v trackeru založí
---
## Story
Jako <role> chci <cíl>, abych <přínos>.

## Akceptační kritéria
- …
```

- `depth: quick` — 2–3 otázky jen na kritické mezery (typicky bug-report).
- `depth: standard` — pokrytí všech sekcí šablony (user-story).
- `depth: deep` — grilování à la grill-me: cíle, ne-cíle, scope, rizika,
  akceptační kritéria, edge cases (epic, project-brief).

Tělo šablony je kostra výstupu; komentáře `<!-- -->` v těle mohou nést
pokyny pro tazatele (na co se ptát, co je povinné) a do výstupu se nedostanou.

## Workflow skillu

1. **Vstup.** `/flamingo <nápad>`; bez argumentu se zeptá na nápad.
   Override jazyka výstupu prefixem, např. `/flamingo en: …`.
2. **Volba formátu.** Načte config a šablony (vestavěné ∪ vlastní). Pokud formát
   jasně plyne ze vstupu, navrhne ho k potvrzení; jinak nabídne výběr (AskUserQuestion).
3. **Interview.** Otázky po jedné, kde to jde s možnostmi na výběr, v jazyce, kterým
   uživatel píše. Hloubka dle `depth`. Uživatel může kdykoli říct „stačí, sepiš to" —
   nezjištěné informace draft explicitně označí jako `[domněnka: …]`.
4. **Draft a ladění.** Vyplní šablonu v jazyce výstupu, ukáže náhled, iteruje
   podle připomínek, dokud uživatel neschválí.
5. **Export.** Nabídne cíle:
   - **Linear** (MCP): `save_issue` / `save_project` podle `target`; team/projekt
     z configu, jinak dotazem (`list_teams` / `list_projects`). Epic = parent issue
     s pod-issues, pokud interview identifikovalo dílčí kroky. Vrátí URL.
   - **Jira**: dnes bez MCP → fallback na markdown s poznámkou, že po připojení
     Jira MCP půjde zakládat přímo (postup v `references/jira.md`).
   - **Markdown**: vypsat / uložit do souboru — funguje vždy, i bez jakéhokoli MCP.

## Ošetření chyb

- Linear MCP nedostupné / selže → degradace na markdown výstup, nikdy ne ztráta draftu.
- Rozpracované interview: draft se průběžně drží v konverzaci; skill nikdy nezakládá
  nic v trackeru bez explicitního schválení náhledu.

## Testování

Podle superpowers:writing-skills (TDD pro skilly): pressure scénáře se subagenty —
(a) vágní jednověté zadání → bug-report, (b) velký nápad → epic s grilováním,
(c) česky psaný vstup + anglický výstup dle configu, (d) export bez dostupného
Linear MCP. Baseline bez skillu → skill → ověření compliance.

## Mimo rozsah (YAGNI)

- Přílohy a obrázky.
- Hromadné zakládání nesouvisejících issues (kromě epic → pod-issues).
- Synchronizace zpět z trackeru do dokumentu.
- Přímá integrace Jira REST API s API klíči — až bude reálná potřeba.
