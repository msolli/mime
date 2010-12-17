# encoding: utf-8
# language: no
Egenskap: Artikkelliste i brukerprofil

  For at brukere skal få en oversikt over sine bidrag
  Som en lokalinteressert person
  Vil jeg kunne se en liste over artikler jeg har redigert

  Bakgrunn:
    Gitt at jeg har opprettet følgende artikler:
      | headword  | updated_at |
      | snerk     | 2010-10-04 |
      | bukse     | 2010-10-03 |
      | åker      | 2010-10-01 |
      | føner     | 2010-10-02 |
      | samlebånd | 2010-10-05 |
    Når jeg går til artikkeloversikten min

  @devise @logged_in
  Scenario: artikkeloversikt
    Så skal jeg se "samlebånd" først i artikkeloversikten

  @devise @logged_in
  Scenario: sortering på dato oppdatert, eldste først
    Når jeg klikker "Sist oppdatert"
    Så skal jeg se "åker" først i artikkeloversikten

  @devise @logged_in
  Scenario: sortering på oppslagsord, alfabetisk
    Når jeg klikker "Oppslagsord"
    Så skal jeg se "bukse" først i artikkeloversikten

  @devise @logged_in
  Scenario: sortering på oppslagsord, omvendt alfabetisk
    Når jeg klikker "Oppslagsord"
    Og jeg klikker "Oppslagsord"
    Så skal jeg se "åker" først i artikkeloversikten

  @devise @logged_in
  Scenario: sortering på dato publisert etter at det er sortert på oppslagsord
    Når jeg klikker "Oppslagsord"
    Og jeg klikker "Sist oppdatert"
    Så skal jeg se "samlebånd" først i artikkeloversikten

  @devise @logged_in
  Scenario: sortering på oppslagsord etter at det er sortert på dato oppdatert, eldste først
    Når jeg klikker "Sist oppdatert"
    Og jeg klikker "Oppslagsord"
    Så skal jeg se "bukse" først i artikkeloversikten
