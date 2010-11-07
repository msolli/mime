class Media
  include Mongoid::Document
  include Mongoid::Timestamps
  field :description, :type => String
  field :date, :type => DateTime
  field :author, :type => String
  field :file_uid, :type => String
  
  attachment_accessor :file
  
end
