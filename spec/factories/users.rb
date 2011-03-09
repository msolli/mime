Factory.define :user do |u|
  u.name 'Navn Navnesen'
  u.email 'nn@example.com'
  u.password Devise.friendly_token
end

Factory.define :editor, :class => User do |u|
  u.name 'Ronny Redaksjonsmedlem'
  u.email 'ronny@ableksikon.no'
  u.role 'editor'
  u.password Devise.friendly_token
end
