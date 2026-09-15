# Life Organizer – Projektgerüst (Phase 0 & 1-Start)

## Setup

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

Der zweite Befehl generiert `lib/core/database/database.g.dart` aus den
Drift-Tabellen (`household_tasks.dart`, `routines.dart`). Diese Datei ist
absichtlich **nicht** manuell erstellt – sie entsteht automatisch und sollte
nach jeder Änderung an den Tabellen neu generiert werden.

```bash
flutter run
```

## Was ist enthalten

- `lib/core/theme/` – Farbsystem, Spacing-Skala, ThemeData (Phase 0)
- `lib/core/database/` – Drift-Setup + Tabellen für Modul 1 & 3
- `lib/shared/utils/status_calculator.dart` – zentrale, wiederverwendbare
  Intervall-Statuslogik (grün/gelb/rot)
- `lib/shared/widgets/` – `StatusPill`, `IntervalProgressBar`,
  `QuickActionButton` – die drei Bausteine, die in Modul 1, 3, 4 und 6
  wiederverwendet werden
- `lib/main.dart` – Demo-Screen, zeigt die Komponenten an einer
  Beispiel-Aufgabe

## Update: Repository + Provider + echte Screens (fertig)

- `features/haushalt/data/household_task_repository.dart` – CRUD +
  `markCompleted` / `undoLastCompletion` (Undo via Snackbar statt
  Bestätigungsdialog, bewusst Low-Friction)
- `features/haushalt/application/` – Riverpod-Provider, die den
  DB-Stream mit `status_calculator.dart` kombinieren und nach
  Dringlichkeit sortieren
- `features/haushalt/presentation/household_screen.dart` – echte,
  reaktive Aufgabenliste (ersetzt die alte Demo-Card)
- `features/routinen/` – analog: Repository mit Toggle-Logik pro Tag
  (JSON-kodierte Item-IDs) + Streak-Berechnung, Provider, Screen mit
  Checkliste und Streak-Badge
- `main.dart` – `ProviderScope` + einfache 2-Tab-Navigation
  (Haushalt / Routinen)

**Wichtig:** Weder `HouseholdTasks` noch `Routines` haben aktuell einen
"Neue Aufgabe/Routine anlegen"-Dialog – die FAB in `household_screen.dart`
ist noch ein Platzhalter (`onPressed: () {}`). Ohne diesen Dialog bleiben
die Listen leer. Das ist der nächste sinnvolle Schritt.

## Update: Phase 2 – Brain Dump + Notfall-Modus (fertig)

- Neue Tabelle `BrainDumpEntries` (`core/database/tables/brain_dump.dart`) –
  **wichtig: dafür muss `build_runner` erneut laufen**, sonst fehlen die
  generierten Klassen (`BrainDumpEntry`, `BrainDumpEntriesCompanion`).
- `features/brain_dump/` – Repository, Provider, sowie
  `BrainDumpCapture` (immer sichtbares Eingabefeld) und `BrainDumpList`
  (offene Notizen, Fokus bleibt nach dem Absenden im Feld für schnelles
  Nacheinander-Eintippen)
- `features/notfall/` – kuratierte Liste winziger Mikro-Aufgaben
  (bewusst NICHT an echte Tasks gekoppelt, um nicht selbst zu
  überfordern) + Vollbild-Screen ohne Navigation
- Neuer **Start-Tab** (`features/start/presentation/start_screen.dart`)
  als erster Tab: Notfall-Button oben, darunter Brain-Dump-Eingabe und
  offene Notizen. Haushalt/Routinen sind jetzt Tab 2 und 3.

## Nach dem Update ausführen

