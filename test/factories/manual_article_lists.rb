Factory.define :manual_article_list do |f|
  f.name "Manual article list"
end

Factory.define :todays_articles, :parent => :manual_article_list do |f|
  f.after_build do |list|
    4.times do |i|
      Factory.build(:list_article, :date => Date.today - i, :listable => list)
    end
  end
end
