module ApplicationHelper
  
  def mobile_page(content, header = nil, footer = nil, id = nil)
    render :partial => 'mobile/page', :locals => {
      :header => header,
      :footer => footer,
      :content => content,
      :id => id
    }
  end
    
  def with_format(format, &block)
    old_formats = self.formats
    self.formats = [format]
    block.call
    self.formats = old_formats
    nil
  end
  
  def scores_section
    section = case controller_name
    when 'articles'
      'artikler'
    else
      ''
    end
    
    section = "/#{section}" unless section.blank?
    section
  end
  
  def sortable(column, title = nil, default = "asc")
    title ||= column.titleize
    direction =
      if column == sort_column
        sort_direction == "asc" ? "desc" : "asc"
      else
        default
      end
    css_class = (column == sort_column) ? "current #{sort_direction}" : nil
    link_to title, {:sort => column, :direction => direction}, :class => css_class 
  end

  def timeago(time, options = {})
    options[:class] ||= "timeago"
    content_tag(:time, l(time.to_date, :format => :long), options.merge(:datetime => time.getutc.iso8601)) if time
  end

  def author_or_you
    current_user == @user ? t('words.you') : @user.name_or_email
  end

  def possessivize(word)
    word =~ /s$/i ? word + "'" : word + "s"
  end
end
