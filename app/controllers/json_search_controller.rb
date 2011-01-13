class JsonSearchController < ActionController::Metal
  include Rails.application.routes.url_helpers # Access to route helpers
  include ActionController::Rendering # render method
  include ActionController::Renderers::All # json support
  
  # params:
  # * :model - Article
  # * :query - keyword query
  # * :num   - number of hits
  # * :qfields - Fields to query
  # * :rfields - Fields to return, space separated
  def new
    if params[:model] && params[:query]
      _model = params[:model].capitalize.constantize
      if _model.searchable?
        res = _model.search do
          if params[:qfields]
            _fields = params[:qfields].split
            keywords params[:query] do
              fields(*_fields)
            end
          else
            keywords params[:query]
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
    rfields = (params[:rfields] || "url headword").split.map(&:to_sym)
    result.results.each do |result|
      obj = {}
      obj[:url] = pretty_article_path(result) if result.is_a?(Article)
      
      rfields.each do |field|
        return if field == :url
        obj[field] = result.send(field)
      end
      
      results << obj
    end
    results
  end
  
end
