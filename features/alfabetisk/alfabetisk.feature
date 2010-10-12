# encoding: utf-8
# language: no
Egenskap: Alfabetisk

  For at leksikonet skal fremstå som interessant og med mye innhold
  Som en lokalinteressert person
  Vil jeg ha en alfabetisk liste over artikler

  Scenario: går til en bokstav i den alfabetiske listen fra forsiden
    Gitt at jeg står på forsiden
    Og at artikkelen "Asker (kommune)" finnes
    Når jeg klikker "a"
    Så skal jeg komme til alfabetisk-siden for "a"
    Og jeg skal se "Asker (kommune)"

  Scenario: går til en bokstav i den alfabetiske listen fra en artikkel-side
    Gitt at artikkelen "Asker (kommune)" finnes
    Og at jeg står på artikkelvisning for "Asker (kommune)"
    Når jeg klikker "a"
    Så skal jeg komme til alfabetisk-siden for "a"
    Og jeg skal se "Asker (kommune)"

  @wip
  Scenario: navn på personer skal sorteres på etternavn
    Gitt følgende artikler:
      | headword       | headword_sorting |
      | Anton Oskarsen | Oskarsen, Anton  |
      | Anton Sport    |                  |
    Når jeg står på alfabetisk-siden for "a"
    Så skal jeg se "Anton Sport"
    Og jeg skal ikke se "Anton Oskarsen"
