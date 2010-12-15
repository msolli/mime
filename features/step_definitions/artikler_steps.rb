# encoding: utf-8

Gitt /^følgende artikler:$/ do |article_data|
  article_data.hashes.each do |hash|
    Article.create!(hash)
  end
end

Gitt /^(?:|at )artikkelen "([^"]*)" finnes$/ do |headword|
  Article.create!(:headword => headword)
end

Gitt /^(?:|at )jeg oppretter artikkelen "([^"]*)"$/ do |headword|
  a = Article.new(:headword => headword)
  a.authors << User.where(:email => 'nn@example.com').first
  a.save!
end

Gitt /^(?:|at )original-artikkelen "([^"]*)" finnes$/ do |headword|
  a = Article.create!(:headword => headword)
  Article.collection.update({"_id" => a["_id"]}, { "$set" => { :created_at => Time.parse("2008-10-16"), :updated_at => Time.parse("2008-10-16") } })
end

Gitt /^at artikkelen "([^"]*)" har følgende bidragsytere:$/ do |headword, authors|
  a = Article.new(:headword => headword)
  authors.hashes.each do |hash|
    hash['password'] = Devise.friendly_token
    a.authors << User.create!(hash)
  end
  a.save!
end

Så /^skal jeg ikke se noe kart$/ do
  Then %{"aside.meta img" should not exist}
end

Så /^skal kartet vises i artikkelen$/ do
  Then %{"aside.meta img" should be visible}
end

Så /^skal kartet vises$/ do
  Then %{"div.map" should be visible}
end

Så /^kartet skal være usynlig$/ do
  Then %{"#article_location_attributes_map" should be invisible}
end

Så /^skal jeg ikke se eksterne lenker$/ do
  Then %{".external-links" should not exist}
end
