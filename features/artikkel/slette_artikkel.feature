# encoding: utf-8
# language: no
Egenskap: slette artikkel

  For at leksikonet skal ha bare relevante artikler
  Som et redaksjonsmedlem
  Vil jeg kunne slette artikler

  Bakgrunn:
    Gitt at artikkelen "Foo" finnes
    Og jeg står på artikkelredigering for "Foo"

    @javascript
    Scenario: artikkel slettes
      Gitt at jeg forventer å velge "OK" når jeg ser "er du sikker" i et bekreftelsesvindu
      Når jeg trykker "Slett artikkel"
      Så skal bekreftelsesvinduet ha blitt vist
      Og jeg skal se "slettet"
      Og jeg skal komme til forsiden
