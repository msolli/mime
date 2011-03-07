# encoding: utf-8
# language: no
Egenskap: Liste basert på nøkkelord

  For at leksikonet skal fremstå som interessant og med mye innhold
  Som et redaksjonsmedlem
  Vil jeg kunne legge en liste basert på nøkkelord på forsiden

  Bakgrunn:
    Gitt at det fins en tom forside
    Og jeg står på forsideredigering
    Og at følgende artikler finnes:
      | headword      | tags      |
      | Parkveien     | vei, gate |
      | Drammensveien | vei       |
      | Skarpsno      | vei, gate |
      | Pilestredet   | vei       |
      | Maridalsveien | vei       |
      | Oslo gate     | gate      |

  @log_in_editor @javascript
  Scenario: Ny nøkkelord-liste
    Når jeg klikker "Ny liste basert på nøkkelord"
    Og jeg fyller inn "Navn" med "Veier"
    Og jeg fyller inn "Nøkkelord" med "vei"
    Og jeg trykker "Opprett"
    Så skal jeg se "Veier"
    Når jeg trykker "Lagre"
    Og jeg venter 10 sekunder
    Så skal jeg se "Parkveien"
    Men jeg skal ikke se "Oslo gate"

  @log_in_editor @javascript
  Scenario: Ny nøkkelord-liste som slettes før side lagres
    Når jeg klikker "Ny liste basert på nøkkelord"
    Og jeg fyller inn "Navn" med "Veier"
    Og jeg trykker "Opprett"
    Og jeg klikker "slett"
    Når jeg trykker "Lagre"
    Så skal jeg ikke se "Veier"

  @log_in_editor
  Scenario: Mangler navn
    Når jeg klikker "Ny liste basert på nøkkelord"
    Og jeg trykker "Opprett"
    Så skal jeg se "Lista må nok ha et navn"

  @log_in_editor
  Scenario: Mangler nøkkelord
    Når jeg klikker "Ny liste basert på nøkkelord"
    Og jeg fyller inn "Navn" med "Veier"
    Og jeg trykker "Opprett"
    Så skal jeg se "Veier"
