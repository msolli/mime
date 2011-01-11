class OnImageUpload
  
  include HerokuDelayedJobAutoscale::Autoscale
  
  def initialize(media)
    @media = media
  end
  
  def perform
    Rails.logger.info "Would perform action"
  end
  
  
end