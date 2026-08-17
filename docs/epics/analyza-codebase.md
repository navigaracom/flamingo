# Analýza codebase ve flamingu

## Cíl
Flamingo při zpracování nápadu, který se týká kódu v aktuálním repozitáři, samo
rozpozná relevanci a provede rychlý read-only průzkum codebase. Nálezy využije
dvěma způsoby: v rozhovoru klade informované otázky (místo obecných) a navrhuje
dekompozici na child issues odpovídající reálné struktuře kódu.

## Proč teď
Strategický krok evoluce flaminga — nejde o reakci na akutní bolest, ale o
další logický krok ke zvýšení kvality výstupů u nápadů vázaných na kód.

## Non-goals
- Žádná samostatná technická sekce (soubory/moduly) ve výstupním work itemu —
  analýza slouží výhradně rozhovoru a dekompozici.
- Žádné odhady pracnosti, složitosti ani story pointů.
- Žádné změny kódu — analýza je striktně read-only.
- Analyzuje se jen aktuální repo; externí repa, sousedé v monorepu ani
  závislosti mimo pracovní adresář ne.

## Rozsah
- Detekce relevance nápadu vůči kódu v aktuálním adresáři — při nerelevanci se
  analýza přeskočí a tok zůstává beze změny.
- Rychlý (~30–60 s) read-only průzkum přes subagenta: struktura repa, dotčené
  moduly, existující podobná funkcionalita.
- Propojení nálezů do fáze rozhovoru a do návrhu child issues v draftu.
- [assumption: implementačně půjde o úpravu SKILL.md a nový reference soubor,
  podle zavedeného vzoru repa spec → SKILL.md → reference → testovací scénář]

## Child issues
- Detekce relevance — logika, která pozná, že se nápad týká kódu v aktuálním
  repu, a rozhodne o spuštění analýzy
- Rychlý průzkumný agent — read-only průzkum repa (struktura, dotčené moduly,
  existující podobná funkcionalita) a formát výstupu nálezů
- Napojení na rozhovor — informované otázky vycházející z nálezů
- Napojení na dekompozici — návrh child issues v draftu vychází z reálné
  struktury kódu

## Rizika a otevřené otázky
- Chybná detekce relevance: analýza se spustí u nerelevantního nápadu
  (zbytečné zdržení), nebo se naopak nespustí u relevantního.
- Zavádějící nálezy: povrchní průzkum vrátí špatný obrázek o kódu a rozhovor
  či dekompozice povedou špatným směrem.
- Závislost na prostředí: skill musí fungovat i tam, kde read-only subagent
  není k dispozici — je potřeba fallback.

## Kritéria úspěchu
- Nový pressure-scenario test v repu ověří celý tok (relevantní nápad →
  analýza → informovaný rozhovor → dekompozice dle kódu) a projde.
