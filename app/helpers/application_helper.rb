module ApplicationHelper
  def time_ago_in_mostly_words(time)
    if time < Time.now - 7.days
      l(time.to_date, :format => :long)
    else
      t('articles.time_ago', :time_ago => time_ago_in_words(time))
    end
  end
end
