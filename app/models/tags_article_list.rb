class TagsArticleList < ArticleList
  embedded_in :page, inverse_of: :tags_article_lists

  field :date, type: Date, default: Date.today
  field :tags_array, type: Array, default: []

  before_validation :remove_duplicate_tags

  validates :date, presence: true

  def tags=(tags)
    self.tags_array = tags.split(',').map(&:strip)
  end

  def tags
    (self.tags_array || []).join(', ')
  end

  def tags_array
    self[:tags_array] || self[:tags_array] = []
  end

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

    if self.tags_array.blank?
      candidates = []
    else
      candidates = Article.only(:_id, :headword).where(:tags_array.in => self.tags_array).all
    end

    if candidates.length > 0
      self.number_of_articles.times do
        i = 0
        begin
          article = candidates[rand(candidates.length)]
          i += 1
        end while self.list_articles.map(&:article).include?(article) && i < (self.number_of_articles * 10)
        unless self.list_articles.map(&:article).include?(article)
          la = ListArticle.new(headword: article.headword)
          la.valid?
          self.list_articles.push(la)
        end
      end
    end
    self.date = Date.today
    self.page.save if self.page
    self.list_articles
  end

  def remove_duplicate_tags
    self[:tags_array].uniq! if self[:tags_array]
  end
end
