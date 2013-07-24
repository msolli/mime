class SearchController < ApplicationController
  rescue_from RSolr::Error::Http, :with => :solr_error
  
  def new
    if params[:q]
      @search_result = Article.search do
        fulltext params[:q] do
          highlight :text
        end
        
        paginate :page => params[:page], :per_page => 20
      end
    end
    
    respond_to do |format|
      format.html
      format.mobile { render :layout => false }
    end
  end

  private

  def solr_error(e)
    render "solr_error"
    ::Exceptional::Catcher.handle(e)
  end
end
