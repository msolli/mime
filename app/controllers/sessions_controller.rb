class SessionsController < Devise::SessionsController
  # POST /users/sign_in
  def create
    redirect_to "https://auth.tek.no/?" +
                "email=#{Rack::Utils.escape(params['user']['email'])}" +
                "&password=#{Rack::Utils.escape(params['user']['password'])}" +
                "&referer=#{Rack::Utils.escape(users_sso_callback_url)}"
  end

  # GET /users/sso_callback
  def sso_callback
    if params[:error] == "wrong_password"
      flash.alert = "Feil passord"
      render :action => :new
    elsif params[:authId]
      resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
      set_flash_message :notice, :signed_in
      sign_in_and_redirect(resource_name, resource)
    end
  end
end

__END__

== EDDA SSO ==

  Bruker som har vært logget på Edda:
Forside: Vanlig, med Devise-lenker (bra for caching)

Logg inn:
  1. finn authId i cookies
  2. verification mot tek.no
      - dersom ok, fyll inn brukerinfo med data fra tek.no (der dette ikke finnes fra før) og logg inn og avslutt
      - dersom ikke ok, gå videre
  3. Vis innloggingsskjema
  4. redirect til tek.no signin
  5. I callback, sjekk om authId ble satt, eller error ble satt