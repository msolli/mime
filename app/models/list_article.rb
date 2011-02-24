class ListArticle
  include Mongoid::Document

  embedded_in :listable, polymorphic: true
  referenced_in :article

  field :headword
  field :published_on, :type => Date

  before_validation :find_referenced_article
  after_initialize :find_referenced_article
  validates_presence_of :headword, :article_id

  class << self
    def new_from_article(article, published_on = Date.today)
      self.new.tap do |obj|
        obj.headword = article.headword_presentation
        obj.published_on = published_on
        obj.article = article
      end
    end
  end

  protected

  def find_referenced_article
    self.article ||= Article.first(conditions: {headword: self.headword})
    if headword.present? && article.blank?
      errors[:headword] = I18n.t('mongoid.errors.models.list_article.attributes.headword.no_article')
    end
  end
end
