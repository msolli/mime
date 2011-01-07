# Sunspot normally commits changes to solr via an after_filter on controller.
# We don't use an controller here, so we need to make sure solr gets updated anyway
Article.class_eval do
  set_callback :save, :after, :index!
end

orig_session = Sunspot.session

# Stub solr session for features not using solr searches
Before('~@search') do
  Sunspot.session = Sunspot::Rails::StubSessionProxy.new(Sunspot.session)
end

# start the Solr server when necessary and give it a few seconds to initialize
Before('@search') do
  pid = fork { 
    orig_stdout = STDOUT
    orig_stderr = STDERR
    orig_stdin  = STDIN
    
    STDIN.reopen(File.new('/dev/null'))
    STDOUT.reopen(File.new('/dev/null', 'a'))
    STDERR.reopen(STDOUT)
    
    Sunspot::Rails::Server.new.run
    
    STDOUT = orig_stdout
  }
  sleep 5 # allow some time for the instance to spin up
  Sunspot.session = orig_session
end

# clean out the Solr index after each scenario
After('@search') do
  Article.remove_all_from_index!  
  `ps ax|egrep "solr.*test"|grep -v grep|awk '{print $1}'|xargs kill`
end
