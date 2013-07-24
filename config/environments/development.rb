Mime::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  # config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # Devise wants this
  # A dummy setup for development - no deliveries, but logged
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = false
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default :charset => "utf-8"

  config.active_support.deprecation = :log

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  # asset_id - production only, uncomment to test
  # config.action_controller.asset_host = Proc.new do |source|
  #   unless source.starts_with?('/javascripts')
  #     'http://assets0.ableksikon.no'
  #   end
  # end
  # config.action_controller.asset_path = Proc.new do |source|
  #   unless source.starts_with?('/javascripts')
  #     AssetID::S3.fingerprint(source)
  #   else
  #     source
  #   end
  # end
end
