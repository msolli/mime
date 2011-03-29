# encoding: utf-8
# language: no
Egenskap: Oppslagsord skiller ikke mellom store og små bokstaver

  For at leksikonet skal være lett å hacke URL-ene til
  Som en detaljfiksert utvikler
  Vil jeg ha oppslagsord som ikke skiller mellom store og små bokstaver
  
  @javascript
  Abstrakt Scenario: store og små bokstaver
    Gitt at artikkelen "<headword>" finnes
    Når jeg går til artikkelvisning for "<url-segment>"
    Så skal jeg se "<headword>" under "article h1"
    Og jeg skal se "<url-segment>" under ".redirected"

    Eksempler:
      | headword        | url-segment     |
      | Foo             | foo             |
      | Foo / bar       | foo / bar       |
      | Foo & bar       | foo & BAR       |
      | Foo.x & bar.y   | foo.X & BAR.y   |
      | Øy              | øy              |
      | øy              | Øy              |
      | Aa              | aa              |
      | Gøy (på landet) | gøy (pÅ landet) |
