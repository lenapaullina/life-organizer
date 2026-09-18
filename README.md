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

## Update: Feature-Runde (Aufgabe-Zerstückler, Würfel, Watchlist, Ausleihe, Audio-Brain-Dump, Erfolgs-Logbook)

Auch diese Runde wurde ohne Flutter-SDK geschrieben (siehe oben) – bitte
nach dem Einspielen einmal komplett durchklicken.

**"Aufgabe Zerstückler" (Micro-Task Splitter)** – `features/haushalt/micro_task_splitter.dart`
+ `features/haushalt/presentation/micro_task_splitter_sheet.dart`:
- Neuer Button (✨-Icon) auf jeder Haushaltsaufgaben-Karte öffnet ein
  Sheet, das die Aufgabe in 2-Minuten-Schritte zerlegt
- Bewusst OHNE echte KI/Netzwerk-Anbindung (App bleibt komplett
  lokal): feste Templates nach Stichwort im Aufgabennamen (Küche, Bad,
  Wohnzimmer, Wäsche, Müll, Schlafzimmer), sonst ein generischer
  Fallback, der für jede Aufgabe funktioniert
- "Eigene Schritte eintippen" als Alternative, falls kein Template
  passt (ein Schritt pro Zeile)
- Häkchen sind bewusst nur für die aktuelle Sitzung (keine neue
  Tabelle nötig); "Ganze Aufgabe erledigt" im Sheet ruft denselben
  `markCompleted`-Flow wie der normale "Heute erledigt"-Button auf

**"Random Task Generator" / Würfel-Button** – `features/haushalt/presentation/random_task_screen.dart`:
- Neues Würfel-Icon in der Haushalt-AppBar
- Wählt zufällig GENAU eine fällige/bald fällige Aufgabe (gelb/rot)
  aus und blendet den Rest komplett aus; gibt es nichts Fälliges,
  zählt jede Aufgabe
- "Andere Aufgabe würfeln" zum Neu-Würfeln, "Heute erledigt" direkt
  aus dem Vollbild-Screen heraus

**Watchlist-Erweiterung** – `features/watchlist/`:
- Komplett neues Modul (vorher gab es noch keine Watchlist im Code):
  Titel, "Wo streambar?" (Freitext) und Stimmungs-Tag (Comfort Show /
  Seichte Unterhaltung / Hohe Aufmerksamkeit)
- Filter-Chips oben im Screen, damit man bei Überreizung direkt nach
  Stimmung filtern kann statt zu suchen
- Erreichbar über "Watchlist" im "Mehr"-Bereich

**Ausleiher & Verliehen-Tracker** – `features/ausleihe/`:
- Neues Modul: Gegenstand, Person, Richtung (Verliehen/Geliehen),
  Datum, optionale Notiz, "Zurückgegeben"-Häkchen
- Filter-Chips (Alle/Verliehen/Geliehen), offene Einträge zuerst
- Erreichbar über "Ausleihe" im "Mehr"-Bereich

**Brain-Dump Audio-Notiz** – `features/brain_dump/presentation/brain_dump_widget.dart`:
- Neues Mikrofon-Icon direkt neben dem Absenden-Pfeil der
  Brain-Dump-Eingabe
- Nutzt das neue Paket `speech_to_text` (in `pubspec.yaml` ergänzt,
  Version ungeprüft – ggf. beim `flutter pub get` anpassen), spricht
  direkt in dasselbe Textfeld, Kategorie/Priorität/Absenden
  funktionieren danach wie beim Eintippen
- Android: `RECORD_AUDIO`-Berechtigung + `<queries>`-Eintrag für den
  Spracherkennungsdienst in `AndroidManifest.xml` ergänzt
- iOS: `NSMicrophoneUsageDescription` +
  `NSSpeechRecognitionUsageDescription` in `Info.plist` ergänzt
- Wichtig zu wissen: die eigentliche Spracherkennung läuft über den
  Sprachdienst des Betriebssystems (auf vielen Geräten on-device,
  auf manchen ggf. über einen Google-Dienst) – das liegt außerhalb
  der Kontrolle dieser App, genau wie bei jeder anderen App, die
  `speech_to_text` nutzt

**Dopamin-Speicher / Erfolgs-Logbook** – `features/gamification/presentation/success_logbook_screen.dart`:
- Neuer Screen, erreichbar über "Erfolgs-Logbook ansehen" unter der
  bestehenden "Deine Wiese"-Karte auf dem Start-Screen
- Fasst alle bisherigen Erfolge (erledigte Haushaltsaufgaben +
  komplett abgeschlossene Routinen) nach Monat gruppiert zusammen,
  neuester Monat zuerst: "Das hast du im September 2026 alles
  gerockt!"
- Nutzt ausschließlich bereits vorhandene Daten (Task-Completion-Logs,
  Routine-Completions) – keine neue Tabelle, keine doppelte
  Datenhaltung

**Technische Notiz zur Persistenz:** Watchlist und Ausleihe-Tracker
nutzen bewusst NICHT Drift/SQLite wie die anderen Module, sondern
einen einfachen neuen JSON-Datei-Store
(`core/storage/json_list_store.dart` + `json_backed_notifier.dart`).
Grund: eine neue Drift-Tabelle braucht einen `build_runner`-Lauf, der
die große generierte `database.g.dart` aktualisiert – das konnte in
der Umgebung, in der dieser Code geschrieben wurde, nicht ausgeführt
werden, und von Hand in dieser Datei zu editieren wäre sehr
fehleranfällig gewesen. Beide neuen Module sind dadurch genauso rein
lokal (keine Cloud, kein Netzwerk) wie der Rest der App, nur eben ohne
SQL. Falls gewünscht, können sie später bei Gelegenheit auf Drift
migriert werden.

