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

    @javascript
    Scenario: beskjed om at artikkelen er lagret
      Gitt at jeg står på artikkelredigering for "Foo"
      Når jeg trykker "Lagre"
      Og jeg skal se "Artikkelen er lagret" under "#notice"

    Scenario: anonym bidragsyter
      Gitt at jeg står på artikkelredigering for "Foo"
      Og jeg fyller inn "article[text]" med "Anonym sin tekst om foo"
      Når jeg trykker "Lagre"
      Og jeg klikker "Versjonslogg"
      Så skal jeg se "127.0.0.1" under "tr.current"

    @log_in_user
    Scenario: innlogget bidragsyter
      Og jeg står på artikkelredigering for "Foo"
      Og jeg fyller inn "article[text]" med "Ny tekst om foo"
      Når jeg trykker "Lagre"
      Og jeg klikker "Versjonslogg"
      Så skal jeg se "Navn Navnesen" under "table.versions"

    @javascript
    Scenario: tooltip skal vises ikke vises med mindre det fokuseres på et felt med data-tooltip-enable => true
      Når jeg står på artikkelredigering for "Foo"
      Så skal ".tooltip" være usynlig

    @javascript
    Scenario: Det skal være en lettfattelig måte å formatere artikler på
      Når jeg står på artikkelredigering for "Foo"
      Så skal "#article_text_editor" være usynlig
      Og jeg skal se formatert tekst med en verktøylinje