```bash
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## Update: Phase 3 – Kühlschrank-/Vorratsmanager (fertig)

- Neue Tabelle `PantryItems` (`core/database/tables/pantry.dart`) mit
  `expiryDate` (MHD), optional `openedAt` + `daysGoodAfterOpening` –
  **auch hier: `build_runner` erneut laufen lassen.**
- `shared/utils/pantry_status_calculator.dart` – berechnet das
  effektive Ablaufdatum als Minimum aus MHD und "geöffnet am + X Tage"
  (falls zutreffend) und nutzt denselben `TaskStatus`-Enum wie
  Modul 1, damit `StatusPill` unverändert weiterverwendet wird
- `features/vorrat/` – Repository (inkl. `markOpened()` als
  Ein-Klick-Aktion), Provider (sortiert nach am wenigsten Resttagen),
  Screen mit Presets (Milch, Joghurt, Käse, ...) inkl. hinterlegter
  Öffnungsfristen
- Vierter Tab "Vorrat" in der Navigation

## Nach dem Update ausführen

```bash
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## Update: Phase 4 – Kontaktbuch/Social CRM (fertig)

- Neue Tabelle `Contacts` (`core/database/tables/contacts.dart`) –
  **wieder: `build_runner` erneut laufen lassen.**
- `contact_with_status.dart` nutzt `calculateIntervalStatus()` aus
  Modul 1 unverändert wieder ("zuletzt kontaktiert" + Intervall ist
  strukturell dasselbe wie "zuletzt erledigt" + Putz-Intervall)
- `features/kontakte/` – Repository, Provider (Kontakte mit
  Erinnerungsintervall zuerst nach Dringlichkeit, Kontakte ohne
  Intervall alphabetisch danach), Liste mit "Jetzt kontaktiert",
  Anlege-Dialog (Name, Notizen, Geburtstag, Intervall-Slider,
  Default 14 Tage) und ein Detailscreen mit frei editierbaren Notizen
  (autosave beim Verlassen des Feldes) und Löschen-Option
- Fünfter Tab "Kontakte" in der Navigation

**Hinweis zur Navigation:** Fünf Tabs sind spürbar mehr als die
ursprünglichen zwei – das steht in einem gewissen Spannungsverhältnis
zum "klickarm/reizarm"-Prinzip. Wert, das im Blick zu behalten, sobald
Modul 5 und 6 dazukommen (siehe "Offene nächste Schritte").

## Nach dem Update ausführen

```bash
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## Update: Phase 5 – Budgetierung (fertig) + Navigations-Umbau

- Neue Tabellen `Envelopes` + `EnvelopeTransactions`
  (`core/database/tables/budget.dart`), Beträge als **Integer-Cents**
  gespeichert (kein Float), um Rundungsfehler bei Geld auszuschließen
  – **wieder: `build_runner` erneut laufen lassen.**
- `shared/utils/money_format.dart` – Umrechnung Cents ↔ deutsche
  Anzeige ("12,34 €")
- `shared/utils/envelope_status_calculator.dart` – Statusfarbe nur,
  wenn ein optionales Ziel-Budget gesetzt ist; ohne Ziel nur nackter
  Saldo, keine Bewertung
- `features/budget/` – Repository (Saldo + Buchung immer in einer
  Transaktion), "Gehalt verteilen"-Flow (Gesamtbetrag eingeben, live
  auf Umschläge aufteilen, Restanzeige), Ausgabe-Schnelldialog,
  Detailscreen mit den letzten 10 Buchungen (bewusst keine volle
  Historie)
- **Navigation umgebaut:** Statt eines 5./6. Tabs gibt es jetzt einen
  "Mehr"-Tab, der Vorrat, Kontakte und Budget als Liste bündelt.
  Bottom-Nav bleibt bei 4 Einträgen (Start, Haushalt, Routinen, Mehr),
  auch wenn weitere Module dazukommen.

## Nach dem Update ausführen

```bash
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## Update: Lila-Pink-Reskin + Phase 6 – Gesundheit (fertig)

- `core/theme/app_colors.dart` auf gedämpfte Lila-Pink-Töne
  umgestellt (Hintergrund, Flächen, Akzentfarbe). **Bewusst NICHT**
  angetastet: die Status-Ampel Grün/Gelb/Rot – das bleibt das
  wichtigste Signal der App und sollte visuell konsistent bleiben.
