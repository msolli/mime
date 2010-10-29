class ArticlesController < ApplicationController
  def new
    @article = Article.new
    session[:user_return_to] = new_article_path
  end

  def create
    @article = Article.new(params[:article])
    if @article.save
      redirect_to @article, :notice => t('articles.saved')
    else
      flash.alert = t('articles.errors.save')
      render :action => "new"
    end
  end

  def show
    @article = Article.find(params[:id])
  end

  def edit
    @article = Article.find(params[:id])
    session[:user_return_to] = edit_article_path(@article)
  end

  def update
    @article = Article.find(params[:id])
    @article.author = current_user
    @article.ip = request.remote_ip
    @article.update_attributes!(params[:article])
    redirect_to @article, :notice => t('articles.saved')
  end
end
