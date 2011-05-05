# encoding: utf-8
# language: no
Egenskap: Laste opp bilde til artikkel

  For at leksikonet skal være så bra som mulig
  Som en lokalinteressert person
  Vil jeg kunne legge inn bilder i artikler

  Scenario: vise siden for bildeopplasting
    Gitt at artikkelen "Foo" finnes
    Og jeg står på artikkelredigering for "Foo"
    Når jeg klikker "Last opp bilder"
    Så skal jeg komme til siden for bildeopplasting for "Foo"

  Scenario: laste opp et bilde
    Gitt at artikkelen "Foo" finnes
    Og jeg står på siden for bildeopplasting for "Foo"
    Når jeg laster opp følgende bilde:
      | file                | description | author   | license  |
      | spec/data/jpeg.jpeg | Bildetekst  | Fotograf | CC-BY-SA |
    Så skal jeg se 1 bilde i bildelisten

  Scenario: laste opp bilde som innlogget bruker
