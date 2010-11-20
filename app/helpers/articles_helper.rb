module ArticlesHelper
  
  def setup_article(article)
    article.build_location if article.location.blank?
    
    article
  end
  
end
