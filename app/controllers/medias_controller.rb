class MediasController < ApplicationController
  
  def new
  end
  
  def create
    m = Media.new
    if request.headers['HTTP_X_EXTUPLOADER'] == 'true'
      m.file = request.raw_post
      m.file.name = request.headers['HTTP_X_FILE_NAME']
    else
      m.attributes = params[:media]
    end
    m.save
    
    respond_to do |format|
      format.json { render :json => {:data => m.file.url, :media => m, :success => true} }
    end
    
  end
  
end
