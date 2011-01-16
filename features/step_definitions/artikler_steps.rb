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

Gitt /^at artikkelen "([^"]*)" har lokasjon "([^"]*)"$/ do |headword, location|
  lat, lng = location.split(/, */)
  a = Article.where(:headword => headword).first
  a.location = Location.new(:latitude => lat, :longitude => lng)
  a.save!
end

Gitt /^at artikkelen "([^"]*)" får teksten$/ do |headword, text|
  Article.where(:headword => headword).first.update_attributes(:text => text)
end

Gitt /^at artikkelen "([^"]*)" har bilde$/ do |headword|
  Gitt %{at jeg legger til bildet "/spec/data/png.png" til artikkelen "#{headword}"}
end

Gitt /^at jeg legger til bildet "([^"]*)" til artikkelen "([^"]*)"$/ do |img_path, headword|
  a = Article.where(:headword => headword).first
  a.medias << (Media.new :file => open(File.exists?(img_path) ? img_path : File.join(Rails.root, img_path)))
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
