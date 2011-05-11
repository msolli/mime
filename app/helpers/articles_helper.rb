module ArticlesHelper

  def setup_article(article)
    [:images, :external_links].each do |method|
      article.send(method).build unless article.send(method).last && article.send(method).last.new_record?
    end
    article.build_location if article.location.nil?
    article
  end
end
