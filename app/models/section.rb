class Section
  include Mongoid::Document

  embeds_many :articles, :class_name => 'SectionArticle'
  embedded_in :page, :inverse_of => :sections

  field :name

  validates_presence_of :name

  def current_articles
    self.articles.desc(:date).limit(4)
  end
end
