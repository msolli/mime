# encoding: utf-8
# language: no
Egenskap: Logge inn med Facebook-konto

  For at artikler skal ha bidragsyternes navn
  Som en lokalinteressert person
  Vil jeg kunne logge inn med Facebook-kontoen min

  @stub_user @javascript
  Scenario: logge inn
    Gitt at jeg står på forsiden
    Når jeg klikker "Logg inn med Facebook"
    Så skal jeg komme til forsiden
    Og jeg skal se "Logget inn som Navn Navnesen"

  @log_in_user @javascript
  Scenario: logge ut
    Og at jeg står på forsiden
    Når jeg klikker "Logg ut"
    Så skal jeg komme til forsiden
    Og jeg skal se "Logg inn"

  @javascript
  Scenario: få beskjed om at du kan logge inn når du redigerer en artikkel
    Gitt at artikkelen "Foo" finnes
    Og at jeg står på artikkelvisning for "Foo"
    Når jeg klikker "Rediger"
    Så skal jeg komme til artikkelredigering for "Foo"
    Og jeg skal se "logge inn"

  @stub_user @javascript
  Scenario: bli sendt til artikkelredigering når man logger inn fra artikkelredigering
    Gitt at artikkelen "Foo" finnes
    Og at jeg står på artikkelredigering for "Foo"
    Når jeg klikker "logge inn"
    Så skal jeg komme til artikkelredigering for "Foo"
    Og jeg skal se "logget inn"

  @stub_user @javascript
  Scenario: bli sendt til artikkelredigering når man logger inn fra ny artikkel-visning
    Gitt at jeg står på ny artikkel-siden
    Når jeg klikker "logge inn"
    Så skal jeg komme til ny artikkel-siden
    Og jeg skal se "logget inn"

  @stub_user @javascript
  Scenario: bli sendt til artikkelvisning når man logger inn fra artikkelvisning
    Gitt at artikkelen "Foo" finnes
    Og jeg står på artikkelvisning for "Foo"
    Når jeg klikker "Logg inn"
    Så skal jeg komme til artikkelvisning for "Foo"
    Og jeg skal se "logget inn"
