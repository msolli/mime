class Page
  include Mongoid::Document
  include Mime::Helpers::AssociationsHelper

  embeds_many :sections

  field :name

  validates_presence_of :name

end
