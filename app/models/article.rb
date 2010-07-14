class Article
  include Mongoid::Document

  field :headword

  validates_presence_of :headword
end
