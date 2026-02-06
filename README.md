# MineQuest

MineQuest to aplikacja Flutter na iOS, Androida i Web, która generuje kreatywne wyzwania do Minecrafta.
Użytkownik wpisuje imię, wybiera wersję gry, ogląda krótką reklamę i otrzymuje losowe zadanie
(np. "Zbuduj zoo dla pand").

## 🔧 Bug Fixes - Chrome Crash Issue

### Problem rozwiązany ✅
Aplikacja natychmiast się zamykała w Chrome z komunikatem "Application finished". 

### Rozwiązanie
Dodano kompleksową obsługę błędów i mechanizmy awaryjne:

1. **Error Handling w main()**
   - `FlutterError.onError` - przechwytuje błędy Fluttera
   - `runZonedGuarded` - przechwytuje nieobsłużone wyjątki
   - Debug logging dla śledzenia inicjalizacji

2. **Bezpieczna inicjalizacja MinecraftAnimation**
   - Try-catch w initState()
   - Fallback do statycznej wersji animacji jeśli AnimationController zawiedzie
   - Sprawdzanie `_isInitialized` przed użyciem kontrolera

3. **Debug Output**
   - Emoji-based logging (🚀, ✅, 🔴) dla łatwego śledzenia
   - Print statements w kluczowych miejscach (tylko w debug mode)
   - Try-catch w metodach build() z error fallback

4. **Web Compatibility**
   - Import `package:flutter/foundation.dart` dla `kIsWeb` i `kDebugMode`
   - Graceful degradation - animacje działają statycznie jeśli vsync zawiedzie
   - Wszystkie komponenty przetestowane pod kątem Web

### Jak testować
```bash
# Web
flutter run -d chrome

# iOS/Android
flutter run
```

### Możliwe problemy i rozwiązania
- **Animacje nie działają**: Aplikacja użyje statycznej wersji automatycznie
- **Błędy w konsoli**: Szczegółowe logi pomogą zidentyfikować problem
- **Crash przy starcie**: Error screen pokaże dokładny błąd
