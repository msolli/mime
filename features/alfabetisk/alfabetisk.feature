# language: no
Egenskap: Alfabetisk

  For at leksikonet skal fremstå som interessant og med mye innhold
  Som en lokalinteressert person
  Vil jeg ha en alfabetisk liste over artikler

  Scenario: går til en bokstav i den alfabetiske listen
    Gitt at jeg står på forsiden
    Og artikkelen "Asker (kommune)" finnes
    Når jeg klikker "a"
    Så skal jeg komme til alfabetisk-siden for "a"
    Og jeg skal se "Asker (kommune)"
