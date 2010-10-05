# language: no
Egenskap: Logge inn med Facebook-konto

  For at artikler skal ha bidragsyternes navn
  Som en lokalinteressert person
  Vil jeg kunne logge inn med Facebook-kontoen min

  Scenario: Gå til innloggingssiden
    Gitt at jeg står på forsiden
    Når jeg klikker "Logg inn"
    Så skal jeg komme til innloggingssiden

  @devise
  Scenario: logge inn
    Gitt at jeg står på innloggingssiden
    Når jeg klikker "Logg inn med Facebook"
    Så skal jeg komme til forsiden
    Og jeg skal se "Logget inn som"

  @devise
  Scenario: logge ut
    Gitt at jeg er logget inn
    Og at jeg står på forsiden
    Når jeg klikker "Logg ut"
    Så skal jeg komme til forsiden
    Og jeg skal se "Logg inn"

  Scenario: få beskjed om at du kan logge inn når du redigerer en artikkel
    Gitt at artikkelen "Foo" finnes
    Og at jeg står på artikkelvisning for "Foo"
    Når jeg klikker "Redigér"
    Så skal jeg komme til artikkelredigering for "Foo"
    Og jeg skal se "logge inn"

  @devise
  Scenario: bli sendt til artikkelredigering når man logger inn fra artikkelredigering
    Gitt at artikkelen "Foo" finnes
    Og at jeg står på artikkelredigering for "Foo"
    Når jeg klikker "logge inn"
    Så skal jeg komme til artikkelredigering for "Foo"
    Og jeg skal se "logget inn"

  @devise
  Scenario: bli sendt til artikkelredigering når man logger inn fra ny artikkel-visning
    Gitt at jeg står på ny artikkel-siden
    Når jeg klikker "logge inn"
    Så skal jeg komme til ny artikkel-siden
    Og jeg skal se "logget inn"
