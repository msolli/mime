class SectionArticle
  include Mongoid::Document

  embedded_in :section, :inverse_of => :articles
  referenced_in :article

  field :headword
  field :date, :type => Date

  validates_presence_of :headword, :date

end