- Neue Tabellen `HealthAppointments`, `Medications`,
  `MedicationIntakeLogs` (`core/database/tables/health.dart`) –
  **wieder: `build_runner` erneut laufen lassen.**
- `features/gesundheit/` mit zwei Tabs:
  - **Termine**: nutzt dieselbe Intervall-Statuslogik wie Modul 1 &
    Kontakte, Detailscreen mit Notizfeld "Was muss ich fragen/sagen?"
    (autosave beim Verlassen des Feldes)
  - **Medikamente**: Einnahme-Tracker mit Tages-Zähler ("2 von 3
    heute"), Fortschrittsbalken, "Genommen"-Button bis zum Tagesmaximum,
    setzt sich am nächsten Tag automatisch zurück
- Gesundheit als vierter Eintrag im "Mehr"-Bereich (keine neue
  Bottom-Nav-Tab nötig)

**Damit ist der ursprüngliche Modulplan (1–6) inhaltlich komplett.**
Was fehlt, ist Phase 7: "Wo liegt was?"-Suche, App-weite Suchleiste,
Politur/Performance.

## Nach dem Update ausführen

```bash
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## Update: Phase 7 – "Wo liegt was?" + App-weite Suche (fertig)

- Neue Tabelle `StorageLocations` (`core/database/tables/storage_locations.dart`)
  – **wieder: `build_runner` erneut laufen lassen.**
- `features/wo_liegt_was/` – simple Gegenstand-zu-Ort-Zuordnung mit
  eigenem Suchfeld direkt auf dem Screen (lokal, kein globaler Bezug)
- `features/suche/` – app-weite Suche über Haushalt, Vorrat, Kontakte,
  Budget, Termine, Medikamente und Wo-liegt-was gleichzeitig.
  Erreichbar über das Lupe-Icon oben rechts auf dem Start-Screen.
  Tippen auf ein Ergebnis öffnet die passende Detailansicht
  (Kontakte/Termine/Budget) bzw. die jeweilige Modul-Übersicht
  (Haushalt/Vorrat/Medikamente, da diese keine Einzel-Detailansicht
  haben)
- "Wo liegt was?" zusätzlich als Eintrag im "Mehr"-Bereich

**Damit ist der komplette ursprüngliche Modulplan (Phase 0–7)
inhaltlich umgesetzt.** Was jetzt noch fehlt, ist kein neues Modul
mehr, sondern Feinschliff – siehe unten.

## Nach dem Update ausführen

```bash
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## Realistischer Blick auf den Gesamtstand

Dieser gesamte Code wurde ohne Flutter-SDK geschrieben (siehe oben)
und ist entsprechend ungetestet in dem Sinn, dass nie kompiliert
wurde. Bevor sich "fertig" richtig anfühlt, lohnen sich typischerweise:

- Ein kompletter Durchlauf aller Screens auf dem Handy, gezielt nach
  Abstürzen/Exceptions suchend (besonders Nullable-Felder, leere
  Listen, Navigation nach Löschen eines Eintrags)
- `flutter_local_notifications`-Integration ist im Plan vorgesehen,
  aber in keinem der Module tatsächlich verdrahtet – Fälligkeiten
  werden bisher nur beim Öffnen der App sichtbar, nicht proaktiv
  gemeldet
- App-Icon, Splash Screen, Android-App-Name (aktuell Platzhalter aus
  dem Flutter-Grundgerüst)

## Update: Feedback-Runde (Bugs, Umbenennungen, Notizen, Historie/Streak, Fotos, Zutatenplaner, Kassenbon)

**Bugfixes:**
- Debug-Banner ausgeblendet (`debugShowCheckedModeBanner: false`)
- ALLE Anlege-Sheets scrollbar gemacht (Tastatur-Overflow-Fix,
  betraf nicht nur Kontakte)

**Umbenennungen:**
- App-Name (intern) → "Vergissmeinnicht"
- Notfall-Button → "ALARRRM", Mikroaufgaben-Liste erweitert
- Start-Titel → "Hey du 🌸"
- Kontakte → "Lenas Grüne Seiten"

**Neue Tabellen-Felder** (wieder: `build_runner` erneut laufen lassen):
- `BrainDumpEntries`: `category`, `priority`, `pinned`
- `HealthAppointments`: `institution`, `address`
- `Contacts`, `StorageLocations`: `photoPath`

**Notizen (Brain Dump) überarbeitet:** größeres Feld, Kategorie-Chips,
Prioritäts-Auswahl (Farbpunkt), Anheften (immer oben sortiert)

**Haushalt:** Bearbeiten-Dialog, Historie-Screen (alle Erledigungen),
zufällige Aufmunterungs-Emojis

**Erfolge-Wiese:** 🐄-Emoji-Sammlung für jede erledigte Aufgabe/Routine,
sichtbar auf dem Start-Screen (`features/gamification/`)

**Fotos:** Kontakte (Avatar, antippbar) und Wo-liegt-was (Thumbnail)
können jetzt ein Bild aus der Galerie zugewiesen bekommen
(`shared/utils/image_storage.dart`, Paket `image_picker` neu in
pubspec.yaml – **`flutter pub get` nicht vergessen**)

**Zutatenplaner** (`features/zutatenplaner/`): Zutaten eintippen,
Abgleich gegen Vorrats-Namen (nur Namens-Abgleich, KEINE
Mengen-Rechnung – PantryItems speichert keine Mengen), erstellt bei
Bedarf eine Notiz mit fehlenden Zutaten

**Kassenbon-Flow** (`features/vorrat/presentation/receipt_scan_screen.dart`):
bewusst OHNE echte Texterkennung – Foto dient nur als
Gedächtnisstütze, Artikel werden manuell in Schnellform eingetragen,
alle mit demselben einstellbaren Standard-MHD

## Nach dem Update ausführen

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## Noch offen aus der Feedback-Runde

- **App-Icon (lila Vergissmeinnicht) + Android-Anzeigename ändern**:
  Das kann ich nicht direkt in diesem Projekt-Export erledigen, weil
  die `android/`- und `ios/`-Ordner nicht Teil dieses ZIPs sind (sie
  entstehen erst durch `flutter create .`, was du vermutlich schon
  einmal lokal gemacht hast, damit die App überhaupt läuft). Sag mir
  kurz, ob dein lokaler Ordner einen `android/`-Unterordner hat –
  dann gebe ich dir eine präzise Schritt-für-Schritt-Anleitung
  (Paket `flutter_launcher_icons` + eine Zeile in der
  AndroidManifest.xml für den Namen).
- Tiefere MySpace-Optik über die Farben hinaus (verspieltere
  Typografie/Layout-Elemente)
- "Kleine Affektionen stehend" – falls das nicht "kleine
  Aufmunterungs-Emojis" meinte (die jetzt eingebaut sind), sag mir
  gern nochmal in anderen Worten, was genau gemeint war

## Update: App-Icon (lila Vergissmeinnicht) + Vorbereitung für Namensänderung

- `assets/icon/icon.png` – ein einfaches, selbst gezeichnetes lila
  Vergissmeinnicht-Icon (schlicht, kein Foto – falls dir ein anderer
  Stil vorschwebt, gib Bescheid, dann zeichne ich es anders)
- `pubspec.yaml`: Paket `flutter_launcher_icons` + Konfiguration
  ergänzt, die aus diesem einen Bild automatisch alle benötigten
  Android-Icon-Größen erzeugt

**So wird's aktiv (siehe Schritt-für-Schritt-Anleitung in der
Antwort):**
```bash
flutter pub get
dart run flutter_launcher_icons
```
Das schreibt direkt in deinen lokalen `android/`-Ordner (der nicht
Teil dieses ZIPs ist) – deshalb kann ich diesen Schritt nicht für
dich vorwegnehmen, er muss bei dir laufen.

