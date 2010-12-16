class Media
  include Mongoid::Document
  include Mongoid::Timestamps
  
  references_many :articles, :stored_as => :array, :inverse_of => :medias
  
  field :description, :type => String
  field :date, :type => DateTime
  field :author, :type => String
  field :file_uid, :type => String
  
  attachment_accessor :file
  
  validates_presence_of :file
end
