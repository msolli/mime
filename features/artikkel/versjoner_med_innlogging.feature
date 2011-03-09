# encoding: utf-8
# language: no
Egenskap: Versjonering av artikler med innlogget bruker

  For at leksikonet skal få artikler med god kvalitet
  Som en lokalinteressert person
  Vil jeg kunne versjonere artikler

  @log_in_user @javascript
  Scenario: innlogget og anonym versjon
    Gitt at jeg står på ny artikkel-siden
    Når jeg fyller inn "article[headword]" med "Foo"
    Og jeg trykker "Opprett"
    Og jeg klikker "Logg ut"
    Og jeg står på artikkelredigering for "Foo"
    Og jeg trykker "Lagre"
    Og jeg klikker "Versjonslogg"
    Så skal jeg se "2 versjoner"
    Og jeg skal se "127.0.0.1" under nåværende versjon
    Og jeg skal se "Navn Navnesen" under første versjon

  @stub_user
  Scenario: anonym og innlogget versjon
    Gitt at jeg står på ny artikkel-siden
    Og jeg fyller inn "article[headword]" med "Foo"
    Og jeg trykker "Opprett"
    Og jeg logger inn
    Når jeg står på artikkelredigering for "Foo"
    Og jeg trykker "Lagre"
    Og jeg klikker "Versjonslogg"
    Så skal jeg se "2 versjoner"
    Og jeg skal se "Navn Navnesen" under nåværende versjon
    Og jeg skal ikke se "127.0.0.1" under nåværende versjon
    Og jeg skal se "127.0.0.1" under første versjon

  @log_in_user @javascript
  Scenario: to ulike brukere
    Gitt at jeg oppretter artikkelen "Foo"
    Og jeg logger ut
    Og jeg logger inn som en annen bruker
    Når jeg står på artikkelredigering for "Foo"
    Og jeg trykker "Lagre"
    Og jeg klikker "Versjonslogg"
    Så skal jeg se "2 versjoner"
    Og jeg skal se "Test Testesen" under nåværende versjon
    Og jeg skal ikke se "Navn Navnesen" under nåværende versjon
    Og jeg skal se "Navn Navnesen" under første versjon

  @log_in_user
  Scenario: innlogget bidragsyter med flere artikler
    Gitt at jeg har opprettet følgende artikler:
      | headword  | updated_at |
      | snerk     | 2011-01-01 |
      | bukse     | 2011-01-01 |
    Og jeg står på artikkelredigering for "snerk"
    Og jeg fyller inn "article[text]" med "Ny tekst om snerk"
    Når jeg trykker "Lagre"
    Så skal "snerk" være sist oppdatert "i dag"
    Og så skal "bukse" være sist oppdatert "2011-01-01"
    Og så skal jeg være bidragsyter for 2 artikler
