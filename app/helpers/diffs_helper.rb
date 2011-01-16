module DiffsHelper
  include HTMLDiff
  
  def title_and_header(v1, v2, article)
    t('articles.versions.comparing', :from => v1.version, :to => v2.version,
      :for => (link_to article.headword, pretty_article_path(article))).html_safe
  end
  
end
