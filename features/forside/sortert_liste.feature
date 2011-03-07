# encoding: utf-8
# language: no
Egenskap: Sortert liste

  For at leksikonet skal fremstå som interessant og med mye innhold
  Som et redaksjonsmedlem
  Vil jeg kunne legge en sortert artikkelliste til forside

  Bakgrunn:
    Gitt at det fins en tom forside
    Og jeg står på forsideredigering
    Og at jeg har opprettet følgende artikler:
      | headword  | updated_at |
      | snerk     | 2010-10-04 |
      | bukse     | 2010-10-03 |
      | åker      | 2010-10-01 |
      | føner     | 2010-10-02 |
      | samlebånd | 2010-10-05 |

  @log_in_editor
  Scenario: Ny sortet liste
    Når jeg klikker "Ny sortert liste"
    Og jeg fyller inn "Navn" med "Sist oppdatert"
    Og jeg velger "Sist endret"
    Og jeg velger "Synkende"
    Og jeg trykker "Opprett"
    Så skal jeg se "Sist oppdatert"
    Når jeg trykker "Lagre"
    Så skal jeg se "snerk"

  @log_in_editor @javascript
  Scenario: Ny sortert liste som slettes før side lagres
    Når jeg klikker "Ny sortert liste"
    Og jeg fyller inn "Navn" med "Sist oppdatert"
    Og jeg velger "Sist endret"
    Og jeg velger "Synkende"
    Og jeg trykker "Opprett"
    Og jeg klikker "slett"
    Når jeg trykker "Lagre"
    Så skal jeg ikke se "Sist oppdatert"

  @log_in_editor
  Scenario: Mangler navn
    Når jeg klikker "Ny sortert liste"
    Og jeg trykker "Opprett"
    Så skal jeg se "Lista må nok ha et navn"

  @log_in_editor
  Scenario: Mangler sorteringsfelt og -retning
    Når jeg klikker "Ny sortert liste"
    Og jeg fyller inn "Navn" med "Sist oppdatert"
    Og jeg trykker "Opprett"
    Så skal jeg se "Du må velge et sorteringsfelt"
    Og jeg skal se "Du må velge en sorteringsretning"