**App-Name auf dem Homescreen** (`android/app/src/main/AndroidManifest.xml`)
kann ich nicht automatisiert ändern, da diese Datei nicht im ZIP
enthalten ist – eine Zeile von Hand editieren reicht aber aus, siehe
Anleitung.

## Update: Echte Fälligkeits-Benachrichtigungen + tiefere MySpace-Optik

**Benachrichtigungen sind jetzt verdrahtet** (`core/notifications/notification_service.dart`,
in `main.dart` beim App-Start initialisiert) – aber bewusst nur für
die drei Intervall-Module mit identischer Datenform:
- Haushalt: bei Anlegen/Erledigen/Rückgängig/Bearbeiten/Löschen wird
  die nächste Erinnerung neu geplant bzw. storniert
- Kontakte: gleiches Prinzip bei "Jetzt kontaktiert"
- Gesundheit-Termine: gleiches Prinzip bei "Termin wahrgenommen"

**NICHT verdrahtet** (andere Datenform, nicht in dieser Runde
angebunden): Medikamenten-Einnahme-Erinnerungen (mehrmals täglich zu
festen Zeiten – andere Planungslogik) und Vorrats-Ablaufwarnungen
(Tage-vor-MHD statt Intervall). Kann ich in einer nächsten Runde
ergänzen, wenn gewünscht.

