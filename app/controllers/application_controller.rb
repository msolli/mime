class ApplicationController < ActionController::Base

  protect_from_forgery
  layout 'application'

  before_filter :set_locale, :keep_flash
  
  private
  
  def keep_flash
    flash.keep
  end

  def find_article
    @slug = if !params[:slug].blank?
      params[:slug]
    elsif !params[:article_id].blank?
      params[:article_id]
    else
      params[:id]
    end
    rescue_connection_failure do
      @article = Article.where(:headword => /^#{Regexp.escape(deparameterize(@slug))}$/i).first
    end
  end

  def article_not_found
    if @article.nil?
      respond_to do |format|
        format.html { render :file => "#{Rails.public_path}/404.html" , :status => :not_found, :layout => false }
        format.json { render :status => :not_found, :text => ''}
      end
      log "404 NOT FOUND #{params[:slug]}"
      return false
    end
  end

  def deparameterize(thing)
    thing.gsub(/%2F/, '/').gsub(/_/, ' ')
  end

  def set_user_return_to(path)
    session[:user_return_to] = path
  end

  def set_locale
    I18n.locale = :'no-NB'
    WillPaginate::ViewHelpers.pagination_options[:previous_label] = I18n.t('will_paginate.previous')
    WillPaginate::ViewHelpers.pagination_options[:next_label] = I18n.t('will_paginate.next')
  end

  def request_info
    " | #{request.referrer} | #{request.user_agent} | #{request.ip}"
  end

  def log(message)
    message += request_info if request
    Rails.env.production? ? puts(message) : Rails.logger.debug(message)
  end

  def action_not_found
    render :file => "#{Rails.public_path}/404.html", :status => :not_found, :layout => false
    log "ACTION NOT FOUND #{controller_name}##{action_name}"
  end

  def rescue_connection_failure(max_retries = 3)
    retries = 0
    begin
      yield
    rescue Mongo::ConnectionFailure => ex
      retries += 1
      raise ex if retries > max_retries
      sleep(0.5)
      retry
    end
  end
end
