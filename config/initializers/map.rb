# If config/map.yml is present, use it to set the environment variables.
# This would be the thing to do in development. Do not check it into git.
#
# On Heroku, make sure the environment variables are set with 'heroku config'.
# heroku config:add MAP_DEFAULT_LAT=...
# heroku config:add MAP_DEFAULT_LNG=...
# heroku config:add MAP_DEFAULT_ZOOM=...

config_file = Rails.root.join("config", "map.yml")
if config_file.file?
  settings = YAML.load(ERB.new(config_file.read).result)[Rails.env]
  settings.each_pair do |name, value|
    ENV["MAP_DEFAULT_#{name.upcase}"] = value.to_s
  end
end
