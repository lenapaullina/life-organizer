/// "Aufgabe Zerstückler": zerlegt eine groß wirkende Haushaltsaufgabe
/// in winzige, in ~2 Minuten machbare Schritte. Bewusst OHNE echte
/// KI/Netzwerk-Anbindung (die App bleibt komplett lokal) – stattdessen
/// feste Templates, die über Stichwörter im Aufgabennamen ausgewählt
/// werden, plus ein Freitext-Fallback zum selbst Eintippen.
class MicroTaskTemplate {
  final List<String> keywords;
  final List<String> steps;

  const MicroTaskTemplate({required this.keywords, required this.steps});
}

const microTaskTemplates = [
  MicroTaskTemplate(
    keywords: ['küche', 'kueche', 'spüle', 'spuele', 'geschirr'],
    steps: [
      '3 Teller/Schüsseln in die Spülmaschine räumen',
      'Restliches Geschirr kurz unter Wasser abspülen',
      'Arbeitsfläche einmal mit einem Tuch abwischen',
      'Mülltüte zumachen (rausbringen nur, falls du eh am Weg vorbeikommst)',
      'Spültuch auswaschen und zum Trocknen aufhängen',
    ],
  ),
  MicroTaskTemplate(
    keywords: ['bad', 'badezimmer', 'toilette', 'klo'],
    steps: [
      'Waschbecken kurz mit einem Tuch abwischen',
      'Handtücher geradehängen',
      'Einmal mit Klopapier oder Tuch über den Spiegel wischen',
      'Mülleimer leeren, falls er voll ist',
    ],
  ),
  MicroTaskTemplate(
    keywords: ['wohnzimmer', 'sofa', 'couch'],
    steps: [
      'Kissen aufschütteln und geradelegen',
      'Decken zusammenlegen',
      '3 Dinge vom Tisch an ihren Platz räumen',
      'Kurz durchsaugen oder -kehren',
    ],
  ),
  MicroTaskTemplate(
    keywords: ['wäsche', 'waesche'],
    steps: [
      'Wäsche aus der Maschine nehmen',
      'Auf dem Wäscheständer aufhängen',
      'Wäschekorb wieder an seinen Platz stellen',
    ],
  ),
  MicroTaskTemplate(
    keywords: ['müll', 'muell', 'abfall'],
    steps: [
      'Mülltüte zumachen',
      'Mülltüte zur Tür/zum Container bringen',
      'Neue Tüte in den Eimer legen',
    ],
  ),
  MicroTaskTemplate(
    keywords: ['schlafzimmer', 'bett'],
    steps: [
      'Bett machen (reicht: Decke glattziehen)',
      'Wäsche vom Stuhl oder Boden aufsammeln',
      'Nachttisch kurz freiräumen',
    ],
  ),
];

/// Generischer Fallback, wenn kein Template zum Aufgabennamen passt –
/// funktioniert für praktisch jede Aufgabe, ohne sie zu kennen.
const fallbackMicroTaskSteps = [
  'Nimm dir 2 Minuten, ein Timer ist optional.',
  'Fang mit der kleinsten Kleinigkeit an, die du siehst.',
  'Räum 3 Dinge an ihren Platz.',
  'Wisch 1 Fläche ab, die vor dir liegt.',
  'Fertig für jetzt? Der Rest kann warten – das war schon ein Erfolg.',
];

/// Wählt anhand von Stichwörtern im Aufgabennamen ein passendes
/// Template, sonst den generischen Fallback.
List<String> microTaskStepsFor(String taskName) {
  final lower = taskName.toLowerCase();
  for (final template in microTaskTemplates) {
    if (template.keywords.any(lower.contains)) {
      return template.steps;
    }
  }
  return fallbackMicroTaskSteps;
}
