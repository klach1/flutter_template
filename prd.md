# Dokument požadavků na projekt: Platforma pro správu událostí

| ID požadavku | Popis | Uživatelský příběh | Očekávané chování |
|--------------|-------|--------------------|-------------------|
| **ZOBRAZENÍ SEZNAMU UDÁLOSTÍ** |
| FR001 | Zobrazení karet událostí | Jako uživatel chci vidět události zobrazené jako karty, abych mohl snadno procházet dostupné události. | Systém zobrazí události v rozložení založeném na kartách s konzistentním rozestupem a vizuální hierarchií. |
| FR002 | Obsah karty události | Jako uživatel chci, aby každá karta události zobrazovala základní informace (fotku, lokaci, datum, čas). | Každá karta bude obsahovat fotografii události, text lokace, datum a čas ve čitelném formátu. |
| FR003 | Počet účastníků | Jako uživatel chci vidět počet přihlášených účastníků. | Na fotografii události bude přeškrtnutá ikona uživatele s počtem účastníků (např. „12/20“). |
| FR004 | Počet pilotů | Jako uživatel chci vidět počet dostupných pilotů. | Na fotografii události bude ikona dronu s počtem pilotů (např. „3/5“). |
| FR005 | Akční tlačítka | Jako uživatel chci mít možnost přihlášení a zobrazení detailu. | Každá karta bude obsahovat tlačítka „Přihlásit“ a „Zobrazit detail“. |
| **FILTRACE A NAVIGACE** |
| FR006 | Filtrace podle kategorií | Jako uživatel chci filtrovat události podle kategorií. | Nad seznamem událostí budou filtrační čipy: **Přihlášené, Spolkové, Otevřené**. |
| FR007 | Filtrace podle data | Jako uživatel chci filtrovat události podle časového rozmezí. | Systém umožní výběr data pomocí pole „Od“ a „Do“ s kalendářním výběrem. |
| FR008 | Reset filtrů | Jako uživatel chci jednoduše resetovat nastavené filtry. | Vedle filtračních polí bude červený křížek, kterým lze resetovat výběr. |
| FR009 | Přepnutí na mapu | Jako uživatel chci vidět události na mapě. | Tlačítko „Mapa“ v horní liště přepne zobrazení na mapový pohled. |
| FR010 | Návrat do seznamu | Jako uživatel chci se vrátit ze mapy zpět do seznamu. | V mapovém režimu bude tlačítko „Zpět na seznam“. |
| FR011 | Vytvoření události | Jako organizátor chci vytvářet nové události. | V dolní části stránky bude plovoucí tlačítko „Vytvořit událost“. |
| **DETAIL UDÁLOSTI** |
| FR012 | Navigace na detail | Jako uživatel chci vidět podrobnosti o události. | Klepnutím na „Zobrazit detail“ se otevře detailní stránka události. |
| FR013 | Záložky v detailu | Jako uživatel chci přepínat mezi sekcemi detailu události. | Detail bude obsahovat **záložky (tab bar)** s 4 sekcemi: **Info, Chat, Uživatelé, Poznámky**. |
| **ZÁLOŽKA INFO** |
| FR014 | Základní informace | Jako uživatel chci vidět všechny podstatné údaje o události. | Karta bude obsahovat mapu s pozicí, název události, adresu, datum/čas a popis. |
| FR015 | Přidání do kalendáře | Jako uživatel chci si událost uložit do kalendáře. | Tlačítko „Přidat do kalendáře“ otevře import události z aktuálních údajů do výchozího kalendáře uživatele (ICS). |
| FR016 | Editace informací | Jako organizátor chci upravovat detaily události. | Tlačítko „Upravit“ otevře dialog pro změnu základních údajů. |
| FR017 | Přehled úkolů | Jako organizátor chci sledovat stav příprav. | Sekce „Úkoly“ zobrazí stav ve formátu „X/Y splněno“. |
| FR018 | Seznam úkolů | Jako organizátor chci spravovat jednotlivé úkoly. | Výpis úkolů bude obsahovat: **Dostatek dobrovolníků, Pilot zajištěn, Drone zajištěný, Krabice zajištěny** s přepínači. |

---

## **Nefunkční požadavky**

| ID | Kategorie | Požadavek | Měření |
|----|-----------|-----------|--------|
| NFR1 | Lokalizace | Všechny texty v aplikaci musí být v češtině | 100% překlad rozhraní |
| NFR2 | Výkon | Načtení seznamu událostí do 2s | Lighthouse skóre ≥90 |
