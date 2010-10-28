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

  Scenario: takler norske bokstaver I
    Gitt at artikkelen "Åh" finnes
    Når jeg står på alfabetisk-siden for "å"
    Så skal jeg se "Åh"

  Scenario: takler norske bokstaver II
    Gitt at artikkelen "Åh" finnes
    Når jeg står på alfabetisk-siden for "h"
    Så skal jeg ikke se "Åh"

  Scenario: navn på personer skal sorteres på etternavn I
    Gitt følgende artikler:
      | headword        | headword_presentation |
      | Oskarsen, Anton | Anton Oskarsen        |
      | Anton Sport     |                       |
    Når jeg står på alfabetisk-siden for "a"
    Så skal jeg se "Anton Sport"
    Og jeg skal ikke se "Oskarsen"

  Scenario: navn på personer skal sorteres på etternavn II
    Gitt følgende artikler:
      | headword        | headword_presentation |
      | Oskarsen, Anton | Anton Oskarsen        |
      | Anton Sport     |                       |
    Når jeg står på alfabetisk-siden for "o"
    Så skal jeg se "Oskarsen, Anton"
    Og jeg skal ikke se "Anton Sport"

  Scenario: artikler som begynner på spesialtegn
    Gitt at artikkelen "«Alabama»" finnes
    Når jeg står på alfabetisk-siden for "a"
    Så skal jeg se "«Alabama»"
