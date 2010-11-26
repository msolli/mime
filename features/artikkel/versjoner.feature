# encoding: utf-8
# language: no
Egenskap: Versjonering av artikler

  For at leksikonet skal få artikler med god kvalitet
  Som en lokalinteressert person
  Vil jeg kunne versjonere artikler

  Bakgrunn:
    Gitt at jeg står på ny artikkel-siden
    Og jeg fyller inn "article[headword]" med "Foo"
    Og jeg trykker "Opprett"

  Scenario: gå til versjonslogg
    Gitt at jeg står på artikkelvisning for "Foo"
    Når jeg klikker "Versjonslogg"
    Så skal jeg komme til versjonsloggen for "Foo"
    Og jeg skal se "bare én versjon"
    Og jeg skal se "127.0.0.1" under ".current"

  Scenario: to versjoner
    Gitt at jeg står på artikkelredigering for "Foo"
    Og jeg trykker "Lagre"
    Og jeg klikker "Versjonslogg"
    Så skal jeg se "2 versjoner"
    Og jeg skal se "127.0.0.1" under ".current"
    Og jeg skal se "127.0.0.1" under ".version-number-1"

  Scenario: flere versjoner
    Gitt at jeg står på artikkelredigering for "Foo"
    Når jeg trykker "Lagre"
    Og jeg klikker "Rediger"
    Og jeg trykker "Lagre"
    Og jeg klikker "Versjonslogg"
    Så skal jeg se "3 versjoner"
