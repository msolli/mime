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

    Scenario: geokoding
      Gitt at jeg står på artikkelredigering for "Foo"
      Og jeg fyller inn "Breddegrad" med "60"
      Og jeg fyller inn "Lengdegrad" med "10"
      Når jeg trykker "Lagre"
      Så skal jeg komme til artikkelvisning for "Foo"
