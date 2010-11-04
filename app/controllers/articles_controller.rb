class ArticlesController < ApplicationController
  before_filter :find_article, :only => [:show, :edit, :update]

  def new
    @article = Article.new
    session[:user_return_to] = new_article_path
  end

  def create
    @article = Article.new(params[:article])
    @article.authors << current_user if current_user
    @article.ip = request.remote_ip
    if @article.save
      redirect_to pretty_article_path(@article), :notice => t('articles.saved')
    else
      flash.alert = t('articles.errors.save')
      render :action => "new"
    end
  end

  def show
  end

  def edit
    session[:user_return_to] = edit_article_path(@article)
  end

  def update
    @article.authors << current_user if current_user
    @article.ip = request.remote_ip
    @article.update_attributes!(params[:article])
    redirect_to pretty_article_path(@article), :notice => t('articles.saved')
  end
end
