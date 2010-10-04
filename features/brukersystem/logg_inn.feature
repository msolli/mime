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
