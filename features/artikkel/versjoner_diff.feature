# encoding: utf-8
# language: no
Egenskap: Se forskjellen på to versjoner av en artikkel

  For at leksikonet skal få artikler med god kvalitet
  Som en moderator
  Vil jeg raskt kunne se hva som har blitt endret i en artikkel

  Bakgrunn:
    Gitt at artikkelen "Foo" finnes
    Og at artikkelen "Foo" får teksten
      """
      <p>Linje 1</p>
      <p>Linje 2</p>
      <p>Linje 3</p>
      """

  Scenario: Endret tekst
    Gitt at artikkelen "Foo" får teksten
      """
      <p>Linje 3</p>
      <p>Linje 4</p>
      <p>Linje 2</p>
      """
    Når jeg står på artikkelvisning for "Foo"
    Og jeg klikker "Versjonslogg"
    Når jeg krysser av "Aktiv versjon"
    Og jeg krysser av "V 2"
    Og jeg trykker "Sammenlign"
    Så skal jeg se "1" under "p:eq(1) del"
    Og jeg skal se "Linje 4" under "p:eq(2) ins"
  
  Scenario: Lagt til bilde
    Gitt at artikkelen "Foo" har bilde
    Og at jeg legger til bildet "/spec/data/jpeg.jpeg" til artikkelen "Foo"
    Når jeg står på versjonsloggen for "Foo"
    Og jeg krysser av "Aktiv versjon"
    Og jeg krysser av "V 3"
    Og jeg trykker "Sammenlign"
    Så skal ".meta .added figure" finnes
