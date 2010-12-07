class ExternalLink < Link
  
  # field href from parent
  # field text from parent
  
  validates :href, :format => { :with => URI.regexp }
  
end
