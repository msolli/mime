namespace :mime do
  namespace :solr do
    desc "Re-index all models in Solr"
    task :reindex => :environment do
      puts "Clearing indices"
      Article.remove_all_from_index
      puts "Re-indexing articles. Each dot is 100 articles staged for re-indexing"
      Article.all.each_with_index{|a, idx| a.index; print "." if idx % 100 == 0}
      puts "\n#{Article.count} articles reindex"
      puts "Commiting to Solr"
      Sunspot.commit
    end
  end
end
