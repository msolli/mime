# encoding: UTF-8
module SearchHelper
  
  def highlights_for(hit, field)
    res = hit.highlights(field).map{|h| h.format{|word| %Q(<span class="highlight">#{word}</span>)} + '…' }.join.html_safe
    res.blank? ? nil : res
  end
  
  def paginate(hits)
    # craeator of will_paginate, for some reason, has decided that they should not render anything
    # if there are less than 2 hits in the result set
    if hits.total_entries > 1
      will_paginate hits, :renderer => TemplatePaginationRenderer, :template => 'search.template.several_hits'
    else
      t('search.template.one_or_less_hits', :count => hits.total_entries)
    end
  end
  
end
