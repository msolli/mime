class SortedArticleList < ArticleList
  include Mongoid::Document

  field :sort_direction, :type => Symbol
  field :sort_field, :type => Symbol

  validates_inclusion_of :sort_direction, :in => [:desc, :asc]
  validates_inclusion_of :sort_field, :in => Article.fields.keys.map(&:to_sym)

  def current_articles
    sorted_articles
  end

  private

  def sorted_articles
    Article.only(:_id, :headword, self.sort_field).send(self.sort_direction, self.sort_field).limit(self.number_of_articles).each do |article|
      self.articles << ListArticle.new(:headword => article.headword_presentation, :article => article)
    end
    self.articles
  end
end
