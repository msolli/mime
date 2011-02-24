# encoding: utf-8
# language: no
Egenskap: Forsideredigering

  For at leksikonet skal fremstå som interessant og med mye innhold
  Som et redaksjonsmedlem
  Vil jeg kunne redigere forsiden

  Bakgrunn:
    Gitt at det fins en tom forside
    Og jeg står på forsideredigering
    Og at følgende artikler finnes:
      | headword |
      | Bønne    |
      | Saus     |
      | Pepper   |

  @log_in_editor @javascript
  Scenario: Ny manuell liste
    Når jeg klikker "Ny manuell liste"
    Og jeg fyller inn "Navn" med "Dagens artikler"
    Og jeg legger til følgende artikler:
      | Oppslagsord | Dato     |
      | Bønne       | i dag    |
      | Saus        | i dag -1 |
      | Pepper      | i dag -2 |
    Og jeg trykker "Opprett"
    Så skal jeg se "Dagens artikler"
    Når jeg trykker "Lagre"
    Så skal jeg se "Bønne"

  @log_in_editor @javascript
  Scenario: Ny manuell liste som slettes før side lagres
    Når jeg klikker "Ny manuell liste"
    Og jeg fyller inn "Navn" med "Dagens artikler"
    Og jeg legger til følgende artikler:
      | Oppslagsord | Dato     |
      | Bønne       | i dag    |
      | Saus        | i dag -1 |
      | Pepper      | i dag -2 |
    Og jeg trykker "Opprett"
    Og jeg klikker "slett"
    Når jeg trykker "Lagre"
    Så skal jeg ikke se "Dagens artikler"

  @log_in_editor @javascript
  Scenario: Slette artikkel i manuell liste
    Når jeg klikker "Ny manuell liste"
    Og jeg fyller inn "Navn" med "Dagens artikler"
    Og jeg legger til følgende artikler:
      | Oppslagsord | Dato     |
      | Bønne       | i dag    |
      | Saus        | i dag -1 |
      | Pepper      | i dag -2 |
    Og jeg trykker "Opprett"
    Og jeg klikker "rediger"
    Og jeg klikker "slett"
    Når jeg trykker "Lagre"
    Så skal jeg ikke se "Bønne"
    Og jeg skal se "Saus"
    Og jeg skal se "Pepper"

  @log_in_editor
  Scenario: Mangler navn
    Når jeg klikker "Ny manuell liste"
    Og jeg trykker "Opprett"
    Så skal jeg se "Lista må nok ha et navn"

  @log_in_editor
  Scenario: Mangler oppslagsord for artikkel
    Når jeg klikker "Ny manuell liste"
    Og jeg fyller inn "Dato" med "2011-01-01"
    Og jeg trykker "Opprett"
    Så skal jeg se "Lista må nok ha et navn"
    Og jeg skal se "Du må velge en artikkel"

  @log_in_editor
  Scenario: Mangler dato for artikkel
    Når jeg klikker "Ny manuell liste"
    Og jeg fyller inn "Navn" med "Dagens artikler"
    Og jeg fyller inn "Oppslagsord" med "Bønne"
    Og jeg trykker "Opprett"
    Så skal jeg se "Du må velge en dato"
