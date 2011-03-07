class ListArticle
  include Mongoid::Document

  embedded_in :listable, polymorphic: true
  referenced_in :article

  field :headword
  field :published_on, :type => Date

  before_validation :set_headword_presentation
  validates :headword, presence: true
  validates :article, presence: true, if: Proc.new { |a| a.headword.present? }

  protected

  def find_referenced_article
    self.article ||= Article.first(conditions: {headword: self.headword})
  end

  def set_headword_presentation
    self.article || find_referenced_article
    self.headword = self.article.headword_presentation if self.article
  end
end
