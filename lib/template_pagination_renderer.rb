class TemplatePaginationRenderer < WillPaginate::ViewHelpers::LinkRenderer
  
  def to_html
    
    unless @options[:template]
      super 
      return
    end
    
    html = I18n.translate(@options[:template],
      :previous_label => previous_page,
      :next_label     => next_page,
      :links          => windowed_page_numbers.join(@options[:separator]),
      :current_page   => @collection.current_page,
      :from           => @collection.offset + 1,
      :to             => @collection.offset + @collection.length,
      :total_entries  => @collection.total_entries,
      :total_pages    => @collection.total_pages
    )
    
    html.respond_to?(:html_safe) ? html.html_safe : html
  end
  
end