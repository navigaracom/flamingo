# Rozpracování podřízených položek v jednom běhu

## Cíl
Po schválení draftu, který obsahuje podřízené položky, flamingo nabídne jejich
rozpracování do plné podoby — každá vybraná položka projde vlastním rozhovorem
podle své šablony a vznikne z ní plný sub-draft. Rekurze pokračuje, dokud
uživatel chce. Export pak založí celý strom najednou, takže běh nikdy neskončí
prázdnými projekty s odkazem „spusť /flamingo per projekt".

## Proč teď
Naraženo v praxi — po exportu iniciativy vznikly projekty bez issues a rozpad
se musel dodělávat ručně dalšími běhy flaminga.

## Non-goals
- Hloubka rozhovoru se nestává uživatelskou volbou — `depth` zůstává konstantou
  šablony; sub-draft se řídí `depth` své vlastní šablony.
- Nabídka se neobjevuje u draftů bez podřízených položek.
- Rozhovor nad iniciativou nezačne issues vyžadovat — nucení do detailu během
  interview zůstává odmítnuté, mění se jen to, co následuje po draftu.
- Nedoplňuje se detail do objektů, které už v trackeru existují.

## Rozsah
- Nová fáze mezi schválením draftu a exportem: pokud schválený draft obsahuje
  sekci s podřízenými položkami (Projekty, Child issues), flamingo nabídne
  výběr, které z nich rozpracovat.
- Každá vybraná položka dostane vlastní rozhovor v hloubce dané `depth` své
  šablony (projekt → project-brief, issue → user-story) a vlastní schválený
  sub-draft.
- Rekurze bez pevného limitu: po každém sub-draftu se nabídne další úroveň,
  dokud uživatel neřekne dost.
- Export zpracuje celý strom v jednom průchodu.
- Šablona initiative i verification spec se upraví tak, aby prázdný seznam
  issues nepopisovaly jako očekávaný výsledek — místo odkazu na pozdější běh
  se odkazuje na nabídku po draftu.

## Child issues
- Fáze nabídky rozpracování — detekce podřízených položek ve schváleném draftu
  a výběr, které rozpracovat
- Rekurzivní smyčka sub-draftů — mapování položky na šablonu, mini-rozhovor
  v její `depth`, schválení a vnoření další úrovně
- Export celého stromu — rozšíření tří reference souborů (`linear.md`,
  `jira.md`, `akiflow.md`) o zakládání víceúrovňové hierarchie
- Ztrátovost hloubky — pravidlo pro případ, kdy je strom hlubší, než cílová
  platforma unese
- Aktualizace šablony initiative a verification specu — odstranit popis
  prázdného seznamu issues jako očekávaného chování

## Rizika a otevřené otázky
- Neomezená rekurze vs. tracker: strom může přesáhnout hloubku, kterou tracker
  unese (Akiflow zvládne tři úrovně) — je potřeba řešit ztrátovost.
- Kontext a přerušení: dlouhý strom draftů musí přežít v kontextu až do
  exportu; při přerušení hrozí ztráta rozpracované práce.
- Neúměrný export: jedno schválení může založit desítky objektů; chyba
  uprostřed exportu zanechá rozpracovaný strom.

## Kritéria úspěchu
- Iniciativa s projekty a issues vznikne v jediném běhu flaminga, bez nutnosti
  spouštět ho znovu.
- Pressure-scenario test v repu ověří nabídku rozpracování, rekurzi a export
  celého stromu a projde.
