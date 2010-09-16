namespace :mime do
  require 'import'
  desc "Import av XML-data fra Kunnskapsforlaget"
  task :import => "mime:xml:preprocess" do
    import = Import::Article.parse("#{Rails.root}/tmp/import/abl-p.xml")
    puts import.articles.size
  end

  namespace :xml do
    task :preprocess => :read do
      @doc.xpath('//body').each do |body|
        body.inner_html = Nokogiri::XML::CDATA.new(@doc, body.inner_html)
      end
      File.open("#{Rails.root}/tmp/import/abl-p.xml", 'w') { |f| f.write(@doc.to_xml(:save_with => Nokogiri::XML::Node::SaveOptions::NO_DECLARATION)) }
    end

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

    task :field_clarification => :read do
      @doc.xpath('//field[@id="clarification"]').each do |node|
        puts node.content
      end
    end

    task :read do
      @doc = Nokogiri::XML(File.open("#{Rails.root}/tmp/import/abl.xml")) do |config|
        config.strict.noent
      end
    end
  end
end
