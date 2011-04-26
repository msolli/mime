# encoding: utf-8

Gitt /^(?:|at )følgende artikler(?:| finnes):$/ do |article_data|
  article_data.hashes.each do |hash|
    Article.create!(hash)
  end
end

Gitt /^(?:|at )artikkelen "([^"]*)" finnes$/ do |headword|
  Article.create!(:headword => headword)
end

Gitt /^(?:|at )jeg oppretter artikkelen "([^"]*)"$/ do |headword|
  # Will create 1 version
  Article.without_versioning do
    a = Article.new(:headword => headword)
    a.authors << User.where(:email => 'nn@example.com').first
    a.save!
  end
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
  Article.without_versioning do # will create 1 version
    authors.hashes.each do |hash|
      hash['password'] = Devise.friendly_token
      a.authors << User.create!(hash)
    end
    a.save!
  end
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

Så /^(?:|så )skal "([^"]*)" være sist oppdatert "([^"]*)"$/ do |headword, timestamp|
  a = Article.where(:headword => headword).first
  updated_at = (timestamp == 'i dag' ? Date.today : Time.parse(timestamp)).strftime('%Y-%m-%d')
  a.updated_at.strftime('%Y-%m-%d').should == updated_at
end

Så /^så skal jeg være bidragsyter for (\d+) artikler$/ do |n|
  User.where(:email => 'nn@example.com').first.articles.count.should == n.to_i
end

Så /^artikkelen "([^"]*)" skal ha (\d+) versjoner$/ do |headword, versions|
  a = Article.where(:headword => headword).first
  a.version.should == versions.to_i
end

Så /^versjon (\d+) av "([^"]*)" skal være sist oppdatert "([^"]*)"$/ do |version, headword, timestamp|
  a = Article.where(:headword => headword).first
  a.versions.select { |v| v.version == version.to_i }.first.updated_at.strftime('%Y-%m-%d').should == timestamp
end

Så /^skal jeg se "([^"]*)" i oppslagsord\-feltet$/ do |headword|
  find_field('article_headword').value.should == headword
end

Så /^skal det være (\d+) eksterne lenker\-felt$/ do |count|
  all('form .external-link').select { |e| e.visible? }.count.should == count.to_i
end

Når /^jeg klikker "([^"]*)" under den siste eksterne lenken$/ do |link|
  all('form .external-link').last.click_link(link)
end