## Nach dem Update ausführen

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## Update: "Version 2" – parallel zur alten App installierbar

Auf Wunsch installierbar, OHNE die bisherige App vom Handy zu
verdrängen (letztes Mal war das Update/Ersetzen der App auf dem Handy
umständlich):

- Android: `applicationId` in `android/app/build.gradle.kts` von
  `com.example.vergissmeinnicht` auf `com.example.vergissmeinnicht2`
  geändert; Anzeigename in `AndroidManifest.xml` auf
  "Vergissmeinnicht 2" gesetzt
- iOS: `PRODUCT_BUNDLE_IDENTIFIER` in `project.pbxproj` ebenso auf
  `com.example.vergissmeinnicht2`, Anzeigename in `Info.plist` auf
  "Vergissmeinnicht 2"
- `pubspec.yaml`-Version auf `0.2.0+2` erhöht

**Wichtig zu wissen:** Android/iOS behandeln eine andere App-ID als
komplett neue, eigenständige App – genau deshalb können beide Versionen
gleichzeitig auf dem Handy installiert sein, ohne sich zu
überschreiben. Das bedeutet aber auch: "Vergissmeinnicht 2" startet
mit einer **leeren** Datenbank (eigene App-Sandbox, kein Zugriff auf
die Daten der alten App) – Haushaltsaufgaben, Routinen, Kontakte usw.
müssen dort neu angelegt werden. Die alte App und ihre Daten bleiben
davon unberührt.

Sobald "Version 2" sich bewährt hat, kann bei Bedarf die
`applicationId` wieder zurückgeändert werden (dann ersetzt sie beim
nächsten Installieren die alte App inkl. Daten) – oder es wird
später eine Export/Import-Funktion für den Umzug der Daten ergänzt,
falls gewünscht.

## Update: MySpace/Y2K-Redesign (komplettes Theme umgestellt) + Bugfix

**Bugfix:** In der Brain-Dump-Eingabe konnte die Prioritäts-Zeile auf
schmalen Screens überlaufen, wodurch Mikro- und Senden-Button rechts
über den Bildschirmrand hinausragten. Die Prioritäts-Chips laufen
jetzt in einem eigenen, bei Bedarf horizontal scrollbaren Bereich
(`brain_dump_widget.dart`), Mikro- und Senden-Button bleiben immer
komplett sichtbar am rechten Rand.

**Redesign:** Die App läuft jetzt standardmäßig im dunklen
MySpace/Y2K-Look (Neon-Pink + Cyan auf sehr dunklem Grund) statt im
hellen Lila-Pink-Theme:

- `core/theme/app_colors.dart` – gleiche Feldnamen wie vorher (damit
  nichts an bestehenden Screens angepasst werden musste), aber neue
  Werte: dunkler Hintergrund, Neon-Pink als Hauptakzent, neues
  `accentCyan` als zweiter Akzent, Status-Ampel (Grün/Gelb/Rot) als
  Neon-Variante
- `core/theme/app_spacing.dart` – Card-/Button-Radien kantiger (8/6
  statt 16/12)
- `core/theme/app_theme.dart` – `AppTheme.light` durch `AppTheme.dark`
  ersetzt (dickere, farbige Ränder statt weicher Schatten, Neon-Glow
  auf Überschriften, Cyan-Fokusrahmen bei Eingabefeldern); in
  `main.dart` als Standard-Theme eingetragen
- Da Farben/Radien zentral über Token laufen, übernehmen alle
  bestehenden Screens den neuen Look automatisch, ohne dass sie
  einzeln angefasst werden mussten

**Neue wiederverwendbare Komponenten** (`shared/widgets/`):
- `MySpaceCard` – Profilmodul-Optik mit farbigem Header-Balken + Titel
- `MySpaceButton` – Retro-Button mit dickem Rand + Neon-Glow
- `MySpaceBadge` – Tag/Badge im Forum-"Blinkie"-Stil

**Beispiel-Screen:** `features/mehr/presentation/style_showcase_screen.dart`,
erreichbar über "Style-Vorschau" im "Mehr"-Bereich, zeigt alle drei
Komponenten in einem Profilseiten-artigen Beispiel-Layout.

**Zu bedenken:** Das ursprüngliche Grunddesign-Prinzip der App war
bewusst reizarm (siehe ganz oben in diesem README). Ein dunkles
Neon-Theme ist optisch lauter – die Status-Ampel wurde deshalb bewusst
als eigenständiges, klar erkennbares Signal beibehalten (nur neon
statt gedämpft), damit die Kernfunktion (Status auf einen Blick) nicht
leidet. Falls sich der Kontrast/Glow im Alltag doch als zu viel
anfühlt, lässt sich das über die zentralen Farb-/Spacing-Token leicht
nachjustieren, ohne Screens einzeln anzufassen.

## Nach dem Update ausführen

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## Update: Haushalt – Auto-Close-Bestätigung + Löschen (Swipe + Menü + Undo)

**Anlege-Sheet schloss sich zwar schon automatisch** (das war schon
so eingebaut), aber ohne jede Rückmeldung, ob wirklich etwas passiert
ist. Jetzt zeigt der Haushalt-Screen nach dem Schließen kurz eine
Bestätigung ("Aufgabe hinzugefügt ✨") – dafür gibt `showAddHouseholdTaskSheet`
jetzt zurück, ob wirklich eine Aufgabe angelegt wurde (`true`) oder
das Sheet nur abgebrochen wurde (`null`).

**Löschen war bisher komplett unmöglich** in der UI, obwohl die
Repository-Methode (`deleteTask`) schon lange existierte. Jetzt:

- **Swipe-to-Delete**: jede Aufgabenkarte lässt sich in beide
  Richtungen wegwischen (`Dismissible`)
