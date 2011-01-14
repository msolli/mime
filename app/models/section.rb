class Section
  include Mongoid::Document

  embeds_many :articles, :class_name => 'SectionArticle'
  embedded_in :page, :inverse_of => :section

  field :name

  validates_presence_of :name
end