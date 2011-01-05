class Users::SessionsController < Devise::SessionsController
  respond_to :json, :only => :current

  def show
    @user = User.where(:email => params[:id]).first
    @articles = @user.articles.order_by(:updated_at.desc).limit(5)
  end

  def current
    respond_with({
      :user => (user_signed_in? ? current_user : nil),
      :flash => (flash.empty? ? nil : flash)
    })
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