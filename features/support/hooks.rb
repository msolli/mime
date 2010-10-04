ACCESS_TOKEN = {
  :access_token => "stubbed-access-token"
}

FACEBOOK_INFO = {
  :name  => 'Navn Navnesen',
  :email => 'nn@example.com'
}


Before("@devise") do
  Devise::Oauth.short_circuit_authorizers!
  Devise::Oauth.stub!(:facebook) do |b|
    b.post('/oauth/access_token') { [200, {}, ACCESS_TOKEN.to_json] }
    b.get("/me?access_token=#{ACCESS_TOKEN[:access_token]}") { [200, {}, FACEBOOK_INFO.to_json] }
  end
end

After("@devise") do
  Devise::Oauth.unshort_circuit_authorizers!
  Devise::Oauth.reset_stubs!
end
