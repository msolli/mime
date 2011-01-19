# encoding: utf-8
# language: no
Egenskap: Redigere artikler

  For at leksikonet skal være oversiktlig
  Som en lokalinteressert person
  Vil jeg kunne merke en artikkel som en personartikkel

  Scenario: merke som personartikkel
    Gitt at artikkelen "Bar, Foo" finnes
    Og jeg står på artikkelredigering for "Bar, Foo"
    Og jeg fyller inn "Nøkkelord" med "person"
    Når jeg trykker "Lagre"
    Så skal jeg se "Foo Bar"
    Og jeg skal ikke se "Bar, Foo"
