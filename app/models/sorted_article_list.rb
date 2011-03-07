class SortedArticleList < ArticleList
  embedded_in :page, inverse_of: :sorted_article_lists

  field :sort_direction, :type => Symbol
  field :sort_field, :type => Symbol

  validates :sort_direction, inclusion: [:desc, :asc]
  validates :sort_field, inclusion: Article.fields.keys.map(&:to_sym)

  def current_articles
    sorted_articles
  end

  private

  def sorted_articles
    self.list_articles.destroy_all
    Article.only(:_id, :headword, self.sort_field).send(self.sort_direction, self.sort_field).limit(self.number_of_articles).each do |article|
      la = ListArticle.new(headword: article.headword)
      la.valid?
      self.list_articles.push(la)
    end
    self.list_articles
  end
end
