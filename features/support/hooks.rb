ACCESS_TOKEN = {
  :access_token => "stubbed-access-token"
}

FACEBOOK_INFO = {
  :id => '12345',
  :link => 'http://facebook.com/navn.navnesen',
  :website => 'http://navnesen.no',
  :first_name => 'Navn',
  :last_name => 'Navnesen',
  :name  => "Navn Navnesen",
  :email => 'nn@example.com'
}


Before("@devise") do
  Devise::OmniAuth.short_circuit_authorizers!
  Devise::OmniAuth.stub!(:facebook) do |b|
    b.post('/oauth/access_token') { [200, {}, ACCESS_TOKEN.to_json] }
    b.get("/me?access_token=#{ACCESS_TOKEN[:access_token]}") { [200, {}, FACEBOOK_INFO.to_json] }
  end
end

After("@devise") do
  Devise::OmniAuth.unshort_circuit_authorizers!
  Devise::OmniAuth.reset_stubs!
end

Before("@logged_in") do
  Gitt %{at jeg er logget inn}
end
