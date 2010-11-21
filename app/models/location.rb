class Location
  include Mongoid::Document
  
  embedded_in :article, :inverse_of => :location
  
  # We can't use latitude and longitude as seperate fields
  # because of a constraint in the way mongodb handles
  # 2d-indices and mongoid handles embedded documents.
  field :lat_lng, :type => Hash, :default => {}
  field :zoom, :type => Integer, :default => 13
  
  # Limitation in mongoid requires this index to be set in article model
  # index [[ :lat_lng, Mongo::GEO2D ]]
  
  def latitude
    self.lat_lng['latitude']
  end  
  def latitude=(val)
    self.lat_lng['latitude'] = val.blank? ? nil : val.to_f
  end
  
  def longitude
    self.lat_lng['longitude']
  end
  
  def longitude=(val)
    self.lat_lng['longitude'] = val.blank? ? nil : val.to_f
  end
  
  def blank?
    longitude.blank? && latitude.blank?
  end
  
  def static_map(size = '300x150')
    params = ["size=#{size}"]
    params << 'sensor=false'
    params << "zoom=#{zoom}"
    params << "markers=#{latitude},#{longitude}"
    
    
    "http://maps.google.com/maps/api/staticmap?" + params.join('&')
  end
  
  alias :lat    :latitude
  alias :lng    :longitude
  alias :long   :longitude
  alias :lat=   :latitude=
  alias :lng=   :longitude=
  alias :long=  :longitude=
  
  validates :latitude,
    :numericality => {:greater_than_or_equal_to => -90, :less_than_or_equal_to => 90},
    :unless => Proc.new{|l| l.longitude.blank? }
  validates :longitude, 
    :numericality => {:greater_than_or_equal_to => -180, :less_than_or_equal_to => 180},
    :unless => Proc.new{|l| l.latitude.blank? }
end
