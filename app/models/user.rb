class User
  include Mongoid::Document
  references_many :articles

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :oauthable

  field :email
  field :password
  field :name
  field :facebook_token
  validates_presence_of :email
  validates_uniqueness_of :email, :case_sensitive => false
  attr_accessible :email, :password

  class << self
    def find_for_facebook_oauth(access_token, signed_in_resource = nil)
      Rails.logger.debug("find_for_facebook_oauth")
      Rails.logger.debug("access_token: " + access_token.to_json)
      Rails.logger.debug("signed_in_resource: " + signed_in_resource.to_json)
      data = ActiveSupport::JSON.decode(access_token.get('https://graph.facebook.com/me'))

      # Link the account if an e-mail already exists in the database
      # or a signed_in_resource, which is already in session was given.
      if user = signed_in_resource || User.where(:email => data["email"]).first
        user.update_attributes!(:facebook_token => access_token.token)
        user
      else
        User.create!(:name => data["name"], :email => data["email"],
          :password => Devise.friendly_token) { |u| u.facebook_token = access_token.token }
      end
    end
  end
end
