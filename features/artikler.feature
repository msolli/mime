# language: no
Egenskap: Artikler

  For at leksikonet skal få mange interessante artikler
  Som en lokalinteressert person
  Vil jeg kunne opprette og redigere artikler

  Scenario: opprette ny artikkel
    Gitt at jeg står på ny artikkel-siden
    Og jeg fyller inn "Oppslagsord" med "Foo-tittel"
    Når jeg trykker "Lagre"
    Så skal jeg komme til artikkelvisning for "Foo-tittel"
    Og jeg skal se "Foo-tittel"