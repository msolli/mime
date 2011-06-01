Factory.define :image do |f|
  f.file File.open("#{Rails.root}/spec/data/png.png")
  f.author "F. Otograf"
end
