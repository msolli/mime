class VersionsController < ApplicationController
  before_filter :find_article, :only => [:index]

  def index
    @versions = @article.versions
  end
end
