class Users::SessionsController < Devise::SessionsController
  respond_to :json, :only => :current
  helper_method :sort_column, :sort_direction

  def show
    @user = User.where(:email => params[:id]).first
    @articles = @user.articles.sort_by {|a| a.send(sort_column)}
    @articles.reverse! if sort_direction == "desc"
  end

  def current
    respond_with(user_signed_in? ? current_user : nil)
  end

  private

  def sort_column
    %w[headword_sorting updated_at].include?(params[:sort]) ? params[:sort] : "headword_sorting"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
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