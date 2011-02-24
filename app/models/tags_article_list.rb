class TagsArticleList < ArticleList
  embedded_in :page, inverse_of: :tags_article_lists

  field :date, :type => Date
  field :tags, :type => Array

  validates_presence_of :date

  def current_articles
    todays_articles
  end

  def invalidate_articles!
    randomize_articles!
  end

  private

  def todays_articles
    if self.date == Date.today
      (self.list_articles.any? ? self.list_articles : randomize_articles!)
    else
      randomize_articles!
    end
  end

  def randomize_articles!
    # If self is embedded in page, destroy collection.
    # Otherwise just make an empty array to facilitate testing.
    if self.page
      self.list_articles.destroy_all
    else
      self.list_articles = []
    end

    if self.tags.blank?
      candidates = Article.only(:_id, :headword).all
    else
      candidates = Article.only(:_id, :headword).where(:tags_array.in => self.tags).all
    end

    self.number_of_articles.times do
      begin
        article = candidates[rand(candidates.length)]
      end while self.list_articles.map(&:article).include?(article)
      self.list_articles.push(ListArticle.new_from_article(article))
    end
    self.date = Date.today
    self.page.save if self.page
    self.list_articles
  end
end
