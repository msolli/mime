# encoding: utf-8
Gitt /^at jeg er logget inn$/ do
  Gitt %{at jeg står på innloggingssiden}
  Og %{jeg klikker "Logg inn med Facebook"}
end

Når /^jeg logger inn$/ do
  Gitt %{at jeg er logget inn}
end

Når /^jeg logger ut$/ do
  Gitt %{at jeg står på forsiden}
  Og %{jeg klikker "Logg ut"}
end

Gitt /^(?:|at )jeg (?:logger|er logget) inn som en annen bruker$/ do
  facebook_stub 'user_2'
  Gitt %{at jeg er logget inn}
end
