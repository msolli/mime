class MediasController < ApplicationController
  
  def new
  end
  
  def create
    m = Media.new params[:media]
    m.save
    
    respond_to do |format|
      format.json do
        obj = {:url => m.file.url, :media => m, :success => true, :size => "#{m.file.width}x#{m.file.height}"}
        if params[:size]
          t = m.file.thumb("#{params[:size]}>")
          obj[:thumb] = t.url
          obj[:thumb] = {:width => t.width, :height => t.height, :url => t.url}
        end
        
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
