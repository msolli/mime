class ManualArticleList < ArticleList
  embedded_in :page, inverse_of: :manual_article_lists

  validate do
    # Add errors on blank published_on
    list_articles.map { |a| a.errors.add_on_blank(:published_on) }
    errors.add(:base, 'list_articles have errors') if list_articles.any? { |a| a.errors.any? }
  end

  def current_articles
    list_articles.desc(:published_on).limit(number_of_articles)
  end
end
