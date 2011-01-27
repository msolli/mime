class TagsArticleList < ArticleList
  include Mongoid::Document

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
      (self.list_articles.blank? ? randomize_articles! : self.list_articles)
    else
      randomize_articles!
    end
  end

  def randomize_articles!
    self.list_articles.destroy_all
    if self.tags.blank?
      candidates = Article.only(:_id, :headword).all
    else
      candidates = Article.only(:_id, :headword).where(:tags_array.in => self.tags).all
    end
    self.number_of_articles.times do
      begin
        article = candidates[rand(candidates.length)]
      end while self.list_articles.include?(article)
      self.list_articles.push(ListArticle.new_from_article(article))
    end
    self.date = Date.today
    self.page.save if self.page
    self.list_articles
  end
end
