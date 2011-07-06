source 'http://rubygems.org'

gem 'rails', '>= 3.0.9'
gem 'hassle', :require => false
gem 'haml'
gem 'sass'
gem 'mongoid', :git => 'http://github.com/mongoid/mongoid.git'
gem 'bson', '~> 1.3'
gem 'bson_ext', '~> 1.3'
gem 'formtastic', '~> 1.1'
gem 'simple_form'
gem 'nokogiri'
gem 'sax-machine'
gem 'devise', :git => 'http://github.com/plataformatec/devise.git'
gem 'cancan'
gem 'oa-oauth', :require => 'omniauth/oauth'
gem 'escape_utils' # A way to silence stupid stupid stupid Rack::Utils::escape
gem 'ckeditor', :git => 'http://github.com/budstikka/rails-ckeditor.git', :branch => 'rails3'
gem 'will_paginate', '~> 3.0.pre2'
gem 'jammit'
gem 'uglifier'
gem 'asset_id', :git => 'git://github.com/msolli/asset_id.git'
gem 'exceptional'

gem 'sunspot_rails'
gem 'sunspot_mongoid', :git => 'git://github.com/kabriel/sunspot_mongoid.git'

gem 'mongo_store', git: 'git://github.com/budstikka/mongo_store.git', ref: 'bc6988060d4ab508901c'

# Async jobs
gem 'delayed_job'
gem 'delayed_job_mongoid'
gem 'heroku_delayed_job_autoscale'

# attachment handling
gem 'fog'
gem 'dragonfly', '~> 0.9.0'

# Canonical urls
gem 'rack-rewrite', :require => 'rack/rewrite'

# Time out before 30s (on heroku) to get exceptional to trigger
gem 'rack-timeout'

# Diff view
gem 'htmldiff'

group :development do
  gem 'rails3-generators'
  gem 'haml-rails'
  gem 'wirble'
  gem 'hirb'
  gem 'hpricot'
  gem 'ruby_parser'
  gem 'ruby-debug19'
  gem 'thin'
end

group :test do
  # http://github.com/aslakhellesoy/cucumber-rails
  gem 'capybara', '~> 1.0'
  gem 'database_cleaner'
  gem 'cucumber-rails'
  gem 'cucumber'
  gem 'fuubar'
  gem 'launchy'
  gem 'ruby-debug19'
  gem 'spork', '~> 0.9.0.rc'
  gem 'ZenTest', '~> 4.4.2'
  gem 'autotest-rails'
  gem 'selenium-webdriver', '~>0.2.2'
  gem 'factory_girl_rails', :require => false
end

group :test, :development do
  gem 'rspec-rails', '~> 2.6.0.rc6'
end
