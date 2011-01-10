HerokuDelayedJobAutoscale::Autoscale.autoscale_manager = HerokuDelayedJobAutoscale::Manager::Heroku if Rails.env.production?
HerokuDelayedJobAutoscale::Autoscale.autoscale_manager = HerokuDelayedJobAutoscale::Manager::Stub if Rails.env.test? || Rails.env.cucumber?
