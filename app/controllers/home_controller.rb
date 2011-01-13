# encoding: utf-8

class HomeController < ApplicationController
  def index
    flash.keep

    @page = Page.first(:conditions => {:name => ENV['FRONTPAGE'] || 'Forside'})
    return unless @page

    render :template => 'pages/show'
    expires_in 5.minutes, :public => true
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
    expires_in 5.minutes, :public => true
    flash.keep
  end
end
