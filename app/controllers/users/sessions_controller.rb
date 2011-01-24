class Users::SessionsController < Devise::SessionsController
  respond_to :json, :only => :current

  def show
    @user = User.where(:email => params[:id]).first
    if @user.nil?
      render :file => "#{Rails.public_path}/404.html" , :status => :not_found, :layout => false
      log "USER NOT FOUND #{params[:id]} | #{request.referrer} | #{request.user_agent} | #{request.ip}"
      return
    end
    @articles = @user.articles.order_by(:updated_at.desc).limit(5)
  end

  def current
    respond_with({
      :user => (user_signed_in? ? current_user : nil),
      :flash => (flash.empty? ? nil : flash)
    })
  end
end
