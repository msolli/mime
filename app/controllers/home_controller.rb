# encoding: utf-8

class HomeController < ApplicationController
  caches_action :index, expires_in: 5.minutes

  def index
    flash.keep

    @page = Page.first(:conditions => {:name => ENV['FRONTPAGE'] || 'Forside'})
    return unless @page

    expires_in 5.minutes, :public => true if Rails.env.production?
    respond_to do |format|
      format.html { render :template => 'pages/show' }
      format.mobile { render :template => 'mobile/frontpage'}
    end
  end

  def alphabetic
    @letter = params[:slug]
    # Handle Norwegian letter 'aa' -> 'å'
    headword_re = case @letter
      when 'å' then /^(\p{P})*(å|aa)/i
      when 'a' then /^(\p{P})*a[^a]/i
      else /^(\p{P})*#{@letter}/i
    end
    @articles = Article.where(:headword => headword_re).all.sort
    expires_in 5.minutes, :public => true if Rails.env.production?
    flash.keep
  end

  def last_updated
    articles = Article.desc(:updated_at).only(:_id, :headword, :user_ids, :updated_at, :ip)

    current_page = params[:page].blank? ? 1 : params[:page].to_i
    per_page = 10
    @articles_pager = WillPaginate::Collection.create(current_page, per_page, articles.size) do |pager|
      start = (current_page - 1) * per_page
      pager.replace(articles[start, per_page])
    end
  end
end
