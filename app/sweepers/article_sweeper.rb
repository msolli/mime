class ArticleSweeper < Mongoid::Observing::Sweeper
  observe Article
  
  def after_update(article)
    expire_article_cache(article)
  end
  
  def after_destroy(article)
    expire_article_cache(article)
  end
  
  
  private
  def expire_article_cache(article)
    if self.controller
      path = ActionController::Caching::Actions::ActionCachePath.new(self, pretty_article_url(article, :host => 'ableksikon.no'), false)
      expire_fragment Regexp.new("#{Regexp.escape(path.path)}.*")
    end
  end
end
