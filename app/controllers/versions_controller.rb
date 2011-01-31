class VersionsController < ApplicationController
  before_filter :find_article, :only => [:index]
  before_filter :article_not_found, :only => [:index]

  def index
    @versions = @article.versions
  end
end
