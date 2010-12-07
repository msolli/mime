class Link
  include Mongoid::Document
  field :href, :type => String
  field :text, :type => String
  
  def initialize(*args)
    raise NotImplementedError.new("Abstract class") if self.class == Link
    super
  end
  
  def text
    self.read_attribute(:text) || self.href
  end
end
