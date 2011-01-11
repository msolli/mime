class CacheTriggerController < ApplicationController
  
  def heat_image_tag
    if params[:id]
      image = Media.find(params[:id])
      render :partial => 'medias/image_in_article', :locals => {:image => image}
    else
      render :nothing => true
    end
  end

end
