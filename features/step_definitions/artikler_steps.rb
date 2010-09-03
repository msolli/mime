Gitt /^følgende artikler:$/ do |article_data|
  article_data.hashes.each do |hash|
    Article.create!(hash)
  end
end
