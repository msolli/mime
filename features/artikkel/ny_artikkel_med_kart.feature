# encoding: utf-8
# language: no

Egenskap: Ny artikkel med tilknyttet posisjon

  For at leksikonet skal få artikler med god kvalitet
  Som en lokalinteressert person
  Vil jeg kunne angi geografisk posisjon
  
  @javascript
  Scenario: kartet vises ikke før man klikker "vis kart"
    Når jeg står på ny artikkel-siden
    Så skal jeg se "Angi sted for denne artikkelen"
    Og kartet skal være usynlig

  # @javascript
  # Scenario: kartet vises når man klikker "vis kart"
  #   Gitt at jeg står på ny artikkel-siden
  #   Når jeg klikker "Vis kart"
  #   Så skal kartet vises

  @javascript
  Scenario: ikke tilegnet kart
    Gitt at jeg står på ny artikkel-siden
    Og jeg fyller inn "article[headword]" med "Foo"
    Når jeg trykker "Opprett"
    Så skal jeg ikke se noe kart

  # @javascript
  # Scenario: tilegnet kart
  #   Gitt at jeg står på ny artikkel-siden
  #   Og jeg fyller inn "article[headword]" med "Foo"
  #   Og jeg klikker "Vis kart"
  #   Og jeg fyller inn "maptastic-search" med "Billingstadsletta 17"
  #   Og jeg venter 5 sekunder
  #   Når jeg trykker "Opprett"
  #   Så skal kartet vises i artikkelen
