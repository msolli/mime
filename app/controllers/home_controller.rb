# encoding: utf-8

class HomeController < ApplicationController
  def index
    @featured = Article.any_in(:headword => ["ABB AS", "Vøyenenga skole", "Sandvikselva", "Sandvika stasjon"])
    expires_in 5.minutes, :public => true
    flash.keep
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
