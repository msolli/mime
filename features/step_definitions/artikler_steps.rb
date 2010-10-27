# encoding: utf-8
Gitt /^følgende artikler:$/ do |article_data|
  article_data.hashes.each do |hash|
    Article.create!(hash)
  end
end

Gitt /^(?:|at )artikkelen "([^"]*)" finnes$/ do |headword|
  Article.create!(:headword => headword)
end

Gitt /^(?:|at )original-artikkelen "([^"]*)" finnes$/ do |headword|
  a = Article.create!(:headword => headword)
  Article.collection.update({"_id" => a["_id"]}, { "$set" => { :created_at => Time.parse("2008-10-16"), :updated_at => Time.parse("2008-10-16") } })
end
