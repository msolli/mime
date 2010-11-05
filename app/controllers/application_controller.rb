class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'

  private

  def find_article
    slug = if !params[:slug].blank?
      params[:slug]
    elsif !params[:article_id].blank?
      params[:article_id]
    else
      params[:id]
    end
    @req_headword = deparameterize(slug)
    @article = Article.where(:headword => /^#{Regexp.escape(@req_headword)}$/i).first
  end

  def deparameterize(thing)
    thing.gsub(/%2F/, '/').gsub(/_/, ' ')
  end

end
