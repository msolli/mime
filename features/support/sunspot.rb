# Sunspot normally commits changes to solr via an after_filter on controller.
# We don't use an controller here, so we need to make sure solr gets updated anyway
Article.class_eval do
  set_callback :save, :after, :index!
end

orig_session = Sunspot.session

Before("~@search") do
  Sunspot.session = Sunspot::Rails::StubSessionProxy.new($original_sunspot_session)
end

Before("@search") do
  unless $sunspot
    $sunspot = Sunspot::Rails::Server.new
    pid = fork do
      STDERR.reopen('/dev/null')
      STDOUT.reopen('/dev/null')
      $sunspot.run
    end
    # shut down the Solr server
    at_exit { Process.kill('TERM', pid) }
    # wait for solr to start
    sleep 5
  end
  Sunspot.session = orig_session

  Article.remove_all_from_index!
end
