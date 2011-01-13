ACCESS_TOKEN = {
  :access_token => "stubbed-access-token"
}

FACEBOOK_INFO = {
  'Navn Navnesen' => {
    :id => '12345',
    :link => 'http://facebook.com/navn.navnesen',
    :website => 'http://navnesen.no',
    :first_name => 'Navn',
    :last_name => 'Navnesen',
    :name  => 'Navn Navnesen',
    :email => 'nn@example.com'
  },
  'Test Testesen' => {
    :id => '67890',
    :link => 'http://facebook.com/testesen',
    :website => 'http://testesen.no',
    :first_name => 'Test',
    :last_name => 'Testesen',
    :name  => 'Test Testesen',
    :email => 'yo@testesen.no'
  },
  'Ronny Redaksjonsmedlem' => {
    :id => '11111',
    :link => 'http://facebook.com/redaksjonsmedlem',
    :website => 'http://redaksjon.no',
    :first_name => 'Ronny',
    :last_name => 'Redaksjonsmedlem',
    :name  => 'Ronny Redaksjonsmedlem',
    :email => 'ronny@redaksjon.no'
  }
}

Before("@devise") do
  facebook_stub
end

Before("@devise_alt") do
  facebook_stub 'Test Testesen'
end

After("@devise") do
  Devise::OmniAuth.unshort_circuit_authorizers!
  Devise::OmniAuth.reset_stubs!
end

Before("@logged_in") do
  Gitt %{at jeg er logget inn}
end

def facebook_stub(profile = 'Navn Navnesen')
  Devise::OmniAuth.short_circuit_authorizers!
  Devise::OmniAuth.stub!(:facebook) do |b|
    b.post('/oauth/access_token') { [200, {}, ACCESS_TOKEN.to_json] }
    b.get("/me?access_token=#{ACCESS_TOKEN[:access_token]}") { [200, {}, FACEBOOK_INFO[profile].to_json] }
  end
end