- **Drei-Punkte-Menü** pro Karte (`PopupMenuButton`) bündelt
  "Bearbeiten" und "Löschen" – für alle, die swipen nicht entdecken
  oder lieber gezielt tippen; ersetzt den vorherigen einzelnen
  Bearbeiten-Stift-Button (weniger Icons in der ohnehin vollen
  Kartenkopfzeile)
- **Löschen ist "optimistisch"**: die Aufgabe verschwindet sofort aus
  der Liste, der eigentliche DB-Delete passiert erst 4 Sekunden
  später – die Snackbar mit "Rückgängig" bricht das einfach ab, ohne
  dass etwas wiederhergestellt werden müsste. Wichtig zu wissen:
  echtes Löschen entfernt wegen Cascade-Delete auch die
  Erledigungs-Historie der Aufgabe unwiderruflich, genau deshalb das
  Zeitfenster zum Rückgängigmachen.

`household_screen.dart` ist dafür von `ConsumerWidget` zu
`ConsumerStatefulWidget` geworden (braucht lokalen State für die
offenen Lösch-Timer).

## Update: Farb-Administration + "Cow Evolution" Gamification-System (Kuh-Milch, Merge-Weide, Special-Style-Shop)

Zwei große neue, zusammenhängende Systeme:

**1. Freie Farb-Administration (für alle, ohne Freischaltung):**
Unter "Mehr → Farben & Milch-Shop → Tab 'Farben'" kann jetzt jede Nutzerin
das Grunddesign frei anpassen: eigene Akzentfarbe (über einen
abhängigkeitsfreien HSV-Farbwähler, `lib/features/theme_lab/presentation/hsv_color_picker.dart`),
Hintergrundmodus (Dark/OLED/Light/Warm Neutral), Karten-/Containerfarbe
(oder "automatisch"), plus drei Presets (Pastell, Minimalist Dark,
High Contrast). Es gibt eine Live-Vorschau direkt im Editor. Die
Einstellungen liegen in `CustomColorSettings`
(`lib/features/theme_lab/domain/custom_color_settings.dart`) und werden
über einen neuen `ThemeSettingsNotifier`
(`lib/features/theme_lab/application/theme_settings_providers.dart`)
verwaltet und lokal persistiert (siehe JSON-Store-Hinweis unten). Das
komplette `ThemeData` der App (`main.dart`) wird jetzt dynamisch über
`dynamicThemeProvider` gebaut, statt fest aus `AppTheme.dark` zu kommen
– `app_theme.dart`/die alte MySpace-Konstante bleiben als Referenz im
Code, werden aber nicht mehr verwendet.

**2. "Cow Evolution" Merge-Spiel mit Kuh-Milch-Währung:**
Jede erledigte Haushaltsaufgabe bringt 5 Kuh-Milch, jede komplett
abgehakte Routine 12 Kuh-Milch (`lib/features/cow_evolution/`), plus –
falls auf der Weide noch Platz ist (4x4-Raster, 16 Plätze) – eine neue
Level-1-Kuh. Unter "Mehr → Kuh-Weide" lassen sich zwei gleich-levelige
Kühe nacheinander antippen, um sie zu einer stärkeren Kuh zu
verschmelzen (+ Milch-Bonus, abhängig vom neuen Level); höhere Level
geben außerdem passiv Milch über Zeit (gedeckelt auf 8 Std. Offline-Zeit,
damit reines Warten nicht der Hauptweg zu den teuren Styles wird).
Zustand (`Cow`-Liste, Milch-Stand, freigeschaltete Styles) liegt in
`CowPastureNotifier`/`CowPastureState`
(`lib/features/cow_evolution/application/cow_pasture_providers.dart`).

Wichtig: Das ist ein separates System von der bereits bestehenden
"Deine Wiese 🐄" (`cow_meadow.dart`, zeigt nur die Erfolgs-ANZAHL als
Deko-Emojis, kein Merge, keine Währung) – beide bleiben nebeneinander
bestehen, um die bisherige Ansicht nicht zu verlieren.

**3. Special-Style-Shop (mit Kuh-Milch freischaltbar):**
Im Tab "Milch-Shop" desselben Screens gibt es vier feste Looks, wie
gewünscht mit Preis, Beschreibung und Freischalt-/Aktivieren-Button:
Y2K/Late-90s Cyber (200 Milch), Cyberpunk/Low-Poly Neon (350 Milch,
mit Scanline-Deko-Hinweis), Pixel-Art/16-Bit Retro (500 Milch, mit
eingebauter Monospace-Schrift statt echtem Pixel-Font), Grotesque
Underground/Ink & Comic (750 Milch). Ein aktivierter Style überschreibt
die freie Farbwahl, bis er im Shop wieder deaktiviert wird (Datenmodell:
`SpecialStyleItem`, `lib/features/theme_lab/domain/special_style.dart`).

**Bewusste Scoping-Entscheidungen (Transparenz wie bei den vorherigen
Runden):**
- Kein neues Drift-Schema (bräuchte `build_runner`, hier nicht
  verfügbar) – Theme-Einstellungen und Kuh-Weide-Zustand liegen in
  zwei einfachen JSON-Dateien über den neuen `JsonObjectStore`
  (`lib/core/storage/json_object_store.dart`, das Pendant zum
  bestehenden `JsonListStore` für genau ein Objekt statt einer Liste).
- Kein externes Farbwähler-Package (z. B. `flutter_colorpicker`) – aus
  dieser Sandbox lässt sich pub.dev nicht erreichen, um Version/API
  zu prüfen. Stattdessen ein selbstgebauter Picker auf Basis von
  Flutters eingebautem `HSVColor` + `Slider`.
