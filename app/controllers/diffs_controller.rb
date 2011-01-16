class DiffsController < ApplicationController
  before_filter :find_article
  
  def show
    if params[:cmp_versions].length > 2
      redirect_to article_versions_path(@article), :alert => t('articles.versions.can_only_compare_two_versions')
      return
    elsif params[:cmp_versions].length < 2
      redirect_to article_versions_path(@article), :alert => t('articles.versions.need_two_versions_to_compare')
      return
    end
    
    f1, f2 = params[:cmp_versions].map(&:to_i)
    
    @v1 = @article.version == f1 ? @article : @article.versions.to_a.find{|v| v.version == f1}
    @v2 = @article.versions.to_a.find{|v| v.version == f2 }
    
    unless @v1 && @v2
      redirect_to article_versions_path(@article),  :alert => t('articles.versions.one_or_more_invalid_version')
      return
    else
      @imgdiff = {:removed => @v2.medias - @v1.medias, :added => @v1.medias - @v2.medias, :intersect => @v1.medias & @v2.medias}
    end
  end
  
end
