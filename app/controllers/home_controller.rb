class HomeController < ApplicationController
  def index
  end

  def alphabetic
    @letter = params[:letter]
    @articles = Article.where(:headword => /^\W?#{@letter}/i)
  end
end
