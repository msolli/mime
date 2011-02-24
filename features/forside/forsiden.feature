# encoding: utf-8
# language: no
Egenskap: Forside

  For at leksikonet skal fremstå som interessant og med mye innhold
  Som en lokalinteressert person
  Vil jeg ha en forside med flere artikkellister

  Scenario: viser forsiden
    Gitt at det fins en forside
    Når jeg går til forsiden
    # Så skal jeg se 4 dagens artikler
    # Og jeg skal se 4 ukens personer
    # Og jeg skal se 5 artikler i hver av boksene

  @log_in_editor
  Scenario: går til forsideredigering som editor
    Gitt at det fins en tom forside
    Og jeg står på forsiden
    Når jeg klikker "Rediger"
    Så skal jeg komme til forsideredigering
