class User
  include Mongoid::Document
  references_many :articles, :stored_as => :array, :inverse_of => :users

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  field :email
  field :password
  field :name
  field :facebook_token
  validates_presence_of :email
  validates_uniqueness_of :email, :case_sensitive => false
  attr_accessible :email, :password, :name

  def name_or_email
    self.name.blank? ? email : self.name
  end

  class << self
    def find_for_facebook_oauth(auth_info, signed_in_resource = nil)
      Rails.logger.debug("find_for_facebook_oauth")
      Rails.logger.debug("auth_info: " + auth_info.to_json)
      Rails.logger.debug("signed_in_resource: " + signed_in_resource.to_json)

      email = auth_info['extra']['user_hash']['email']
      name = auth_info['user_info']['name']
      access_token = auth_info['credentials']['token']

      # Link the account if an e-mail already exists in the database
      # or a signed_in_resource, which is already in session was given.
      if user = signed_in_resource || User.where(:email => email).first
        user.facebook_token = access_token
        user.name = name
        user.save!
        user
      else
        User.create!(:name => name, :email => email,
          :password => Devise.friendly_token) { |u| u.facebook_token = access_token }
      end
    end
  end
end
