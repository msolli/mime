Factory.define :page do |p|
  p.sequence(:name) {|n| "Page #{n}" }
end
