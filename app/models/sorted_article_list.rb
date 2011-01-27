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
    self.list_articles.destroy_all
    Article.only(:_id, :headword, self.sort_field).send(self.sort_direction, self.sort_field).limit(self.number_of_articles).each do |article|
      self.list_articles.push(ListArticle.new_from_article(article))
    end
    self.list_articles
  end
end
