module ArticlesHelper

  def setup_article(article)
    # This order is very delicate, due to https://github.com/mongoid/mongoid/pull/406
    # and the way we work around it (Article#remove_empty_external_links)
    
    # No idea why we need to call without versioning here, but it works,
    # else we end up with a new version every time someone goes to #edit
    Article.without_versioning do
      # article.medias.build
      article.external_links.build
    end
    article.build_location if article.location.nil?

    article
  end
end
