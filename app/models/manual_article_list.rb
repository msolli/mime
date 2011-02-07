class ManualArticleList < ArticleList
  include Mongoid::Document

  validate do
    list_articles.each do |a|
      errors.add(:base, I18n.t('manual_article_lists.errors.article_needs_date', :headword => a.headword)) if a.date.blank?
    end
  end

  def current_articles
    list_articles.desc(:date).limit(number_of_articles)
  end
end
