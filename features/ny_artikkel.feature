# language: no
Egenskap: Ny artikkel

  For at leksikonet skal få mange interessante artikler
  Som en lokalinteressert person
  Vil jeg kunne opprette artikler

  Scenario: opprette ny artikkel
    Gitt at jeg står på ny artikkel-siden
    Og jeg fyller inn "Oppslagsord" med "Xyzzy-tittel"
    Og jeg fyller inn "Artikkeltekst" med "Xyzzy-artikkeltekst"
    Når jeg trykker "Opprett"
    Så skal jeg komme til artikkelvisning for "Xyzzy-tittel"
    Og jeg skal se "Xyzzy-tittel"
    Og jeg skal se "Xyzzy-artikkeltekst"
