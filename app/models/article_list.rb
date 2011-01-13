class ArticleList
  include Mongoid::Document

  embeds_many :articles, :class_name => 'ListArticle'
  embedded_in :page, :inverse_of => :article_list

  field :name
  field :date, :type => Date
  field :tags, :type => Array
  field :number_of_articles, :type => Integer, :default => 5

  validates_presence_of :name, :date

  def todays_articles
    if self.date == Date.today
      (self.articles.blank? ? randomize_articles! : self.articles)
    else
      randomize_articles!
    end
  end

  def randomize_articles!
    self.articles = []
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
