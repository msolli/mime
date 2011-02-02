class ListArticle
  include Mongoid::Document

  embedded_in :listable, polymorphic: true
  referenced_in :article

  field :headword
  field :date, :type => Date

  validates_presence_of :headword

  class << self
    def new_from_article(article, date = Date.today)
      self.new.tap do |obj|
        obj.headword = article.headword_presentation
        obj.date = date
        obj.article = article
      end
    end
  end
end
