module ApplicationHelper

  def maps_app_url(location)
    "http://maps.google.no/maps?q=#{location}"
  end

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

  def new_child_fields_template(form_builder, association, options = {})
    options[:object] ||= form_builder.object.class.reflect_on_association(association).klass.new
    options[:partial] ||= association.to_s.singularize + "_fields"
    options[:form_builder_local] ||= :f

    content_for :jstemplates do
      content_tag(:div, :id => "#{association}_fields_template") do
        form_builder.fields_for(association, options[:object], :child_index => "new_#{association}") do |f|
          render(options[:partial], options[:form_builder_local] => f)
        end
      end
    end
  end

  def add_child_link(name, association)
    link_to(name, "#", :class => "add_child", :"data-association" => association)
  end

  def remove_child_link(name, f)
    f.hidden_field(:_destroy) + link_to(name, "#", :class => "remove_child")
  end

  def add_list_link(association, parent)
    link_to(t("pages.#{association}.new"), send("new_page_#{association}_path", parent.id))
  end

  def alpha_omega(index, size)
    if index == 0
      'alpha'
    elsif index == size - 1
      'omega'
    end
  end
end
