class Article
  include Mongoid::Document

  field :headword
  field :text

  validates_presence_of :headword
end
