class JsonSearchController < ActionController::Metal
  include Rails.application.routes.url_helpers # Access to route helpers
  include ActionController::Rendering # render method
  include ActionController::Renderers::All # json support
  
  # params:
  # * :model - Article
  # * :query - keyword query
  # * :num   - number of hits
  def new
    if params[:model] && params[:query]
      _model = params[:model].capitalize.constantize
      if _model.searchable?
        res = _model.search do
          keywords params[:query] do
            fields(:headword)
          end
          paginate :page => 1, :per_page => params[:num] || 10
        end
        
        render :json => result_to_render(res)
      else
        render :status => :bad_request, :json => {:message => "#{_model.to_s} not searchable"}
      end
    else
      render :status => :bad_request, :text => 'Missing model or query or both parameters'
    end
  end
  
  private
  def result_to_render(result)
    results = []
    result.results.each do |result|
      results << {:headword => result.headword, :url => pretty_article_path(result)}
    end
    results
  end
  
end
