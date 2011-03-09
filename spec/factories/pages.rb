Factory.define :page do |f|
  f.sequence(:name) {|n| "Page #{n}" }
end

Factory.define :front_page, :class => 'Page' do |f|
  f.name "Forside"
  f.after_build do |p|
    2.times { Factory(:todays_articles, :page => p) }
  end
end
