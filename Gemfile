source 'http://rubygems.org'

gem 'rails', '~> 3.0'
gem 'pg'
gem 'hassle', :require => false
gem 'haml'
gem 'mongoid', ">= 2.0.0.beta.18"
gem 'bson', '~> 1.0'
gem 'bson_ext'
gem 'mongo', '~> 1.0'
gem 'formtastic', '~> 1.1'
gem 'nokogiri'
gem 'sax-machine'
gem 'devise', :git => "http://github.com/plataformatec/devise.git"
gem 'oauth2'

group :development do
  gem 'rails3-generators'
  gem 'haml-rails'
  gem 'ruby-debug' + (RUBY_VERSION =~ /^1\.9\./ ? '19' : '')
  gem 'wirble'
  gem 'hirb'
  gem 'hpricot'
  gem 'ruby_parser'
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

  gem 'syntax'
  gem 'rcov'
end
