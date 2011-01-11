class OnImageUpload
  include HerokuDelayedJobAutoscale::Autoscale
  include Rails.application.routes.url_helpers
  
  WANTED_IMAGE_GEOMETRIES = ['288x>']
  HOSTS = Rails.env.production? ? %w(beta.ableksikon.no ableksikon.no www.ableksikon.no) : ['localhost:3000']
  
  def initialize(media)
    @media = media
  end
  
  def perform
    urls = []
    HOSTS.each do |host|
      urls << heat_image_tag_url(@media.id, :host => host)
      WANTED_IMAGE_GEOMETRIES.each{|geo| urls << @media.file.thumb(geo).url(:host => host) }  
    end
    
    
    Curl::Multi.get(urls) do |easy|
      Rails.logger.debug "Fetched #{easy.url}"
    end
  end
  
  
end