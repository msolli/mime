namespace :mime do
  desc "Import av XML-data fra Kunnskapsforlaget"
  task :import => "mime:xml:read" do

  end

  namespace :xml do
    task :a => :read do
      @doc.xpath('//a').each do |node|
        puts node
      end
    end

    task :a_crossref => :read do
      @doc.xpath('//a[@class="crossref"]').each do |node|
        puts node
      end
    end

    task :a_subdoc => :read do
      @doc.xpath('//a[@class="subdoc"]').each do |node|
        puts node
      end
    end

    task :a_href_sl => :read do
      @doc.xpath('//a[@href="sl"]').each do |node|
        puts node
      end
    end

    task :field_epoch_start => :read do
      @doc.xpath('//field[@id="epoch_start"]').each do |node|
        puts node.content
      end
    end

    task :read do
      @doc = Nokogiri::XML(File.open("#{Rails.root}/tmp/import/abl.xml")) do |config|
        config.strict
      end
    end
  end
end