- Die vier Special-Styles sind über Farbpalette + Form/Rand/Radius/
  Schriftart umgesetzt, nicht über echte CRT-Scanline-/Glitch-Shader,
  echte Pixel-Font-Dateien oder handgezeichnete Tinten-Texturen – das
  bräuchte zusätzliche Asset-/Package-Abhängigkeiten, die sich hier
  ohne Netzwerk/Compiler nicht verifizieren lassen.
- Fest hartcodierte Farb-Widgets wie `StatusPill` (die Grün/Gelb/Rot-
  Ampel) bleiben bewusst UNVERÄNDERT von der dynamischen Theme-Wahl –
  die "reizarme" Statuslogik soll immer gleich erkennbar bleiben, egal
  welches Farbschema/welcher Special-Style gerade aktiv ist.
- Der Merge auf der Weide läuft per Tippen/Auswählen (zwei Kühe
  nacheinander antippen), nicht per echtem Drag&Drop – auf dem Handy
  zuverlässiger und ohne Gesten-Konflikte mit dem Scrollen umsetzbar,
  ohne die Spielmechanik selbst zu verändern.
- `RoutineRepository.toggleItemForToday` gibt jetzt zusätzlich zurück,
  ob die Routine dadurch komplett abgeschlossen wurde – kleine,
  rückwärtskompatible Erweiterung (`Future<void>` → `Future<bool>`),
  damit die UI den Routinen-Milch-Bonus exakt im richtigen Moment
  auslösen kann.

### Nach dem Update ausführen

```bash
flutter pub get
flutter run
```

## Update: Bugfix Farb-Administration (leerer Screen) + deutlich mehr einstellbare Farben + optionaler Verlauf

**Bugfix:** Der "Farben"-Tab blieb leer/unbedienbar, weil `_ChannelSlider`
in `hsv_color_picker.dart` den Rückgabewert von `double.clamp(...)`
(Typ `num` in Dart, nicht `double` – ein bekannter Stolperstein) direkt
als `Slider.value` übergeben hat. Das ist ein echter Typfehler, der den
kompletten Build zum Scheitern gebracht hat. Fix: `.toDouble()` ergänzt.

**Deutlich mehr einstellbare Farben:** Auf Wunsch lässt sich jetzt (fast)
jede sichtbare Farbe einzeln überschreiben, nicht nur Akzent/Hintergrund/
Karten: zweiter Akzent (Links/Icons), Text-Hauptfarbe, Text-Nebenfarbe,
Rahmenfarbe – jeweils mit "Automatisch"-Zurücksetzen-Button, falls man
lieber wieder die aus dem Hintergrundmodus abgeleitete Farbe haben will.
Zusätzlich gibt's jetzt ein direktes Hex-Eingabefeld neben jedem
Farbwähler (`#RRGGBB` eintippen + Enter), nicht nur die drei Schieberegler.

**Optionaler Verlauf:** Über "Verlauf hinzufügen" lässt sich eine zweite
Farbe für einen Verlauf ab der Akzentfarbe festlegen – sichtbar in der
Live-Vorschau (Kopfzeile). Wichtig zu wissen: das wirkt aktuell NUR in
der Vorschau, nicht automatisch app-weit auf jeder echten Kopfzeile/jedem
Button. Grund: Flutters zentrale Theme-Bausteine (`AppBarTheme`,
`ElevatedButtonThemeData`, `CardTheme`) unterstützen nur einfarbige
Flächen – ein echter App-weiter Verlauf bräuchte eine eigene
Container-Deko in jedem einzelnen Bildschirm statt der zentralen
Theme-Konstanten, was ein größerer, separater Umbau wäre. Sag Bescheid,
falls dir das wichtig genug ist, dass ich das als nächstes angehe.

Die Status-Ampel (Grün/Gelb/Rot) bleibt weiterhin bewusst unverändert.

## Update: Einstellungen/Shop getrennt, Juiciness (Haptik/Flug-Animation/Sound-Hook), Drag&Drop-Merge, Auto-Merge-Upgrade, Swipe-Quick-Actions, Prioritäts-Tags, Tagesziel & passive Milch-Rate

Große Erweiterungsrunde in mehreren Teilen:

**Einstellungen vs. Shop entkoppelt:** Neues Zahnrad-Symbol in der
AppBar von "Mehr" öffnet `SettingsScreen`
(`lib/features/settings/presentation/settings_screen.dart`) mit der
freien Farb-Administration (umgezogen aus dem alten Farben-Tab in
`ColorAdminSection`, `theme_lab/presentation/color_admin_section.dart`)
plus einem Sound-Schalter. Der Milch-Shop
(`theme_lab/presentation/theme_and_shop_screen.dart`) enthält jetzt
ausschließlich Kaufbares: die vier Special-Styles und ein neues
Auto-Merge-Upgrade (300 Milch).

**Kuh-Spawn-Rückmeldung:** `CowPastureNotifier.awardSuccess` gibt jetzt
zurück, ob eine neue Kuh gespawnt wurde oder die Weide voll war
(`CowSpawnResult`), und Haushalt/Routinen zeigen bei voller Weide
"Weide voll! Merge deine Kühe!" statt einer stillen Nicht-Aktion.

**Juiciness:**
- `HapticFeedback.lightImpact()` beim Erledigen, `.mediumImpact()`
  beim Mergen (`settings/application/app_settings_providers.dart`).
- Sound-Hook (`maybePlaySound`) vorbereitet und an den Sound-Schalter
  gekoppelt – bewusst noch ohne echtes Audio-Package/-Asset, da aus
  dieser Sandbox weder pub.dev erreichbar ist, um eine Bibliothek zu
  prüfen, noch Sound-Dateien vorliegen. Der Haken ist an genau einer
  Stelle im Code bereit für ein echtes Package.
