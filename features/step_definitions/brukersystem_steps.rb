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

Gitt /^(?:|at )jeg (?:logger|er logget) inn som "([^"]*)"$/ do |user|
  facebook_stub user
  Gitt %{at jeg er logget inn}
end
