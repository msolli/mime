app = Dragonfly[:images]

app.configure_with(:imagemagick)
case Rails.env
when "production"
  app.configure_with(:rails)
  app.configure_with(:heroku, ENV['S3_BUCKET'])
when "development"
  ## S3
  app.datastore = Dragonfly::DataStorage::S3DataStore.new
  app.datastore.configure do |c|
    c.bucket_name = ENV['S3_BUCKET']
    c.access_key_id = ENV['S3_KEY']
    c.secret_access_key = ENV['S3_SECRET']
    c.region = 'eu-west-1'
  end
when "test"
  ## Mongoid
  app.configure_with(:rails) do |c|
    c.datastore = Dragonfly::DataStorage::MongoDataStore.new :db => Mongoid.database
  end
end

app.configure do |c|
  c.url_format = '/images/:job/:basename.:format'
end
app.define_macro_on_include(Mongoid::Document, :image_accessor)
