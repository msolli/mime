# encoding: utf-8
# language: no
Egenskap: Ny artikkel

  For at leksikonet skal få mange interessante artikler
  Som en lokalinteressert person
  Vil jeg kunne opprette artikler

  Bakgrunn: Skrevet ny artikkel
    Gitt at jeg står på ny artikkel-siden
    Og jeg fyller inn "Oppslagsord" med "Xyzzy-tittel"
    Og jeg fyller inn "article[text]" med "Xyzzy-artikkeltekst"

    Scenario: opprette ny artikkel
      Når jeg trykker "Opprett"
      Så skal jeg komme til artikkelvisning for "Xyzzy-tittel"
      Og jeg skal se "Artikkelen er lagret" under "#notice"
      Og jeg skal se "Xyzzy-tittel"
      Og jeg skal se "Xyzzy-artikkeltekst"

    Scenario: melding om at artikkel er opprettet
      Når jeg trykker "Opprett"
      Så skal jeg se "er lagret"

    Scenario: sist oppdater
      Når jeg trykker "Opprett"
      Så skal jeg se "Sist oppdatert"
