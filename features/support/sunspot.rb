# start the Solr server and give it a few seconds to initialize
puts "Starting solr"
Sunspot::Rails::Server.new.start
sleep 5


# Sunspot normally commits changes to solr via an after_filter on controller.
# We don't use an controller here, so we need to make sure solr gets updated anyway
Article.class_eval do
  set_callback :save, :after, :index!
end

# clean out the Solr index after each scenario
After do
  Article.remove_all_from_index!
end

# shut down the Solr server
at_exit do
  Sunspot::Rails::Server.new.stop
end
