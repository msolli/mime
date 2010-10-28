# encoding: utf-8

class HomeController < ApplicationController
  def index
  end

  def alphabetic
    @letter = params[:letter]
    @articles = Article.where(:headword => /^(\p{P})*#{@letter}/i).all.sort do |a, b|
      a.headword.sub(/^(\p{P})+/, '').mb_chars.downcase <=> b.headword.sub(/^(\p{P})+/, '').mb_chars.downcase
    end
  end
end
