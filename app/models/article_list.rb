class ArticleList
  include Mongoid::Document

  embeds_many :list_articles, :as => :listable
  embedded_in :page

  field :name
  field :number_of_articles, :type => Integer, :default => 5

  validates_presence_of :name

  def current_articles
    list_articles.pop number_of_articles
  end
end
