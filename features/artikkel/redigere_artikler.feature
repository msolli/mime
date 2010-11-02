# encoding: utf-8
# language: no
Egenskap: Redigere artikler

  For at leksikonet skal få mange interessante artikler
  Som en lokalinteressert person
  Vil jeg kunne redigere artikler

  Bakgrunn:
    Gitt følgende artikler:
      | headword | text               |
      | Foo      | Masse tekst om foo |
      | Bar      | Tekst om bar       |

    Scenario: gå til artikkelredigering fra artikkelvisning
      Gitt at jeg står på artikkelvisning for "Foo"
      Når jeg klikker "Rediger"
      Så skal jeg komme til artikkelredigering for "Foo"

    Scenario: redigere tekst i artikkel
      Gitt at jeg står på artikkelredigering for "Foo"
      Og jeg fyller inn "article[text]" med "Ny tekst om foo"
      Når jeg trykker "Lagre"
      Så skal jeg se "Ny tekst om foo"
      Og jeg skal se "Artikkelen er lagret" under "#notice"

    Scenario: anonym bidragsyter
      Gitt at jeg står på artikkelredigering for "Foo"
      Og jeg fyller inn "article[text]" med "Anonym sin tekst om foo"
      Når jeg trykker "Lagre"
      Og jeg klikker "Versjonslogg"
      Så skal jeg se "127.0.0.1"

    @devise
    Scenario: innlogget bidragsyter
      Gitt at jeg er logget inn
      Og jeg står på artikkelredigering for "Foo"
      Og jeg fyller inn "article[text]" med "Ny tekst om foo"
      Når jeg trykker "Lagre"
      Og jeg klikker "Versjonslogg"
      Så skal jeg se "Navn Navnesen" under "table.versions"

    Scenario: legge til alternativt oppslagsord
      Gitt at jeg står på artikkelredigering for "Foo"
      Og jeg fyller inn "article[headword_presentation]" med "Føø"
      Når jeg trykker "Lagre"
      Så skal jeg se "Føø"
      Og jeg skal ikke se "Foo"

    @javascript
    Scenario: alternativt oppslagsord vises ikke når tomt
      Når jeg står på artikkelredigering for "Foo"
      Så skal feltet "article[headword_presentation]" ikke inneholde "Foo"
    
    @javascript
    Scenario: tooltip skal vises ikke vises med mindre det fokuseres på et felt med data-tooltip-enable => true
      Når jeg står på artikkelredigering for "Foo"
      Så skal ikke ".tooltip" være synlig
    
    @javascript
    Scenario: tooltip skal vises ved fokus på felt med attributet data-tooltip-enable => true
      Når jeg står på artikkelredigering for "Foo"
      Og jeg fyller inn "" for "article[headword_presentation]"
      Så skal ".tooltip" være synlig
