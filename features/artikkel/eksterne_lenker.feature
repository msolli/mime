# encoding: utf-8
# language: no
Egenskap: Eksterne lenker i artikler

  For at leksikonet skal være å presist og altomfattende som mulig
  Som en lokalinteressert person
  Vil jeg kunne legge inn eksterne lenker på artikler

  Scenario: ingen eksterne lenker i eksisterende artikkel
    Gitt at artikkelen "Foo" finnes
    Når jeg står på artikkelvisning for "Foo"
    Så skal jeg ikke se eksterne lenker

  Scenario: ingen eksterne lenker i ny artikkel
    Gitt at jeg står på ny artikkel-siden
    Og jeg fyller inn "article[headword]" med "Xyzzy-tittel"
    Når jeg trykker "Opprett"
    Så skal jeg ikke se eksterne lenker

  Scenario: opprette eksterne lenker i en artikkel
    Gitt at artikkelen "Foo" finnes
    Og jeg står på artikkelredigering for "Foo"
    Når jeg fyller inn "Adresse" med "http://budstikka.no"
    Og jeg fyller inn "Lenketekst" med "Dette er en ekstern lenke til Budstikka"
    Og jeg trykker "Lagre"
    Så skal jeg se "Dette er en ekstern lenke til Budstikka" under ".external-links"

  @javascript
  Scenario: legge til flere felter for eksterne lenker
    Gitt at artikkelen "Foo" finnes
    Og jeg står på artikkelredigering for "Foo"
    Så skal det være 1 eksterne lenker-felt
    Når jeg klikker "Ny ekstern lenke"
    Så skal det være 2 eksterne lenker-felt
    Når jeg klikker "slett" under den siste eksterne lenken
    Så skal det være 1 eksterne lenker-felt
