# encoding: utf-8
# language: no
Egenskap: Artikkel finnes ikke

  For at leksikonet skal få så mange artikler som mulig
  Som en person som har gått til en ikke-eksisterende side
  Vil jeg bli ledet videre til å opprette den
  
  Scenario: Gått til en side som ikke eksisterer
    Gitt at jeg går til artikkelvisning for "123456"
    Så skal jeg få "404" som respons
    Og jeg skal se "The page you were looking for doesn't exist."
