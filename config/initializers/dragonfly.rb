app = Dragonfly[:images]

app.configure_with(:imagemagick)
if Rails.env.production?
  app.configure_with(:rails)
  app.configure_with(:heroku, ENV['S3_BUCKET'])
else
  app.configure_with(:rails) do |c|
    c.datastore = Dragonfly::DataStorage::MongoDataStore.new :db => Mongoid.database
  end
end

app.define_macro_on_include(Mongoid::Document, :image_accessor)

### Old stuff ###
# app = Dragonfly[:attachments]
# app.configure_with(:imagemagick)
# app.configure_with(:rails) do |c|
#   c.datastore = Dragonfly::DataStorage::MongoDataStore.new(
#     :database => Mongoid.database.name
#   ) unless Rails.env.production?
# end
# 
# app.configure_with(:heroku, ENV['S3_BUCKET']) if Rails.env.production?
# 
# ### Extend active record ###
# app.define_macro_on_include(Mongoid::Document, :attachment_accessor)
# 
# ### Insert the middleware ###
# # Where the middleware is depends on the version of Rails
# middleware = Rails.application.middleware
