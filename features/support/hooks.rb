# encoding: utf-8

Before("@stub_user") do
  facebook_stub('user_1')
end

Before("@stub_editor") do
  facebook_stub('editor')
end

Before("@stub_admin") do
  facebook_stub('admin')
end

Before("@log_in_user") do
  facebook_stub('user_1')
  Gitt %{at jeg er logget inn}
end

Before("@log_in_editor") do
  facebook_stub('editor')
  Gitt %{at jeg er logget inn}
  set_role('editor')
end

Before("@log_in_admin") do
  facebook_stub('admin')
  Gitt %{at jeg er logget inn}
end

def facebook_stub(profile = 'user_1')
  # Devise::Oauth.short_circuit_authorizers!

  OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
    "provider" => "facebook",
    "uid"      => "http://xxxx.com/openid?id=#{profile}",
    "extra"    => {
      "raw_info" => FACEBOOK_INFO[profile]
    },
    "credentials" => {
      "token" => "token-#{profile}"
    }
  })
end

def set_role(profile)
  user = User.first(conditions: { email: FACEBOOK_INFO[profile][:email] })
  user.role = profile.split('_').first
  user.save!
end

After("@stub_user,@stub_editor,@stub_admin,@log_in_user,@log_in_editor,@log_in_admin") do
  OmniAuth.config.mock_auth[:facebook] = {}
end

ACCESS_TOKEN = {
  :access_token => "stubbed-access-token"
}

FACEBOOK_INFO = {
  'user_1' => {
    :id => '12345',
    :link => 'http://facebook.com/navn.navnesen',
    :website => 'http://navnesen.no',
    :first_name => 'Navn',
    :last_name => 'Navnesen',
    :name  => 'Navn Navnesen',
    :email => 'nn@example.com'
  },
  'user_2' => {
    :id => '67890',
    :link => 'http://facebook.com/testesen',
    :website => 'http://testesen.no',
    :first_name => 'Test',
    :last_name => 'Testesen',
    :name  => 'Test Testesen',
    :email => 'yo@testesen.no'
  },
  'editor' => {
    :id => '11111',
    :link => 'http://facebook.com/redaksjonsmedlem',
    :website => 'http://redaksjon.no',
    :first_name => 'Ronny',
    :last_name => 'Redaksjonsmedlem',
    :name  => 'Ronny Redaksjonsmedlem',
    :email => 'ronny@ableksikon.no'
  }
}
