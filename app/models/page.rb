class Page
  include Mongoid::Document

  # embeds_many :sections
  embeds_many :article_lists

  field :name

  validates_presence_of :name

end
