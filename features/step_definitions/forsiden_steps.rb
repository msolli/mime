# encoding: utf-8

Gitt /^at det fins en forside$/ do
  p = Factory(:front_page)

  # 2.times do
  #   section = Factory.build(:section)
  #   p.sections << section
  #   4.times do |i|
  #     section.articles << SectionArticle.new_from_article(Factory(:article), Date.today - i)
  #   end
  # end
  # 
  # %w(foo bar baz).each do |tag|
  #   5.times { Factory(:article, :tags_array => [tag]) }
  #   list = Factory.build(:tags_article_list, :tags => [tag])
  #   p.article_lists << list
  # end
  # 
  # p.article_lists << Factory.build(:sorted_article_list)
end

Gitt /^at det fins en tom forside$/ do
  p = Factory(:page, :name => 'Forside')
end

Når /^jeg legger til følgende artikler:$/ do |table|
  list_article_css = 'form .article-fields'
  table.hashes.each do |hash|
    hash['Dato'] = parse_date(hash['Dato'])
    last = all(list_article_css).last
    if last.find_field('Oppslagsord').value.present?
      click_link("Legg til artikkel")
      last = all(list_article_css).last
    end
    hash.each do |field, value|
      last.fill_in(field, :with => value)
    end
  end
end

def parse_date(date_string)
  Date.today + date_string.split.last.to_i
end
