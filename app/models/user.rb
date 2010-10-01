class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :oauthable

  field :email
  field :password
  field :facebook_token
  validates_presence_of :email
  validates_uniqueness_of :email, :case_sensitive => false
  attr_accessible :email, :password

  class << self
    def find_for_facebook_oauth(access_token, signed_in_resource = nil)
      data = ActiveSupport::JSON.decode(access_token.get('https://graph.facebook.com/me'))

      # Link the account if an e-mail already exists in the database
      # or a signed_in_resource, which is already in session was given.
      if user = signed_in_resource || User.where(:email => data["email"]).first
        user.update_attribute(:facebook_token, access_token.token)
        user
      else
        User.create!(:name => data["name"], :email => data["email"],
          :password => Devise.friendly_token) { |u| u.facebook_token = access_token.token }
      end
    end
  end
end
