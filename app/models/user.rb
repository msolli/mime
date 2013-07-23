class User
  include Mongoid::Document
  include Mongoid::Timestamps

  references_and_referenced_in_many :articles
  has_many :images

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  field :email
  field :encrypted_password
  field :password
  field :name
  field :facebook_token
  field :role, :default => "user"

  field :current_sign_in_at
  field :current_sign_in_ip
  field :last_sign_in_at
  field :last_sign_in_ip
  field :sign_in_count
  field :remember_created_at

  index :email, :unique => true

  validates_presence_of :email
  validates_uniqueness_of :email, :case_sensitive => false
  attr_accessible :email, :password, :name

  def to_param
    self.email
  end

  def as_json(options = {})
    serializable_hash(:only => [:_id, :email, :name, :role, :current_sign_in_at, :current_sign_in_ip, :last_sign_in_at, :last_sign_in_ip], :methods => :name_or_email)
  end

  def name_or_email
    self.name.blank? ? email : self.name
  end

  ROLES = %w[user editor admin]

  def role?(base_role)
    ROLES.index(base_role.to_s) <= (ROLES.index(role) || -1)
  end

  def user?; role? "user"; end
  def editor?; role? "editor"; end
  def admin?; role? "admin"; end

  class << self
    def find_for_facebook_oauth(auth_info, signed_in_resource = nil)
      Rails.logger.debug("find_for_facebook_oauth")
      Rails.logger.debug("auth_info: " + auth_info.to_json)
      Rails.logger.debug("signed_in_resource: " + signed_in_resource.to_json)

      email = auth_info['extra']['raw_info']['email']
      name = auth_info['extra']['raw_info']['name']
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
