### The dragonfly app ###
app = Dragonfly[:attachments]
app.configure_with(:rmagick)
app.configure_with(:rails) do |c|
  c.datastore = Dragonfly::DataStorage::MongoDataStore.new(
    :database => Mongoid.database.name
  ) unless Rails.env.production?
end

app.configure_with(:heroku, ENV['S3_BUCKET']) if Rails.env.production?

### Extend active record ###
app.define_macro_on_include(Mongoid::Document, :attachment_accessor)

### Insert the middleware ###
# Where the middleware is depends on the version of Rails
middleware = Rails.application.middleware
