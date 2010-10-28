# encoding: utf-8

class HomeController < ApplicationController
  def index
  end

  def alphabetic
    @letter = params[:letter]
    @articles = Article.where(:headword => /^(\p{P})?#{@letter}/i)
  end
end
