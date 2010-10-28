# encoding: utf-8

class HomeController < ApplicationController
  def index
  end

  def alphabetic
    @letter = params[:letter]
    # Handle Norwegian letter 'aa' -> 'å'
    headword_re = case @letter
      when 'å' then /^(\p{P})*(å|aa)/i
      when 'a' then /^(\p{P})*a[^a]/i
      else /^(\p{P})*#{@letter}/i
    end
    @articles = Article.where(:headword => headword_re).all.sort do |a, b|
      a.headword_sorting <=> b.headword_sorting
    end
  end
end
