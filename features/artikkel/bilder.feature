# encoding: utf-8
# language: no
Egenskap: Legge bilder til artikler

  For at leksikonet skal være så bra som mulig
  Som en lokalinteressert person
  Vil jeg kunne legge inn bilder i artikler

  @javascript
  Scenario: legge til bilder
    Gitt at artikkelen "Foo" finnes
    Og jeg står på artikkelredigering for "Foo"
    Når jeg legger ved bildet "spec/data/jpeg.jpeg" til "file-uploader"
    Og jeg trykker "Last opp filer"
    Så skal det være 1 av ".files li img"
    Når jeg trykker "Lagre"
    Så skal det være 1 av ".meta figure"

  Scenario: endre bildetekst
    Gitt at artikkelen "Foo" finnes
    Og at artikkelen "Foo" har bilde
    Og jeg står på artikkelredigering for "Foo"
    Når jeg fyller inn "Beskrivelse" med "baz"
    Når jeg trykker "Lagre"
    Så skal jeg se "baz" under ".meta figurecaption"
    
  Scenario: slette bilde
    Gitt at artikkelen "Foo" finnes
    Og at artikkelen "Foo" har bilde
    Og jeg står på artikkelredigering for "Foo"
    Når jeg krysser av "Slett"
    Og jeg trykker "Lagre"
    Så skal det være 0 av ".meta figure"
