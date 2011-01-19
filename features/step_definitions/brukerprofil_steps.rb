# encoding: utf-8

Gitt /^at jeg har opprettet følgende artikler:$/ do |article_data|
  Article.without_versioning do
    Article.skip_callback :save, :before, :set_updated_at
    article_data.hashes.each do |hash|
      a = Article.create!(hash)
      a.authors << User.where(:email => 'nn@example.com').first
      t = Time.parse(hash[:updated_at])
      a.update_attributes(:created_at => t, :updated_at => t)
    end
    Article.set_callback :save, :before, :set_updated_at
  end
end

Så /^skal jeg se "([^"]*)" først i artikkeloversikten$/ do |headword|
  Then %{I should see "#{headword}" within "table.articles tbody tr:first-child"}
end
