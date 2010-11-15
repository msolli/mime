# encoding: utf-8
# language: no
Egenskap: Brukerprofil

  For at brukere skal få en oversikt over sitt bidrag
  Som en lokalinteressert person
  Vil jeg kunne ha en brukerprofil

  @devise @logged_in @javascript
  Scenario: gå til brukerprofil
    Gitt at jeg står på forsiden
    Når jeg klikker "Navn Navnesen"
    Så skal jeg komme til brukerprofilen til "nn@example.com"
    Og jeg skal se "Navn Navnesen" i tittelen
