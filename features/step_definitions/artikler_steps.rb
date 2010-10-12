# encoding: utf-8
Gitt /^følgende artikler:$/ do |article_data|
  article_data.hashes.each do |hash|
    Article.create!(hash)
  end
end

Gitt /^(?:|at )artikkelen "([^"]*)" finnes$/ do |headword|
  Article.create!(:headword => headword)
end
