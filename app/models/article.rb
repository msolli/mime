# encoding: utf-8

class Article
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Versioning
  include Sunspot::Mongoid
  include Mongoid::Paranoia
  include ActionView::Helpers::SanitizeHelper
  include Mongoid::Observing
  
  references_and_referenced_in_many :users
  alias :authors :users
  alias :authors= :users=
  
  references_and_referenced_in_many :medias
  embeds_one :location
  embeds_many :external_links

  field :headword
  field :text, :default => ''
  field :definition
  field :years, :type => Array
  field :end_year, :type => Date
  field :disambiguation
  field :ip
  field :tags_array, :type => Array, :default => []

  # Websolr index
  searchable do
    # text fields are used for full-text search, rest for faceting
    text    :headword, :boost => 2.0
    text    :headword_presentation, :boost => 2.0
    text    :text, :stored => true do
      strip_tags(text)
    end
    text    :tags, :using => :tags_array, :boost => 0.5
    
    string  :tags, :using => :tags_array, :multiple => true
    
    time    :years, :multiple => true
    time    :end_year
  end
  
  index :headword, :unique => true
  index "versions.headword"
  index [[ 'location.lat_lng', Mongo::GEO2D ]]

  attr_accessor :media_ids_from_async_upload

  validates_presence_of :headword
  validates_uniqueness_of :headword
  validates_associated :location, :external_links
  
  accepts_nested_attributes_for :location, :external_links, :medias, :allow_destroy => true, :reject_if => :all_blank
  
  # We do this because mongodb doesn't allow index fields to be null
  # They can however be absent from the document…
  before_validation :remove_empty_location
  
  before_save :update_headword_sorting, :remove_duplicate_tags

  NO_SORT = %w(a b c d e f g h i j k l m n o p q r s t u v w x y z æ ø å)

  def to_param
    self.headword.gsub(/ /, '_').gsub(/\//, '%2F')
  end
  
  def slug_is?(slug)
    to_param == slug.gsub(/\//, '%2F')
  end

  def headword_presentation
    if tags_array.include?('person') && headword.include?(',')
      # 'last, first' --> 'first last'
      headword.scan(/^([^,]*),\s*(.*)/).first.reverse.join(' ')
    else
      headword
    end
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
    self[:tags_array] || self[:tags_array] = []
  end

  alias_method :delete_paranoia, :delete

  def delete
    self.headword = self.headword + " (#{I18n.t('words.deleted')}: #{Time.now.getutc})"
    delete_paranoia
  end

  def add_async_uploads(media_ids_from_async_upload)
    _media_ids = media_ids_from_async_upload.to_s.strip.split.map{|__id| BSON::ObjectId.from_string(__id)}
    unless _media_ids.blank?
      versionless do
        Media.any_in(:_id => _media_ids).each do |media|
          self.medias << media
        end
      end
    end
  end

  class << self
    def without_versioning(&block)
      without_callback(:save, :before, :revise) { yield }
    end
  end
  
  private
  
  def remove_empty_location
    self.location = nil if !self.location.blank? && self.location.unwanted?
  end
  
  def update_headword_sorting
    array = self[:headword].mb_chars.downcase.gsub(/aa/, 'å').scan(/./)
    self[:headword_sorting] = array.map {|c| NO_SORT.index(c)}.compact.map {|c| (c + 'a'.ord).chr}.join
  end

  def remove_duplicate_tags
    self[:tags_array].uniq! if self[:tags_array]
  end
end
