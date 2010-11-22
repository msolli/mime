Factory.define :user do |u|
  u.name 'Odin Valaskjalv'
  u.email 'odin@valhall.no'
  u.password Devise.friendly_token
end
