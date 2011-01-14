module DiffsHelper
  include HTMLDiff
  
  def title_and_header(v1, v2, article)
    t('articles.versions.comparing', :from => v1.version, :to => v2.version,
      :for => (link_to article.headword, pretty_article_path(article))).html_safe
  end
  
  def diff_formatting(change)
    
    options = {:class => 'diff '}
    
    case
    when change.unchanged?
      options[:class] << 'unchanged'
    when change.adding?
      options[:class] << 'adding'
    when change.deleting?
      options[:class] << 'deleting'
    end
    
    content_tag(:span, change.element, options)
  end
  
end
