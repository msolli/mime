class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :oauthable
  devise :token_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

end
