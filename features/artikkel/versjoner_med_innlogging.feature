# encoding: utf-8
# language: no
Egenskap: Versjonering av artikler med innlogget bruker

  For at leksikonet skal få artikler med god kvalitet
  Som en lokalinteressert person
  Vil jeg kunne versjonere artikler

  @devise @logged_in @javascript
  Scenario: innlogget og anonym versjon
    Gitt at jeg står på ny artikkel-siden
    Når jeg fyller inn "Oppslagsord" med "Foo"
    Og jeg trykker "Opprett"
    Og jeg klikker "Logg ut"
    Og jeg står på artikkelredigering for "Foo"
    Og jeg trykker "Lagre"
    Og jeg klikker "Versjonslogg"
    Så skal jeg se "2 versjoner"
    Og jeg skal se "127.0.0.1" under ".current"
    Og jeg skal se "Navn Navnesen" under ".version-number-1"

  @devise
  Scenario: anonym og innlogget versjon
    Gitt at jeg står på ny artikkel-siden
    Og jeg fyller inn "Oppslagsord" med "Foo"
    Og jeg trykker "Opprett"
    Og jeg logger inn
    Når jeg står på artikkelredigering for "Foo"
    Og jeg trykker "Lagre"
    Og jeg klikker "Versjonslogg"
    Så skal jeg se "2 versjoner"
    Og jeg skal se "Navn Navnesen" under ".current"
    Og jeg skal se "127.0.0.1" under ".version-number-1"
