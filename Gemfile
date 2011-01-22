source 'http://rubygems.org'

gem 'rails', '~> 3.0'
gem 'hassle', :require => false
gem 'haml'
gem 'mongoid', '2.0.0.rc.6'
gem 'bson', '~> 1.0'
gem 'bson_ext'
gem 'mongo', '~> 1.0'
gem 'formtastic', '~> 1.1'
gem 'nokogiri'
gem 'sax-machine'
gem 'devise', :git => 'http://github.com/plataformatec/devise.git'
gem 'cancan'
gem 'oa-oauth', :require => 'omniauth/oauth'
gem 'escape_utils' # A way to silence stupid stupid stupid Rack::Utils::escape
gem 'ckeditor', :git => 'http://github.com/budstikka/rails-ckeditor.git', :branch => 'rails3'
gem 'will_paginate', '~> 3.0.pre2'
gem 'jammit'
gem 'asset_id', :git => 'git://github.com/msolli/asset_id.git'

gem 'sunspot_rails'
gem 'sunspot_mongoid', :git => 'git://github.com/kabriel/sunspot_mongoid.git'

gem 'mongo_store'

# Async jobs
gem 'delayed_job'
gem 'delayed_job_mongoid'
gem 'heroku_delayed_job_autoscale'

# attachment handling
gem 'aws-s3', :require => 'aws/s3'
gem 'dragonfly'

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
  gem 'newrelic_rpm'
  gem 'rack-perftools_profiler', :require => 'rack/perftools_profiler'
end

group :test do
  # http://github.com/aslakhellesoy/cucumber-rails
  gem 'xpath'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'cucumber-rails'
  gem 'cucumber'
  gem 'rspec-rails'
  gem 'fuubar'
  gem 'launchy'
  gem 'ruby-debug19'

  gem 'shoulda'
  gem 'factory_girl_rails'
end
