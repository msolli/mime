# encoding: utf-8
# language: no
Egenskap: Artikler skal indekseres

  For at leksikonet skal være mest mulig brukervennlig
  Som en lokalinteressert person
  Vil jeg kunne søke etter artikler

  @search
  Scenario: ny artikkel
    Gitt at artikkelen "Foo" finnes
    Og jeg står på forsiden
    Når jeg fyller inn "q" med "foo"
    Og jeg trykker "Søk"
    Så skal jeg se "Foo"

  @search
  Scenario: ikke finne urelevante artikler
    Gitt at artikkelen "Foo" finnes
    Og jeg står på forsiden
    Når jeg fyller inn "q" med "bar"
    Og jeg trykker "Søk"
    Så skal jeg ikke se "Foo"
  
  @search
  Scenario: endre artikkel
    Gitt at artikkelen "Foo" finnes
    Og jeg står på artikkelredigering for "Foo"
    Når jeg fyller inn "article[text]" med "bar"
    Og jeg trykker "Lagre"
    Og jeg fyller inn "q" med "bar"
    Og jeg trykker "Søk"
    Så skal jeg se "Foo"
    