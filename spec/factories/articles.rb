Factory.define :article do |a|
  a.sequence(:headword) {|n| "Foo #{n}"}
end
