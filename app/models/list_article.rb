class ListArticle
  include Mongoid::Document

  embedded_in :article_list, :inverse_of => :article
  referenced_in :article

  field :headword

  validates_presence_of :headword
end
