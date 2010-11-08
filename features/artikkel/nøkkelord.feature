# encoding: utf-8
# language: no
Egenskap: Nøkkelord på artikler

  For at leksikonet skal få artikler med god kvalitet
  Som en lokalinteressert person
  Vil jeg kunne legge inn nøkkelord på artikler

  Scenario: opprette nøkkelord på en artikkel
    Gitt at artikkelen "Foo" finnes
    Og jeg står på artikkelredigering for "Foo"
    Når jeg fyller inn "Nøkkelord" med "bar, baz, xyzzy"
    Og jeg trykker "Lagre"
    Så skal jeg se "bar" i nøkkelord-seksjonen
    Og jeg skal se "baz" i nøkkelord-seksjonen
    Og jeg skal se "xyzzy" i nøkkelord-seksjonen
