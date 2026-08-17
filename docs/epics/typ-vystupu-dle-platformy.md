# Rozlišení typu výstupu podle cílové platformy

## Cíl
Flamingo bude při exportu vytvářet objekt odpovídající modelu cílové platformy,
ne jeden univerzální typ. Abstraktní `target` v šablonách zůstává beze změny;
překlad na konkrétní objekty si vlastní každý reference soubor — Linear
(initiative/project/issue), Jira (Epic/Story/Bug) a nový Akiflow (tasky se
subtasky). Součástí je plnohodnotný Akiflow exporter, který dnes neexistuje.

## Proč teď
Akiflow reálně používáte a flamingo do něj zatím neumí exportovat vůbec —
chybějící destinace je hlavním spouštěčem.

## Non-goals
- `target` se nemění na mapu per platforma ani nedostává per-platform override
  ve frontmatteru — kontrakt šablon (a uživatelských šablon, které přebíjejí
  vestavěné podle `name`) zůstává nedotčený.
- Volba trackeru se nepřesouvá před výběr šablony; tracker se stále vybírá až
  ve fázi exportu.
- Akiflow Projects flamingo nezakládá.
- Jira `target: initiative` a `target: project` se v tomto epicu neřeší —
  zůstávají v dnešním stavu.

## Rozsah
- Každý reference soubor si sám přeloží abstraktní `target` na objekty své
  platformy; SKILL.md zůstává tracker-agnostický.
- Jira: doplnit mapování na issue type — `epic.md` → Epic, `user-story.md` →
  Story, `bug-report.md` → Bug.
- Akiflow: nový exporter. Vše jde jako tasky, hierarchie přes `parent_task_id`;
  při exportu se nabídnou existující projekty (`list_projects`) pro zařazení.
- Ztrátový export: u šablon bohatších než cílová platforma flamingo předem
  varuje, co se sploští, a nabídne uložení plného markdownu jako zálohy.

## Child issues
- Překlad targetu v referencích — přesunout mapování abstraktního `target` do
  jednotlivých reference souborů a sjednotit jejich strukturu
- Jira issue type mapping — doplnit `references/jira.md` o volbu typu podle
  použité šablony
- Akiflow exporter — nový `references/akiflow.md`, tasky se subtasky přes
  `parent_task_id`, výběr existujícího projektu přes `list_projects`
- Napojení Akiflow do SKILL.md — nová destinace ve fázi exportu a s ní
  související uživatelský popis (README, plugin.json, description skillu)
- Varování o ztrátovosti — pravidlo pro export bohatého draftu do chudší
  platformy včetně nabídky markdown zálohy

## Rizika a otevřené otázky
- Ztrátovost Akiflow: bohatý draft se do tasku vejde jen jako text — i přes
  varování hrozí, že se struktura v praxi ztrácí.
- Dostupnost MCP: Akiflow ani Jira MCP nemusí být v prostředí připojené —
  je potřeba čistý fallback na markdown.

## Kritéria úspěchu
- Reálný export do Akiflow založí task s podtasky ve vybraném projektu a vrátí
  potvrzení.
- Pressure-scenario test v repu ověří překlad targetů pro všechny tři
  platformy a projde.
