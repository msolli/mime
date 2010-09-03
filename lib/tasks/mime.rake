namespace :mime do
  desc "Import av XML-data fra Kunnskapsforlaget"
  task :import do
    doc = Nokogiri::XML(File.open("#{Rails.root}/tmp/import/abl.xml")) do |config|
      config.strict
    end
    doc.xpath("//field[@id='epoch_end']").each do |node|
      puts node.content
    end
  end
end