**Wichtiger Hinweis, den ich nicht selbst prüfen kann:** Ich habe die
`zonedSchedule`-API nach der offiziellen Doku von
`flutter_local_notifications` ^17.2.2 geschrieben, konnte sie aber
mangels Flutter-SDK in dieser Umgebung nicht kompilieren. Falls beim
Bauen ein Fehler in `notification_service.dart` auftaucht, schick mir
die Fehlermeldung – das ist dann vermutlich eine kleine
API-Abweichung zur installierten Paketversion.

Außerdem composed Android ab Version 13 eine Laufzeit-Berechtigung
für Benachrichtigungen – die App fragt danach beim ersten Start
automatisch (via `requestNotificationsPermission()`). Falls dieser
Dialog nicht erscheint oder Benachrichtigungen stumm bleiben, prüf in
den Handy-Einstellungen unter "Apps → Vergissmeinnicht →
Benachrichtigungen", ob sie erlaubt sind.

**MySpace-Optik vertieft**: kräftige Lila-AppBar mit weißer,
fetter Schrift und abgerundeter Unterkante, Karten mit dezentem
pinkfarbenem Schlagschatten statt komplett flach, Buttons mit
farbigem Schatten-Glow, Chips durchgängig pillenförmig. Bewusst noch
mit Zurückhaltung bei Layout/Abständen – wenn dir das jetzt insgesamt
noch zu ruhig ist, sag konkret, an welcher Stelle es mehr knallen
soll (z.B. Farbverläufe statt Vollton, mehr Deko-Icons, andere
Schriftart).

## Nach dem Update ausführen

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## Offene nächste Schritte

1. "Neue Aufgabe"/"Neue Routine"-Dialog mit Preset-Schnellauswahl
   (Low-Friction: vorgefertigte Presets wie "Bad putzen · 7 Tage"
   antippbar, Freitext nur als Fallback)
2. `flutter_local_notifications`-Integration für fällige Aufgaben
3. Seed-Daten / erste Routine beim ersten App-Start anlegen, damit
   die App nicht leer startet
4. Ab hier: Modul 2 (Vorratsmanager) gemäß Phasenplan

## Ungetestet – bitte lokal prüfen

Dieser Code wurde in einer Umgebung ohne Flutter-SDK geschrieben und
konnte nicht kompiliert werden. Nach `flutter pub get` und
`build_runner build` können vereinzelt Typ- oder API-Anpassungen
nötig sein, insbesondere bei den Drift-Versionen aus der `pubspec.yaml`.
