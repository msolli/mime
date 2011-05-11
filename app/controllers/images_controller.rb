class ImagesController < ApplicationController
  before_filter :find_article, :only => [:index]
  before_filter :article_not_found, :only => [:index]

  def index
    @images = Image.order_by(:updated_at).limit(12)
  end

end
