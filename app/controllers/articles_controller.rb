class ArticlesController < ApplicationController
  def new
    @article = Article.new
  end

  def create
    @article = Article.new(params[:article])
    if @article.save
      flash[:notice] = t('articles.saved')
      redirect_to @article
    else
      flash[:error] = t('articles.errors.save')
      render :action => "new"
    end
  end

  def show
    @article = Article.find(params[:id])
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])
    @article.update_attributes!(params[:article])
    redirect_to(@article)
  end
end
