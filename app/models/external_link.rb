class ExternalLink < Link
  
  # field href from parent
  # field text from parent
  
  embedded_in :article, :inverse_of => :external_links
  
  validates :href, :format => { :with => URI.regexp }
  
end
