# encoding: utf-8

class Article
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Versioning

  referenced_in :user
  alias :author :user
  alias :author= :user=

  field :headword
  field :headword_presentation
  field :text
  field :definition
  field :years, :type => Array
  field :end_year, :type => Date
  field :ambiguous, :type => Boolean
  field :location, :type => Array
  field :ip

  index :headword, :unique => true
  index [[ :location, Mongo::GEO2D ]]

  validates_presence_of :headword
  validates_uniqueness_of :headword
  validates :location, :location => true

  attr_protected :ip

  def headword_presentation
    self[:headword_presentation].blank? ? headword : self[:headword_presentation]
  end

  def headword_presentation=(new_value)
    self[:headword_presentation] = (new_value == self[:headword] ? nil : new_value)
  end

  def headword_sorting
    self[:headword].sub(/^(\p{P})+/, '').mb_chars.downcase.sub(/aa/, 'å')
  end

  def author_or_ip
    self.user ? self.user.name_or_email : ip
  end

  def lat
    self.location ? self.location[0] : nil
  end

  def lat=(latitude)
    return if latitude.blank?
    self.location ||= []
    self.location[0] = latitude
  end

  def lng
    self.location && self.location[1]
  end

  def lng=(longitude)
    return if longitude.blank?
    self.location ||= []
    self.location[1] = longitude
  end

  class << self
    def without_versioning(&block)
      without_callback(:save, :before, :revise) { yield }
    end
  end
end
