class SearchController < ApplicationController
  rescue_from RSolr::RequestError, :with => :solr_error
  
  def new
    if params[:q]
      @search_result = Article.search do
        keywords params[:q] do
          highlight :text
        end
        
        paginate :page => params[:page], :per_page => 20
      end
    else
      redirect_to root_url
    end
  end

  private

  def solr_error(e)
    render "solr_error"
    ::Exceptional::Catcher.handle(e)
  end
end
