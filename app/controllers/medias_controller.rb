class MediasController < ApplicationController
  
  def new
  end
  
  def create
    if request.headers['X_IS_PLUPLOAD']
      m = Media.new :file => params[:file]
    else
      m = Media.new params[:media]
    end
    
    m.save
    
    respond_to do |format|
      format.json do
        obj = {:url => m.file.thumb(params[:size] || '250x150').url, :obj => m}
        
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
  
end