- Flug-Animation (`shared/widgets/flying_reward_overlay.dart`): ein
  🥛-Emoji fliegt vom Auslöse-Punkt (Button/Swipe) nach oben rechts
  und verblasst. Bewusste Vereinfachung: es gibt keine eigene
  Kuh-Weide-Kachel in der Bottom-Navigation (nur Start/Haushalt/
  Routinen/Mehr), daher kein exaktes Nav-Icon als Ziel – das würde
  einen Navigations-Umbau bedeuten, den ich nicht eigenmächtig gemacht
  habe.

**Cow Evolution – Drag&Drop + Auto-Merge:** Auf der Weide lässt sich
jetzt zusätzlich zum Antippen auch eine Kuh auf eine andere ziehen;
während des Ziehens leuchten alle Kühe mit gleichem Level auf, der
Rest wird abgedunkelt (`Draggable`/`DragTarget` in
`cow_evolution/presentation/cow_pasture_screen.dart`). Mit dem
Auto-Merge-Upgrade aus dem Shop gibt es zusätzlich einen
"Sortieren & Mergen"-Knopf in der AppBar der Weide, der automatisch
alle möglichen Paare zusammenführt.

**Swipe-Quick-Actions in Haushalt:** `Dismissible` unterscheidet jetzt
Richtung: nach rechts wischen erledigt die Aufgabe (grüner Haken,
Aufgabe bleibt in der Liste), nach links wischen löscht sie (roter
Papierkorb, wie bisher mit Undo-Snackbar).

**Prioritäts-Tags:** Aufgaben lassen sich über das Menü mit 🔥
"Dringend" oder ☕ "Entspannt" markieren (2000er-Forum-Badge-Look),
gespeichert in einer eigenen JSON-Datei (`haushalt/domain/task_tag.dart`,
`application/task_tag_providers.dart`) statt einer neuen Drift-Spalte.

**Dashboard:** Tagesziel-Fortschrittsbalken ("3/5 Tasks heute
erledigt", fest auf 5, `gamification_providers.dart` ->
`dailyGoalProgressProvider`) und Anzeige der passiven Milch-Rate
("+X Milch/Min") auf dem Start-Screen und der Kuh-Weide.

**Bewusst NICHT umgesetzt / vereinfacht (Transparenz wie immer):**
- Kein echtes Audio-Package eingebunden (s. o.).
- Keine 5. Nav-Bar-Kachel für die Weide – Flug-Animation zielt auf
  eine feste Bildschirmecke statt ein echtes Icon.
- `MilkEconomyNotifier`/`TaskNotifier` wurden NICHT als komplett
  separate Klassen angelegt, sondern bleiben in `CowPastureNotifier`
  bzw. den bestehenden Task-Repositories – funktional identisch,
  nur anders benannt/organisiert als in der Anfrage vorgeschlagen.

**Bugfix: leerer Einstellungen-Screen / schwarzer Milch-Shop-Screen.**
Ursache war ein Layout-Absturz, kein unsichtbarer Bug: Das globale
Button-Theme (`theme_lab/application/theme_settings_providers.dart`)
setzt für ALLE `ElevatedButton`/`OutlinedButton` bewusst
`minimumSize: Size.fromHeight(56)` – das erzwingt eine *unendliche*
Mindestbreite, damit Buttons z. B. in Formularen/Sheets automatisch
die volle Breite ausfüllen. Das funktioniert überall dort, wo ein
Button in einer `Column` steht, führt aber zu einem Flutter-Layout-
Crash ("BoxConstraints forces an infinite width"), sobald ein solcher
Button direkt (ohne `Expanded`/`Flexible`) in einer `Row` steht – eine
`Row` gibt nicht-flexiblen Kindern nämlich eine unbegrenzte Breite vor.
Genau das war in zwei neuen Widgets aus der letzten Runde der Fall:
dem Kauf-Button in `_UpgradeCard` (`theme_and_shop_screen.dart`) und
dem "Knopf"-Button in der `_PreviewCard`-Vorschau
(`color_admin_section.dart`). Der Absturz beim allerersten Frame riss
jeweils den ganzen Screen mit – sichtbar als leerer Einstellungen-
Screen bzw. schwarzer Milch-Shop-Screen, ohne dass eine Fehlermeldung
zu sehen war (Standard-Verhalten von Flutter bei Layout-Fehlern
außerhalb des reinen Debug-Overlays). Fix: beide Buttons in
`Flexible(...)` eingepackt, damit die umgebende `Row` ihnen eine
begrenzte statt unendliche Breite vorgibt. Ein Scan über den Rest der
App fand keine weiteren Stellen mit demselben Muster.

**Echte Bild-Assets für Kühe/Zubehör/Deko/Weide (Underground-Comic-
Stil).** Ersetzt das bisherige Emoji-/Farbflächen-System teilweise
durch Lenas eigene, handgezeichnete PNGs:

- `core/assets/cow_asset_registry.dart`: zentrale Pfad-Verwaltung für
  Charakterkarten (`assets/images/cards/`), Accessoires
  (`assets/images/accessories/`), Deko (`assets/images/decorations/`),
  Weiden-Themes (`assets/images/pasture/`) und Fell-Muster
  (`assets/images/cow_patterns/`), plus `SafeAssetImage` – lädt ein
  Asset über `Image.asset` mit `errorBuilder`, zeigt bei fehlendem/
  kaputtem Pfad sauber ein Platzhalter-Icon statt die App abstürzen zu
  lassen (Fail-Safe-Pipeline aus der Anfrage).
