Factory.define :list_article do |f|
  f.sequence(:headword) {|n| "Artikkel #{n} i liste"}
  f.after_build { |u| Factory(:article, headword: u.headword) }
end
