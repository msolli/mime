Factory.define :article do |f|
  f.sequence(:headword) {|n| "Foo #{n}"}
end

Factory.define :person_article, class: Article do |f|
  f.sequence(:headword) { |n| "Navnesen, Navn #{n}" }
  f.tags "person"
end
