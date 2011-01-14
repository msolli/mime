class TagsArticleList < ArticleList
  include Mongoid::Document

  field :date, :type => Date
  field :tags, :type => Array

  validates_presence_of :date

  def current_articles
    todays_articles
  end

  private

  def todays_articles
    if self.date == Date.today
      (self.articles.blank? ? randomize_articles! : self.articles)
    else
      randomize_articles!
    end
  end

  def randomize_articles!
    self.articles.destroy_all
    if self.tags.blank?
      candidates = Article.only(:_id, :headword).all
    else
      candidates = Article.only(:_id, :headword).where(:tags_array.in => self.tags).all
    end
    self.number_of_articles.times do
      begin
        article = candidates[rand(candidates.length)]
      end while self.articles.include?(article)
      self.articles << ListArticle.new(:headword => article.headword_presentation, :article => article)
    end
    self.date = Date.today
    self.save
    self.articles
  end
end
