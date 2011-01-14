class ArticleList
  include Mongoid::Document

  embeds_many :articles, :class_name => 'ListArticle'
  embedded_in :page, :inverse_of => :article_list

  field :name
  field :number_of_articles, :type => Integer, :default => 5

  validates_presence_of :name

  def current_articles
    articles
  end
end
