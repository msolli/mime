class Page
  include Mongoid::Document

  embeds_many :manual_article_lists
  embeds_many :sorted_article_lists
  embeds_many :tags_article_lists

  accepts_nested_attributes_for :manual_article_lists, :allow_destroy => true

  field :name
  validates_presence_of :name
  validates_uniqueness_of :name

  def article_lists
    [*manual_article_lists, *sorted_article_lists, *tags_article_lists].sort
  end

  def frontpage?
    self.name == (ENV['FRONTPAGE'] || 'Forside')
  end
end
