# encoding: UTF-8
module SearchHelper
  
  def highlights_for(hit, field)
    res = hit.highlights(field).map{|h| h.format{|word| %Q(<span class="highlight">#{word}</span>)} + '…' }.join.html_safe
    res.blank? ? nil : res
  end
  
end
