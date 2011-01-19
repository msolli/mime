class SearchController < ApplicationController
  
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
  
end
