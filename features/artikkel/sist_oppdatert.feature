# encoding: utf-8
# language: no
Egenskap: Sist oppdatert

  For at leksikonet skal framstå som oppdatert
  Som en lokalinteressert person
  Vil jeg kunne se når artikkelen er sist oppdatert

  @javascript
  Scenario: sist oppdatert akkurat nå
    Gitt at jeg står på ny artikkel-siden
    Og jeg fyller inn "article[headword]" med "Xyzzy-tittel"
    Og jeg fyller inn "article[text]" med "Xyzzy-artikkeltekst"
    Når jeg trykker "Opprett"
    Så skal jeg se "mindre enn et minutt"

  @javascript
  Scenario: sist oppdatert for over en uke siden
    Gitt at original-artikkelen "Foo" finnes
    Når jeg står på artikkelvisning for "Foo"
    Så skal jeg se "16. oktober 2008" under "time.timeago"
