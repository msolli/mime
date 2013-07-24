# from mobile_fu plugin
MOBILE_USER_AGENTS = 'palm|blackberry|nokia|phone|midp|mobi|symbian|chtml|ericsson|minimo|' +
  'audiovox|motorola|samsung|telit|upg1|windows ce|ucweb|astel|plucker|' +
  'x320|x240|j2me|sgh|portable|sprint|docomo|kddi|softbank|android|mmp|' +
  'pdxgw|netfront|xiino|vodafone|portalmmm|sagem|mot-|sie-|ipod|up\\.b|' +
  'webos|amoi|novarra|cdm|alcatel|pocket|ipad|iphone|mobileexplorer|mobile'

Mime::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile"

  # For nginx:
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

  # See everything in the log (default is :info)
  # config.log_level = :debug
  
  # Fix canonical urls
  config.middleware.insert_before(ActionDispatch::Static, Rack::Rewrite) do
    # r302 %r{.*}, 'http://mobil.ableksikon.no$&', :if => Proc.new {|rack_env|
    #   rack_env['HTTP_USER_AGENT'] =~ Regexp.new(MOBILE_USER_AGENTS)
    # }
    r301 %r{.*}, 'http://www.ableksikon.no$&', :if => Proc.new {|rack_env|
      rack_env['HTTP_HOST'] !~ /^(www|mobil|mime-staging|ableksikon-staging|localhost|10.0.2.2)/
    }
  end

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  config.serve_static_assets = true

  # Enable serving of images, stylesheets, and javascripts from an asset server
  config.action_controller.asset_host = "http://#{ENV['S3_ASSETS_BUCKET']}.s3-external-3.amazonaws.com"

  # Devise wants this
  # TODO - pass på at dette virker med Heroku og Sendgrid
  config.action_mailer.default_url_options = { :host => ENV['APP_HOST'] }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default :charset => "utf-8"

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify

  # asset_id
  # Compress JavaScripts and CSS
  config.assets.compress = true
  config.assets.js_compressor = Uglifier.new(:beautify => true) if defined? Uglifier

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

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
