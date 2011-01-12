class MediasController < ApplicationController
  
  after_filter :prime_cache, :only => :create
  
  def new
  end
  
  def create
    if request.headers['X_IS_PLUPLOAD']
      @media = Media.new :file => params[:file]
    else
      @media = Media.new params[:media]
    end
    
    @media.save
    
    
    respond_to do |format|
      format.json do
        obj = {:url => @media.file.thumb(params[:size] || '250x150').url, :obj => @media}
        
        render :json => obj
      end 
    end
  end
  
  def edit
    @media = Media.find(params[:id])
  end
  
  def update
    # Not in use, but image editing in ckeditor depends on this if activated
    # @media = Media.find(params[:id])
    # respond_to do |format|
    #   format.json do
    #     render :json => {:media => @media, :url => @media.crop_zoom_url(params)}
    #   end
    # end
  end
  
  private
  def prime_cache
    thumb = @media.file.thumb("288x>")
    full_url = thumb.url(:host => "#{request.scheme}://#{request.host_with_port}")
    Rails.logger.debug "Priming #{thumb.url}"
    Rails.logger.debug "Fetching #{full_url}"
    open(full_url)
  end
  
end
