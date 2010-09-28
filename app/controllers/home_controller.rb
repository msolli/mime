class HomeController < ApplicationController
  def index
  end

  def alphabetic
    logger.debug "home#alphabetic"
    @articles = Article.where(:headword => /^#{params[:letter]}/i)
  end
end
