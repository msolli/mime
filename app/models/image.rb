class Image
  include Mongoid::Document
  include Mongoid::Timestamps

  image_accessor :file

  has_and_belongs_to_many :articles
  belongs_to :user

  field :description, type: String
  field :author, type: String
  field :license, type: Symbol, default: :cc_by_sa
  field :file_uid, type: String

  validates :file, presence: true
  validates :author, presence: true, on: :update
  validates :license, presence: true, inclusion: { in: [:cc_by_sa, :copyright] }

end
