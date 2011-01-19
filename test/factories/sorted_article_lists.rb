Factory.define :sorted_article_list do |f|
  f.name "Sorted article list"
  f.sort_direction :desc
  f.sort_field :updated_at
end
