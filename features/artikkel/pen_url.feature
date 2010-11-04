# encoding: utf-8
# language: no
Egenskap: Artikkel med pen URL

  For at leksikonet skal havne høyt i Google-søk
  Som en søke-robot
  Vil jeg se pene url-er

  Abstrakt Scenario: routing til oppslagsord
    Gitt at artikkelen "<headword>" finnes
    Når jeg går til artikkelvisning for "<headword>"
    Så skal jeg se "<headword>" under "h1"

    Eksempler:
      | headword      |
      | Foo bar       |
      | Foo / bar     |
      | Foo & bar     |
      | Foo.x & bar.y |
      | Foo.x Bar.y   |
      | Foo.x bar     |
      | Foo.x & bar   |
