source 'http://rubygems.org'

gem 'rails', '~> 3.0'
gem 'hassle', :require => false
gem 'haml'
gem 'mongoid', ">= 2.0.0.beta.18"
gem 'bson', '~> 1.0'
gem 'bson_ext'
gem 'mongo', '~> 1.0'
gem 'formtastic', '~> 1.1'
gem 'nokogiri'
gem 'sax-machine'
gem 'devise', :git => "http://github.com/plataformatec/devise.git", :branch => 'omniauth'
gem "oa-oauth", :require => "omniauth/oauth"
gem "escape_utils" # A way to silence stupid stupid stupid Rack::Utils::escape

group :development do
  gem 'rails3-generators'
  gem 'haml-rails'
  gem 'wirble'
  gem 'hirb'
  gem 'hpricot'
  gem 'ruby_parser'
  gem 'heroku'
end

group :test do
  # http://github.com/aslakhellesoy/cucumber-rails
  gem 'capybara'
  gem 'database_cleaner'
  gem 'cucumber-rails'
  gem 'cucumber'
  gem 'rspec-rails', '~> 2.0.0'
  gem 'launchy'

  gem 'mongoid-rspec'
  gem 'shoulda'
  gem 'factory_girl'
end
