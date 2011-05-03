# encoding: utf-8
# language: no

Egenskap: Ny artikkel med tilknyttet posisjon

  For at leksikonet skal få artikler med god kvalitet
  Som en lokalinteressert person
  Vil jeg kunne angi geografisk posisjon
  
  @javascript
  Scenario: kartet vises ikke før man klikker "vis kart"
    Gitt at artikkelen "Foo" finnes
    Og jeg står på artikkelredigering for "Foo"
    Så skal jeg se "Angi sted for denne artikkelen"
    Og kartet skal være usynlig

  @javascript
  Scenario: kartet vises når man klikker "vis kart"
    Gitt at artikkelen "Foo" finnes
    Og jeg står på artikkelredigering for "Foo"
    Når jeg klikker "Angi sted for denne artikkelen"
    Så skal kartet vises

  @javascript
  Scenario: ikke tilegnet kart
    Gitt at artikkelen "Foo" finnes
    Og jeg står på artikkelredigering for "Foo"
    Når jeg trykker "Lagre"
    Så skal jeg ikke se noe kart

  @javascript
  Scenario: tilegnet kart
    Gitt at artikkelen "Foo" finnes
    Og jeg står på artikkelredigering for "Foo"
    Og jeg klikker "Angi sted for denne artikkelen"
    Og jeg fyller inn "geocoding" med "Billingstadsletta 17"
    Og jeg velger første element i autofullfør-listen
    Når jeg trykker "Lagre"
    Så skal kartet vises i artikkelen
