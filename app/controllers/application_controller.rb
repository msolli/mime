class ApplicationController < ActionController::Base
  rescue_from NoMethodError, :with => :log_no_method_error

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
    @article = Article.where(:headword => /^#{Regexp.escape(deparameterize(@slug))}$/i).first
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

  def log(message)
    Rails.env.production? ? puts(message) : Rails.logger.debug(message)
  end

  def action_not_found
    render :file => "#{Rails.public_path}/404.html" , :status => :not_found, :layout => false
    log "ACTION NOT FOUND #{controller_name}##{action_name} | #{request.referrer} | #{request.user_agent} | #{request.ip}"
  end

  def log_no_method_error(e)
    log "EXCEPTION NoMethodError"
    log e.backtrace.join('\n')
    render :file => "#{Rails.public_path}/404.html" , :status => :not_found, :layout => false
  end
end
