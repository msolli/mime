### The dragonfly app ###
app = Dragonfly[:attachments]
app.configure_with(:rmagick)
app.configure_with(:rails) do |c|
  c.datastore = Dragonfly::DataStorage::MongoDataStore.new(
    :database => Mongoid.database.name
  ) if Rails.env.development?
end

# TODO: insert correct bucket name
app.configure_with(:heroku, 'my_bucket_name') if Rails.env.production?

### Extend active record ###
app.define_macro_on_include(Mongoid::Document, :attachment_accessor)

### Insert the middleware ###
# Where the middleware is depends on the version of Rails
middleware = Rails.application.middleware

middleware.insert_before 'Rack::Lock', 'Dragonfly::Middleware', :attachments, '/media'
middleware.insert_after 'Rack::Lock', 'Dragonfly::Middleware', :images, app.url_path_prefix
middleware.insert_before 'Dragonfly::Middleware', 'Rack::Cache', {
  :verbose     => true,
  :metastore   => URI.encode("file:#{Rails.root}/tmp/dragonfly/cache/meta"), # URI encoded because Windows
  :entitystore => URI.encode("file:#{Rails.root}/tmp/dragonfly/cache/body")  # has problems with spaces
}
