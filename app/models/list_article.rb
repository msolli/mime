class ListArticle
  include Mongoid::Document

  embedded_in :listable, polymorphic: true
  referenced_in :article

  field :headword
  field :date, :type => Date

  validates_presence_of :headword

  def initialize(article, date = Date.today)
    @date = date
    @headword = article.headword_presentation
    @article = article
  end
end
