class ListArticle
  include Mongoid::Document

  embedded_in :article_list, :inverse_of => :list_articles
  referenced_in :article

  field :headword

  validates_presence_of :headword

  class << self
    def new_from_article(article, date = Date.today)
      return nil unless article.is_a? Article
      ListArticle.new.tap do |s|
        s.headword = article.headword_presentation
        s.article = article
      end
    end
  end
end
