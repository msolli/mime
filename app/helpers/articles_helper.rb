module ArticlesHelper

  def setup_article(article)
    # This order is very delicate, due to https://github.com/mongoid/mongoid/pull/406
    # and the way we work around it (Article#remove_empty_external_links)
    
    # No idea why we need to call without versioning here, but it works,
    # else we end up with a new version every time someone goes to #edit
    [:medias, :external_links].each do |method|
      article.send(method).build unless article.send(method).last && article.send(method).last.new_record?
    end
    
    article.build_location if article.location.nil?

    article
  end
end
