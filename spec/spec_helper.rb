ENV["RAILS_ENV"] ||= 'test'

# Spork.trap_class_method(Rails::Mongoid, :load_models)

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

require 'factory_girl'
Dir[Rails.root.join('spec/factories/**/*.rb')].each {|f| require f}
 
Mime::Application.reload_routes!


I18n.locale = :'no-NB'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

Sunspot.session = Sunspot::Rails::StubSessionProxy.new(Sunspot.session)

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true

  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # config.fixture_path = "#{::Rails.root}/spec/fixtures"
  # config.use_transactional_fixtures = false

  # Mongoid (http://mongoid.org/docs/integration/)
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.orm = "mongoid"
  end

  config.before(:each) do
    DatabaseCleaner.clean
  end

  config.include Mongoid::Matchers
  config.include Devise::TestHelpers, :type => :controller
  config.extend ControllerMacros, :type => :controller
end

def logger
  ::Rails.logger
end
