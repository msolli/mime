# encoding: utf-8
# language: no

# Denne ligger i egen fil ettersom scenariet trenger javascript,
# og det funker dårlig dersom man har Bakgrunn og mange scenarier
# som ikke skal bruke @javascript

#TODO: http://code.google.com/p/selenium/issues/detail?id=543

# Egenskap: Ny artikkel med aloha editor
# 
#   For at leksikonet skal få mange interessante artikler
#   Som en lokalinteressert person
#   Vil jeg kunne opprette artikler med fin tekstredigering
# 
#   @javascript
#   Scenario: opprette ny artikkel med aloha editor som teksteditor
#     Gitt at jeg står på ny artikkel-siden
#     Og jeg fyller inn "Oppslagsord" med "Xyzzy-tittel"
#     Og jeg fyller inn "article[text]" med "Xyzzy-artikkeltekst"
#     Når jeg trykker "Opprett"
#     Så skal jeg komme til artikkelvisning for "Xyzzy-tittel"
#     Og jeg skal se "Artikkelen er lagret" under "#notice"
#     Og jeg skal se "Xyzzy-tittel"
#     Og jeg skal se "Xyzzy-artikkeltekst"
