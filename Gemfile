source 'https://rubygems.org'

ruby '2.0.0'

# Temporary gem locks
gem 'json', '1.7.7'
gem 'aws-s3', github: 'zeevex/aws-s3', ref: '406cdb5f6e0125fb9cc74246113870eba3b9765c'

gem 'rails', '3.2.13'

gem 'thin'
gem 'eventmachine', "~>1.0.0"

# Asset pipeline
group :assets do
  gem 'sass-rails', "  ~> 3.2.0"
  gem 'coffee-rails', "~> 3.2.0"
  gem 'uglifier'

  gem "therubyracer", :require => 'v8'

  gem 'asset_sync'
  gem 'turbo-sprockets-rails3'
end

gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jquery-ui-sass-rails'
gem 'plupload-rails'

# Template engine
gem 'haml'

# Database
gem 'mongoid'
gem 'bson', '~> 1.3'
gem 'bson_ext', '~> 1.3'
gem 'mongo_store', github: 'budstikka/mongo_store', ref: 'bc6988060d4ab508901c'

# Authentication and authorization
gem 'devise'
gem 'cancan'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'oa-oauth', :require => 'omniauth/oauth'

# View helper gems
gem 'formtastic', '~> 2.0'
gem 'simple_form'
gem 'ckeditor'
gem 'will_paginate', '~> 3.0.pre2'

# Attachment handling
gem 'fog'
gem 'dragonfly', '~> 0.9.0'

# Parsers
gem 'nokogiri'
gem 'sax-machine'

gem 'escape_utils' # A way to silence stupid stupid stupid Rack::Utils::escape

# Production level debugging
gem 'exceptional'

# Search indexing
gem 'sunspot_rails'
gem 'sunspot_mongoid', github: 'kabriel/sunspot_mongoid', ref: '7695fa299e7072ba41aab5197e53fbb3faffa47e'

# Async jobs
gem 'delayed_job'
gem 'delayed_job_mongoid'
gem 'heroku_delayed_job_autoscale'

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

  gem 'sunspot_solr'

  gem 'better_errors'
  gem 'binding_of_caller'
end

group :test do
  # http://github.com/aslakhellesoy/cucumber-rails
  gem 'capybara', '~> 1.0'

  gem 'database_cleaner'
  gem 'cucumber-rails', :require => false
  gem 'cucumber'
  gem 'fuubar'
  gem 'launchy'
  # gem 'ruby-debug'
  # gem 'linecache19', '0.5.13'

  gem 'ZenTest', '~> 4.4.2'
  gem 'autotest-rails'
  gem 'selenium-webdriver'
  gem 'factory_girl_rails', :require => false
end

group :test, :development do
  gem 'rspec-rails', '~> 2.6.0.rc6'
  gem 'figaro'
end