- `cow_evolution/domain/cow_character.dart` + `cow_accessory.dart`:
  Datenmodelle für die 6 fertigen Kuh-Charaktere (Chiller/Raver/
  Street/Diva/Hippie/Boss – aus den gelieferten Kuh-Assets benannt),
  9 Accessoires, 6 Deko-Objekte, 2 Boden-Themes, 1 Zaun-Theme, 3
  Fell-Muster, jeweils mit Preis.
- `shared/widgets/decorated_cow_widget.dart`: das angefragte
  Stack-Overlay-Widget (Basis-Kuh + Accessoire-PNGs an
  prozentualen Positionen). **Scoping-Hinweis:** Es gibt noch KEIN
  `assets/images/cows/base_cow.png` (die "nackte" Basis-Kuh zeichnest
  du ja noch) – bis dahin zeigt die Fail-Safe-Pipeline dort einen
  Platzhalter. Die 6 gelieferten Charakterkarten sind fertige
  Einzel-Artworks (Kuh + Outfit + Namensschild in einem Bild) und
  laufen NICHT durch dieses Overlay-System, sondern werden 1:1 im
  Kuh-Profil gezeigt.
- `cow_evolution/presentation/cow_profile_modal.dart`: Kuh-Profil als
  Bottom-Sheet (langes Drücken auf eine Kuh auf der Weide) – große
  Charakterkarte, editierbarer Name, Entstehungsdatum, Ursprungs-Task
  (Name der auslösenden Aufgabe/Routine), Accessoire-Ausrüstung per
  Chip-Auswahl. Sprachmemo-Aufnahme/Wiedergabe ist als UI vorbereitet,
  aber (wie die Sound-Effekte) noch ohne echtes Audio-Paket verdrahtet
  (kein Netzwerkzugriff auf pub.dev zum Prüfen).
- `cow_evolution/presentation/pasture_background_widget.dart`: die
  Weide zeigt jetzt eine wechselbare Bodentextur + einen Zaun-Streifen
  + 6 feste Deko-Slots (antippen -> Auswahl-Sheet aus freigeschalteter
  Deko) statt freiem Canvas-Dragging, wie in der Anfrage
  vorgeschlagen.
- Milch-Shop (`theme_and_shop_screen.dart`) um vier neue Kategorien
  erweitert: Kuh-Accessoires, Weiden-Deko, Weiden-Boden & Zaun,
  Fell-Muster – alle über einen neuen generischen Freischalt-Kauf
  (`CowPastureNotifier.purchaseItem`) statt je eigener Sonderliste.
- `Cow` (Domain-Modell) um `characterTypeId` (zufällig beim Spawn/
  Merge gewürfelt), `customName`, `createdAt`, `originLabel` und
  `equippedAccessoryIds` erweitert – abwärtskompatibel (ältere,
  gespeicherte Kühe ohne diese Felder bekommen sinnvolle Fallbacks).

**Bewusst NICHT umgesetzt / vereinfacht (Transparenz wie immer):**
- `assets/images/cows/base_cow.png` fehlt noch – das
  Accessoire-Overlay-System ist voll funktionsfähig verdrahtet, zeigt
  bis dahin aber nur den Platzhalter der Fail-Safe-Pipeline.
- Die Positionswerte der Accessoires (`AccessoryPlacement` in
  `cow_accessory.dart`) sind plausible Startwerte, keine pixelgenaue
  Kalibrierung – die braucht das echte `base_cow.png`, um sinnvoll
  einjustiert zu werden.
- Ein echtes Einfärben der Kuh-SILHOUETTE selbst (nicht nur des
  Weiden-Bodens) mit den drei Mustern bräuchte weiterhin die Maske aus
  `base_cow.png`.
- Sprachmemo-Aufnahme/Wiedergabe: nur UI, kein echtes Audio-Paket
  (gleiche Einschränkung wie die Sound-Effekte).
- Eine deiner gelieferten Dateien (`dekozaun-asset.png`) enthielt aus
  Versehen das komplette Referenzblatt statt nur des Zauns – ich habe
  Sonnenbrille, Partyhut, Zaun, Heuballen und Eimer daraus
  automatisch freigeschnitten (transparenter Hintergrund erhalten),
  damit nichts verloren geht. Falls du diese Datei nochmal sauber
  exportierst, kannst du die entsprechenden Dateien unter
  `assets/images/accessories/` bzw. `assets/images/pasture/` und
  `assets/images/decorations/` einfach ersetzen.

**Bugfix: schwarzer Screen im Kuh-Profil + zu große Zäune + Fell-Muster
ohne Wirkung.** Drei Rückmeldungen in einer Runde behoben:

1. Gleicher Fehler wie beim Einstellungen-/Milch-Shop-Crash, nur an
   neuer Stelle: Im Kuh-Profil-Modal standen zwei
   `OutlinedButton.icon`-Buttons (Aufnehmen/Abspielen) direkt in einer
   `Row` ohne `Expanded` – die unendliche Mindestbreite aus dem
   Button-Theme (siehe Bugfix oben) ließ das Profil beim Öffnen sofort
   abstürzen (schwarzer Screen). Fix: beide Buttons in `Expanded`
   eingepackt. Ein erneuter Scan über den Rest der App fand keine
   weiteren Stellen mit diesem Muster.
2. Der Zaun-Streifen nutzte `BoxFit.cover` auf ein sehr viel breiteres
   als hohes Bild – das skaliert so stark hoch, dass am Ende nur ein
   winziger, riesig wirkender Ausschnitt sichtbar war. Fix: Das Bild
   wird jetzt per `DecorationImage` auf die Streifenhöhe herunter- statt
   hochskaliert (`BoxFit.fitHeight`) und mehrfach nebeneinander
   wiederholt (`ImageRepeat.repeatX`) – die Zaunpfosten bleiben klein
   und erkennbar.
