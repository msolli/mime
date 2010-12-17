# encoding: utf-8

Gitt /^at jeg har opprettet følgende artikler:$/ do |article_data|
  article_data.hashes.each do |hash|
    a = Article.create!(hash)
    a.authors << User.where(:email => 'nn@example.com').first
    Article.collection.update({"_id" => a["_id"]}, { "$set" => { :created_at => Time.parse(hash[:updated_at]), :updated_at => Time.parse(hash[:updated_at]) } })
  end
end

Så /^skal jeg se "([^"]*)" først i artikkeloversikten$/ do |headword|
  Then %{I should see "#{headword}" within "table.articles tbody tr:first-child"}
end
