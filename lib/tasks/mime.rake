# encoding: utf-8

namespace :mime do
  require 'import'
  desc "Import av XML-data fra Kunnskapsforlaget"
  task :import => [:environment, "mime:xml:read"] do
    author_conf = YAML.load(IO.read("#{Rails.root}/tmp/import/forfattere.yml"))
    Import::ArticleXml.all_authors = author_conf['authors']
    Import::ArticleXml.editor = author_conf['editor']
    Import::Main.run(@doc)
    Import::Crossref.run

    # Leksikonet ble utgitt 16. oktober 2008
    CREATED_AT = Time.local(2008, 10, 16, 12, 00, 00)
    Article.collection.update({}, {"$set" => {:created_at => CREATED_AT, :updated_at => CREATED_AT}}, :multi => true)
    User.collection.update({}, {"$set" => {:created_at => CREATED_AT, :updated_at => CREATED_AT}}, :multi => true)
  end

  desc "Oppdater kryssreferanser etter import"
  task :crossref => :environment do
    Import::Crossref.run
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

    task :field_clarification => :read do
      @doc.xpath('//field[@id="clarification"]').each do |node|
        puts node.content
      end
    end

    task :field_headword => :read do
      @doc.xpath('//field[@id="headword"]').each do |node|
        puts node.content
        # puts unpack_utf8(node.to_xml)
      end
    end

    task :field_author => :read do
      @doc.xpath('//field[@id="author"]').each do |node|
        puts node.content
      end
    end

    task :field_subject => :read do
      @doc.xpath('//field[@id="subject"]').each do |node|
        puts node.content
      end
    end

    task :field_subject_summary => :read do
      subjects = {}
      @doc.xpath('//field[@id="subject"]').each do |node|
        subjects[node.content] = (subjects[node.content].nil? ? 1 : subjects[node.content] + 1)
      end
      subjects.sort {|a,b| a[1]<=>b[1]}.each do |a|
        puts "#{a[0]}: #{a[1]}"
      end
    end

    task :no_author => :read do
      @doc.xpath('//field[@id="author"]').each do |node|
        if node.content == 'Red'
          puts node.xpath('../field[@id="headword"]').first.content
        end
      end
    end

    task :multiple_authors => :read do
      @doc.xpath('//article').each do |node|
        num_authors = node.xpath('.//field[@id="author"]').size
        if num_authors > 1
          puts node.xpath('.//field[@id="headword"]').first.content + " [#{num_authors}]"
          node.xpath('.//field[@id="author"]').each do |author_node|
            puts "  " + author_node.content
          end
        end
      end
    end

    task :vei_asker_red => :read do
      @doc.xpath('//article[@id_def="vei i Asker"]').each do |node|
        node.xpath('.//field[@id="author"]').each do |author_node|
          if author_node.content == 'Red'
            puts node.xpath('.//field[@id="headword"]').first.content
          end
        end
      end
    end

    task :read do
      @doc = Nokogiri::XML(File.open("#{Rails.root}/tmp/import/abl.xml"), nil, "utf-8") do |config|
        config.strict.noent
      end
    end
  end
end

def unpack_utf8(xml)
  xml.unpack("U*").collect {|s| (s > 127 ? "&##{s};" : s.chr) }.join("")
end
