# encoding: utf-8
# language: no
Egenskap: Artikkel med tilknyttet posisjon

  For at leksikonet skal få artikler med god kvalitet
  Som en lokalinteressert person
  Vil jeg kunne angi geografisk posisjon
  
  Bakgrunn:
    Gitt at jeg står på ny artikkel-siden
    Og jeg fyller inn "Oppslagsord" med "Foo"
  
    @javascript
    Scenario: ikke tilegnet kart
      Når jeg trykker "Opprett"
      Så skal ikke "aside.meta img" finnes
  
    @javascript
    Scenario: tilegnet kart
      Gitt jeg fyller inn "maptastic-search" med "Billingstadsletta 17"
      Og jeg venter 1 sekunder
      Når jeg trykker "Opprett"
      Så skal "aside.meta img" være synlig
  

