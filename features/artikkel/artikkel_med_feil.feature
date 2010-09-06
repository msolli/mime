# language: no
Egenskap: Artikkel med feil

  For at leksikonet skal få artikler uten feil
  Som en lokalinteressert person
  Vil jeg ha gode feilmeldinger

  Bakgrunn: Skrevet ny artikkel med feil
    Gitt at jeg står på ny artikkel-siden

    Scenario: melding om at artikkel ikke ble lagret
      Når jeg trykker "Opprett"
      Så skal jeg se "ikke lagret"