3. Die drei "Kuh-Muster" (Milka/Giraffe/Neon) waren als eigene
   "Fell-Muster"-Kategorie im Shop nur Sammel-Items ohne sichtbaren
   Effekt. Auf Wunsch sind sie jetzt Teil der Weiden-Boden-Auswahl
   (`pastureGrounds` in `cow_accessory.dart`) und füllen als aktiver
   Boden die komplette Weide aus (`BoxFit.cover`, genau wie die
   bisherigen Boden-Themes) – die eigenständige "Fell-Muster"-Sektion
   im Shop ist entfallen.

**Echte Sound-Effekte statt Stumm-Platzhalter.** Der bisherige
`maybePlaySound`-Hook (siehe "Bewusst NICHT umgesetzt" oben) tat
absichtlich nichts Hörbares, weil in dieser Sandbox kein Zugriff auf
pub.dev bestand, um ein Audio-Package zu prüfen, und keine Sound-Dateien
vorlagen. Beides ist jetzt da:

- Lena hat freie Tieraufnahmen mitgebracht ("Mudchute Park and Farm"
  von Wikimedia Commons, Nutzer *Secretlondon*, gehostet auf
  OpenGameArt.org, lizenziert unter GFDL 1.2+ oder CC-BY-SA 3.0+). Alle
  acht `.ogg`-Dateien (Kuh, 2× Ente, Lamm, 3× Schwein, Schaf) liegen
  jetzt unter `assets/sounds/`, die ursprüngliche Lizenz-/Quellenangabe
  ist unverändert als `assets/sounds/ATTRIBUTION.txt` mit dabei –
  bitte beim Veröffentlichen der App diese Datei nicht löschen, beide
  Lizenzen verlangen Namensnennung.
- Als Audio-Package kommt `audioplayers` (`^6.0.0`, neu in
  `pubspec.yaml`) zum Einsatz – ein etabliertes, seit Jahren stabiles
  Package mit einer sehr einfachen API. Wichtiger Hinweis zur
  Transparenz: Diese Sandbox hat weiterhin **keinen** pub.dev-Zugriff
  (nochmal explizit geprüft – die Anfrage wird vom Proxy blockiert),
  ich konnte den Code hier also nicht gegen einen echten Compiler
  verifizieren. Dein `flutter pub get`/`flutter run` läuft aber ganz
  normal mit deinem eigenen Internetzugang – falls dabei ein API-Fehler
  auftaucht, schick mir bitte die genaue Fehlermeldung, dann fixe ich
  das gezielt (wie bisher bei den Layout-Bugs).
- `maybePlaySound` in `app_settings_providers.dart` spielt jetzt via
  einem einzigen wiederverwendeten `AudioPlayer` echte Dateien ab:
  Schaf-Blöken bei `SoundEvent.taskComplete` (Task/Routine erledigt),
  Kuh-Muhen bei `SoundEvent.merge` (zwei Kühe verschmolzen). Ente/
  Schwein/Lamm liegen als Bonus-Assets bereit, falls später mehr
  Abwechslung gewünscht ist. Die Wiedergabe ist bewusst
  "fire-and-forget" mit `catchError`: schlägt sie fehl (fehlendes
  Asset, Codec-Problem o. Ä.), bleibt es einfach stumm – die
  eigentliche Task-Erledigung/Merge-Aktion wird davon nie blockiert
  oder zum Absturz gebracht.
- Der Info-Text zum Sound-Schalter in den Einstellungen wurde
  entsprechend aktualisiert (nicht mehr "noch ohne Audio-Datei").
- Die eigene Sprachmemo-Aufnahme im Kuh-Profil ist davon bewusst NICHT
  betroffen: `audioplayers` kann nur ABSPIELEN, für eine eigene
  Mikrofon-Aufnahme bräuchte es zusätzlich ein Recorder-Package (z. B.
  `record`) inkl. Berechtigungs-Handling – das ist weiterhin ein
  separater, noch offener Punkt (Hinweistext im Profil entsprechend
  präzisiert).

**Echte Sprachmemo-Aufnahme im Kuh-Profil.** Der oben genannte offene
Punkt ist jetzt umgesetzt:

- Neues Package `record` (`^5.1.2`) übernimmt die Mikrofon-Aufnahme;
  `audioplayers` (schon vorhanden) übernimmt die Wiedergabe der
  aufgenommenen Datei. Mikrofon-Berechtigungen für Android
  (`RECORD_AUDIO`) und iOS (`NSMicrophoneUsageDescription`) lagen
  bereits aus der Brain-Dump-Sprache-zu-Text-Funktion vor und werden
  mitbenutzt – keine neuen Berechtigungs-Einträge nötig.
- Neue Datei `lib/shared/utils/voice_memo_storage.dart`: erzeugt einen
  dauerhaften Speicherpfad im App-Verzeichnis (`voice_memos/`, analog
  zu `image_storage.dart` für Fotos) und räumt die alte Aufnahme aus,
  sobald eine neue gespeichert wird – so sammeln sich keine
  verwaisten Audio-Dateien an.
- `Cow` (in `cow.dart`) hat jetzt ein Feld `voiceMemoPath` (persistiert
  wie alle anderen Kuh-Daten); `CowPastureNotifier.setVoiceMemoPath`
  speichert eine neue Aufnahme und löscht dabei fehlertolerant die
  vorherige Datei.
- Im Kuh-Profil-Modal starten/stoppen "Aufnehmen" und "Abspielen"
  jetzt eine echte `AudioRecorder`- bzw. `AudioPlayer`-Instanz. Fehlt
  die Mikrofon-Berechtigung oder schlägt Aufnahme/Wiedergabe aus
  einem anderen Grund fehl (z. B. kein Mikrofon vorhanden), zeigt eine
  Snackbar einen kurzen Hinweis statt dass die App abstürzt – nach dem
  gleichen Fail-Safe-Prinzip wie bei den Sound-Effekten.
