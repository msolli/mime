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
  config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # Devise wants this
  # A dummy setup for development - no deliveries, but logged
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = false
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default :charset => "utf-8"

  config.active_support.deprecation = :log
  
  config.action_view.javascript_expansions[:aloha] = %w(/lib/aloha/debug/aloha aloha-config)
  config.action_view.javascript_expansions[:aloha_plugins] = [
    '/lib/aloha/debug/plugins/com.gentics.aloha.plugins.Format/plugin.js',
    '/lib/aloha/debug/plugins/com.gentics.aloha.plugins.List/plugin.js',
    '/lib/aloha/debug/plugins/com.gentics.aloha.plugins.Table/plugin.js'
    ]
end
