# encoding: utf-8
# language: no
Egenskap: Ny artikkel

  For at leksikonet skal få mange interessante artikler
  Som en lokalinteressert person
  Vil jeg kunne opprette artikler

  Bakgrunn: Skrevet ny artikkel
    Gitt at jeg står på ny artikkel-siden
    Og jeg fyller inn "article[headword]" med "Xyzzy-tittel"

    Scenario: opprette ny artikkel
      Når jeg trykker "Opprett"
      Så skal jeg komme til artikkelredigering for "Xyzzy-tittel"
      Og jeg skal se "Xyzzy-tittel"

    Scenario: anonym bidragsyter
      Når jeg trykker "Opprett"
      Og jeg klikker "Versjonslogg"
      Så skal jeg se "127.0.0.1" under "table.versions"

    @log_in_user
    Scenario: innlogget bruker
      Når jeg trykker "Opprett"
      Og jeg klikker "Versjonslogg"
      Så skal jeg se "Navn Navnesen" under "table.versions"
