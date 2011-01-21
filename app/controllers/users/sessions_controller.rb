class Users::SessionsController < Devise::SessionsController
  respond_to :json, :only => :current

  def show
    @user = User.where(:email => params[:id]).first
    @articles = @user.articles.order_by(:updated_at.desc).limit(5)
  end

  def current
    resp = {
      :user => (user_signed_in? ? current_user : nil),
      :flash => (flash.empty? ? nil : flash)
    }
    if is_ie6?
      # Handle evil IE6 Accept header
      respond_with(resp) do |format|
        format.html { render :text => resp.to_json, :content_type => 'application/json' }
      end
    else
      respond_with resp
    end
  end
end
