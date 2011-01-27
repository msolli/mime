class SectionArticle
  include Mongoid::Document

  embedded_in :section, :inverse_of => :articles
  referenced_in :article

  field :headword
  field :date, :type => Date

  validates_presence_of :headword, :date

  class << self
    def new_from_article(article, date = Date.today)
      return nil unless article.is_a? Article
      SectionArticle.new.tap do |s|
        s.headword = article.headword_presentation
        s.date = date
        s.article = article
      end
    end
  end
end