- Transparenz-Hinweis wie beim `audioplayers`-Einbau: `record` ist
  ebenfalls ein etabliertes, weit verbreitetes Package, konnte hier
  aber mangels pub.dev-Zugriff nicht compiler-geprüft werden. Bitte
  bei einem Build-Fehler die genaue Meldung schicken, dann wird gezielt
  nachgebessert.

**Bugfix: Build-Fehler durch `record` in Version 5.1.2.** Lenas
`flutter run` schlug beim Kompilieren fehl:
`RecordLinux` (aus `record_linux 0.7.2`) implementierte nicht alle von
`record_platform_interface 1.6.0` geforderten Methoden
(`startStream`, `hasPermission` mit anderer Signatur). Das ist ein
Versions-Schiefstand zwischen dem `record`-Kernpaket und einer seiner
plattform-spezifischen Implementierungen, wie er bei älteren
`record`-5.x-Ständen vorkommen kann (die Kompilierung bezieht dabei
alle nativen Plattform-Implementierungen ein, nicht nur Android – ein
Linux-Build-Fehler kann so auch einen Android-Build blockieren).
Fix: `record`-Abhängigkeit in `pubspec.yaml` von `^5.1.2` auf `^6.1.1`
angehoben, wo Kernpaket und Plattform-Implementierungen laut
Changelog wieder synchron zueinander veröffentlicht wurden. Da diese
Sandbox weiterhin keinen pub.dev-Zugriff hat, bitte nach dem Einspielen
einmal `flutter clean && flutter pub get` laufen lassen (nicht nur
`pub get` alleine), damit eine alte, im Cache liegende `pubspec.lock`-
Auflösung nicht versehentlich wiederverwendet wird.

**Weiden-Grid/Zaun-Fix, echte Charakter-Artworks im Raster, Profil-Redesign
und "Moo-Loop"-Ambient-Sound.** Vier Rückmeldungen in einer Runde:

1. **Zaun als echter Rahmen statt loser Streifen.** Der Zaun-Streifen
   unter dem Weiden-Raster wirkte lose/unverbunden. `PastureBackgroundWidget`
   baut die Weide jetzt als zwei ineinander verschachtelte Container:
   die äußere Box zeigt das (mit `ResizeImage` klein herunterskalierte
   und gekachelte) Zaun-Bild als Hintergrund, die innere Box mit der
   Bodentextur sitzt mit 14px Abstand darin – der sichtbare Rand
   dazwischen IST jetzt der Zaun, umschließt also wirklich die ganze
   Weide statt darunter zu schweben.
2. **Bodentextur füllt wirklich die ganze Weide.** War architektonisch
   schon als Hintergrund hinter dem Raster gedacht, ist jetzt (im Zuge
   der Container-Verschachtelung von Punkt 1) nochmal sauber als
   `BoxFit.cover`-Hintergrund der inneren Box umgesetzt – keine
   isoliert wirkende Einzel-Kachel mehr.
3. **Echte Charakter-Artworks statt Emoji im Kuh-Raster.** Jede
   besetzte Kachel zeigt jetzt `cow.characterType.cardAssetPath` (das
   PNG-Artwork, `BoxFit.contain`) statt des bisherigen 🐄-Emojis; das
   Level sitzt als kleines Overlay-Badge unten rechts in der Kachel.
   `emojiForCowLevel` bleibt als Fallback-Funktion für andere Stellen
   bestehen, wird im Raster aber nicht mehr benutzt.
4. **Profil-Modal neu gestaltet + Overflow-Fix.** Nutzt jetzt die
   vorhandenen MySpace/Y2K-Bausteine (`MySpaceCard`, `MySpaceBadge`)
   statt einer eigenen Ad-hoc-Optik: Charakterkarte in einer festen
   `AspectRatio`-Box mit Neon-Glow-Rand (dadurch kein Overflow mehr
   möglich, egal wie hoch das Sheet gerade gezogen ist), Name als
   Retro-Badge, Level/Entstehungsdatum/Ursprung als umbrechende
   `Wrap`-Badges statt einer festen 100px-Label-Spalte (dort konnten
   lange Ursprungs-Texte vorher eng werden). Zusätzlich ein
   abgerundeter Sheet-Container mit Drag-Handle statt der
   Standard-Sheet-Kante, damit die oberen Ecken nicht mehr eckig/
   unsauber wirken.
5. **Neu: "Moo-Loop" – Ambient-Sound auf der Weide.** Solange die
   Weiden-Ansicht offen ist, meldet sich per `Timer` alle 8–15 Sekunden
   (Intervall wird nach jeder Runde neu zufällig gewählt) eine
   zufällige der aktuell stehenden Kühe zu Wort: mit ihrer eigenen
   Sprachmemo, falls vorhanden, sonst mit dem Standard-Kuh-Sound
   (`Mudchute_cow_1.ogg`). Nutzt einen eigenen `AudioPlayer` (nicht den
   globalen Sound-Effekt-Player aus den Einstellungen, damit sich
   Ambient-Muh und z. B. ein Merge-Sound nicht gegenseitig
   unterbrechen) und respektiert den globalen Sound-Schalter – ist er
   aus, bleibt der Loop stumm, läuft aber weiter im Hintergrund und
   spielt automatisch wieder, sobald er wieder eingeschaltet wird. Der
   Timer wird beim Verlassen der Weiden-Ansicht sauber gestoppt
   (`dispose`), damit nichts im Hintergrund weiterläuft oder abstürzt.
