# encoding: utf-8
# language: no
Egenskap: Redigere artikler

  For at leksikonet skal være oversiktlig
  Som en lokalinteressert person
  Vil jeg kunne legge inn alternativt oppslagsord

  Scenario: legge til alternativt oppslagsord
    Gitt at artikkelen "Foo" finnes
    Og jeg står på artikkelredigering for "Foo"
    Og jeg fyller inn "article[headword_presentation]" med "Føø"
    Når jeg trykker "Lagre"
    Så skal jeg se "Føø"
    Og jeg skal ikke se "Foo"

  @javascript
  Abstrakt Scenario: alternativt oppslagsord vises ikke når tomt
    Gitt at artikkelen "<headword>" finnes
    Når jeg står på artikkelredigering for "<headword>"
    Så skal feltet "article[headword_presentation]" være tomt

    Eksempler:
      | headword  |
      | Foo       |
      | Foo & bar |
      | <Foo>     |
      | «Foo»     |
