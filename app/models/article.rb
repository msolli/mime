class Article
  include Mongoid::Document
  include Mongoid::Timestamps

  field :headword
  field :text
  field :definition
  field :years, :type => Array
  field :end_year, :type => Date
  field :ambiguous, :type => Boolean
  field :location, :type => Array

  index :headword, :unique => true
  index [[ :location, Mongo::GEO2D ]]

  validates_presence_of :headword
  validates_uniqueness_of :headword
  validates :location, :location => true

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
end
