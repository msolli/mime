# encoding: utf-8

class HomeController < ApplicationController
  def index
  end

  def alphabetic
    @letter = params[:letter]
    re = if @letter == 'å'
        /^(\p{P})*(å|aa)/i
      elsif @letter == 'a'
        /^(\p{P})*a[^a]/i
      else
        /^(\p{P})*#{@letter}/i
      end
    @articles = Article.where(:headword => re).all.sort do |a, b|
      a.headword_sorting <=> b.headword_sorting
    end
  end
end
