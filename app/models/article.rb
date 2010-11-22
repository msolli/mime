# encoding: utf-8

class Article
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Versioning

  references_many :users, :stored_as => :array, :inverse_of => :articles
  alias :authors :users
  alias :authors= :users=
  
  references_many :medias, :stored_as => :array, :inverse_of => :articles
  embeds_one :location

  field :headword
  field :headword_presentation
  field :text
  field :definition
  field :years, :type => Array
  field :end_year, :type => Date
  field :ambiguous, :type => Boolean
  field :ip
  field :tags_array, :type => Array

  index :headword, :unique => true
  index [[ 'location.lat_lng', Mongo::GEO2D ]]

  validates_presence_of :headword
  validates_uniqueness_of :headword
  validates_associated :location
  
  accepts_nested_attributes_for :location
  
  # We do this because mongodb doesn't allow index fields to be null
  # They can however be absent from the document…
  set_callback :save, :before, lambda {|article| article.location = nil if article.location.blank?}

  before_save :update_headword_sorting

  NO_SORT = %w(a b c d e f g h i j k l m n o p q r s t u v w x y z æ ø å)

  def to_param
    self.headword.gsub(/ /, '_').gsub(/\//, '%2F')
  end
  
  def slug_is?(slug)
    to_param == slug.gsub(/\//, '%2F')
  end

  def headword_presentation
    self[:headword_presentation].blank? ? headword : self[:headword_presentation]
  end

  def headword_presentation=(new_value)
    self[:headword_presentation] = (new_value == self[:headword] ? nil : new_value)
  end

  def headword_sorting
    self[:headword_sorting] || update_headword_sorting
  end

  def <=>(other)
    self.headword_sorting <=> other.headword_sorting
  end

  def authors_or_ip
    self.users.blank? ? ip : self.users.map(&:name_or_email).join(', ')
  end

  def tags=(tags)
    self.tags_array = tags.split(',').map(&:strip)
  end

  def tags
    (self.tags_array || []).join(', ')
  end

  def tags_array
    (self[:tags_array] || [])
  end

  class << self
    def without_versioning(&block)
      without_callback(:save, :before, :revise) { yield }
    end
  end

  private

  def update_headword_sorting
    array = self[:headword].mb_chars.downcase.gsub(/aa/, 'å').scan(/./)
    self[:headword_sorting] = array.map {|c| NO_SORT.index(c)}.compact.map {|c| (c + 'a'.ord).chr}.join
  end
end
