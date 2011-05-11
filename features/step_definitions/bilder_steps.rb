# encoding: utf-8

Når /^jeg laster opp følgende bilder?:$/ do |images_table|
  images_table.hashes.each do |image|
    attach_file('.fileupload', image['file'])
    
  end
end

Så /^skal jeg se (\d+) bilde i bildelisten$/ do |number|
  pending # express the regexp above with the code you wish you had
end
