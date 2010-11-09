class ArticlesController < ApplicationController
  before_filter :redirect_if_id, :only => [:show]
  before_filter :find_article, :only => [:show, :edit, :update]
  before_filter :add_ip_to_params, :only => [:create, :update]

  def new
    @article = Article.new
    set_user_return_to new_article_path
  end

  def create
    @article = Article.new(params[:article])
    @article.authors << current_user if current_user
    if @article.save
      redirect_to pretty_article_path(@article), :notice => t('articles.saved')
    else
      flash.alert = t('articles.errors.save')
      render :action => "new"
    end
  end

  def show
    redirect_to_unless_equal(@article, @slug)
    set_user_return_to pretty_article_path(@article)
  end

  def edit
    set_user_return_to edit_article_path(@article)
  end

  def update
    @article.attributes = params[:article]
    if @article.save
      Article.without_versioning do
        if current_user
          @article.authors = [current_user]
        else
          @article.update_attributes!(:user_ids => [])
        end
      end
      redirect_to pretty_article_path(@article), :notice => t('articles.saved')
    else
      flash.alert = t('articles.errors.save')
      render :action => "edit"
    end
  end

  private

  def redirect_if_id
    if params[:id]
      redirect_to pretty_article_path(params[:id]), :status => :moved_permanently
    end
  end

  def redirect_to_unless_equal(article, slug)
    unless article.to_param == slug.gsub(/\//, '%2F')
      from = article.headword == deparameterize(slug) ? '' : slug
      redirect_to pretty_article_path(@article), :status => :moved_permanently, :flash => { :redirected_from => from }
    end
  end

  def add_ip_to_params
    params[:article][:ip] = request.remote_ip
  end
end
