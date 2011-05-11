class Media
  include Mongoid::Document
  include Mongoid::Timestamps
  
  references_and_referenced_in_many :articles
  
  field :description, :type => String
  field :date, :type => DateTime
  field :author, :type => String
  field :file_uid, :type => String
  
  # attachment_accessor :file

  validates_presence_of :file, :author
end
