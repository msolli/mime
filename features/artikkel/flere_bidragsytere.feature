# encoding: utf-8
# language: no
Egenskap: Flere bidragsytere

  For at leksikonet skal fremstå som etterrettelig
  Som en lokalinteressert person
  Vil jeg kunne se når artikler har flere bidragsytere

  Bakgrunn:
    Gitt at artikkelen "Foo" har følgende bidragsytere:
      | email       | name       |
      | yo@yo.com   | Yoman Yo   |
      | foo@foo.com | Fooman Foo |

    Scenario: to bidragsytere i versjonsloggen
      Når jeg står på versjonsloggen for "Foo"
      Så skal jeg se "Yoman Yo, Fooman Foo"
      Og jeg skal se "bare én versjon"

    @log_in_user
    Scenario: ny versjon, ny forfatter
      Og jeg står på artikkelredigering for "Foo"
      Og jeg fyller inn "article[text]" med "Ny tekst om foo"
      Når jeg trykker "Lagre"
      Og jeg klikker "Versjonslogg"
      Så skal jeg se "Navn Navnesen" under "table.versions"
      Og jeg skal se "Yoman Yo, Fooman Foo"
