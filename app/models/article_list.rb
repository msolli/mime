class ArticleList
  include Mongoid::Document

  embeds_many :list_articles, as: :listable
  accepts_nested_attributes_for :list_articles, :allow_destroy => true, :reject_if => :all_blank

  field :name
  field :number_of_articles, type: Integer, default: 5
  field :position, type: Integer

  validates_presence_of :name

  def current_articles
    list_articles.pop number_of_articles
  end

  def <=>(other)
    self.position <=> other.position
  end

  def type
    self.class.to_s
  end
end
