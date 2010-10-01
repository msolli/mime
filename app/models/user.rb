class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :database_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :oauthable
  devise :token_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  field :email
  field :password
  validates_presence_of :email
  validates_uniqueness_of :email, :case_sensitive => false
  attr_accessible :email, :password
end
