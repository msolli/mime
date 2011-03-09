Factory.define :sorted_article_list do |f|
  f.name "Sorted article list"
  f.position 0
  f.sort_direction 'desc'
  f.sort_field 'updated_at'
end
