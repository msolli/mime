class ArticleList
  include Mongoid::Document

  embeds_many :list_articles
  embedded_in :page, :inverse_of => :article_lists

  field :name
  field :number_of_articles, :type => Integer, :default => 5

  validates_presence_of :name

  def current_articles
    list_articles
  end
end
