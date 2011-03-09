# encoding: utf-8
# language: no
Egenskap: Brukerprofil

  For at brukere skal få en oversikt over sitt bidrag
  Som en lokalinteressert person
  Vil jeg kunne ha en brukerprofil

  @log_in_user @javascript
  Scenario: gå til brukerprofil
    Gitt at jeg står på forsiden
    Når jeg klikker "Navn Navnesen"
    Så skal jeg komme til brukerprofilen til "nn@example.com"
    Og jeg skal se "Navn Navnesen" i tittelen

  @log_in_user
  Scenario: ny artikkel vises på brukerprofil
    Gitt at jeg oppretter artikkelen "Foo"
    Når jeg går til brukerprofilen min
    Så skal jeg se "Foo" i artikkel-lista

  @log_in_user
  Scenario: endret artikkel vises på brukerprofil
    Gitt at artikkelen "Foo" finnes
    Og jeg står på artikkelredigering for "Foo"
    Og jeg trykker "Lagre"
    Når jeg går til brukerprofilen min
    Så skal jeg se "Foo" i artikkel-lista

  # @log_in_user
  # Scenario: fem artikler vises på brukerprofil
  #   Gitt at jeg har opprettet følgende artikler:
  #     | headword |
  #     | Foo en   |
  #     | Foo to   |
  #     | Foo tre  |
  #     | Foo fire |
  #     | Foo fem  |
  #   Når jeg går til brukerprofilen min
  #   Så skal jeg se 5 artikler i artikkel-lista
