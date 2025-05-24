# Test kalendářové integrace

## Co bylo změněno:
1. ✅ **Přidán plugin `add_2_calendar`** - nativní integrace s kalendářem
2. ✅ **Nahrazena web implementace** - místo otevírání webového prohlížeče se nyní otevře nativní kalendářová aplikace
3. ✅ **Přidána iOS oprávnění** - `NSCalendarsUsageDescription` v Info.plist
4. ✅ **Vylepšena zprávy o úspěchu/chybě** - uživatel dostane jasnou zpětnou vazbu

## Jak testovat:
1. Spusťte aplikaci na iOS simulátoru nebo zařízení
2. Přejděte na detail některé události
3. Stiskněte tlačítko "Přidat do kalendáře" na Info tabu
4. **OČEKÁVANÝ VÝSLEDEK**: 
   - Otevře se nativní kalendářová aplikace iOS
   - Zobrazí se formulář pro vytvoření nové události s předvyplněnými údaji
   - Po potvrzení se zobrazí zelený snackbar s potvrzením

## Funkce kalendářové integrace:
- ✅ **Nativní kalendář**: Používá iOS Calendar app místo webového prohlížeče
- ✅ **Předvyplněné údaje**: Název, popis, datum, čas, místo
- ✅ **Připomínka**: Automaticky nastavena 15 minut před událostí
- ✅ **URL**: Obsahuje odkaz na detail události v aplikaci
- ✅ **Zpětná vazba**: Snackbar s informací o úspěchu/neúspěchu

## Technické detaily:
- **Plugin**: `add_2_calendar: ^3.0.1`
- **iOS oprávnění**: `NSCalendarsUsageDescription` 
- **Podporované platformy**: iOS, Android
- **Fallback**: Pokud se nepodaří přidat do kalendáře, zobrazí se chybová zpráva

---
*Poznámka: Na iOS simulátoru může být kalendářová aplikace omezena. Pro plné testování doporučujeme fyzické zařízení.*
