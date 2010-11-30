module ArticlesHelper
  
  def setup_article(article)
    article.build_location if article.location.nil?
    article.external_links.build
    
    article
  end
end
