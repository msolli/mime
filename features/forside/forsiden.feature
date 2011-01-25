# encoding: utf-8
# language: no
Egenskap: Forside

  For at leksikonet skal fremstå som interessant og med mye innhold
  Som en lokalinteressert person
  Vil jeg ha en forside som lenker til en artikkel

  Scenario: viser forsiden
    Gitt at det fins en forside
    Når jeg går til forsiden
    Så skal jeg se 4 dagens artikler
    Og jeg skal se 4 ukens personer
    Og jeg skal se 5 artikler i hver av boksene

  Scenario: går til forsideredigering
    # Gitt at jeg er logget inn som "Ronny Redaksjonsmedlem"
    # Gitt at jeg står på forsiden
    # Når jeg klikker "Rediger"
    # Så skal jeg komme til forsideredigering
