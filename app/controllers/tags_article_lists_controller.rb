class TagsArticleListsController < ApplicationController
  before_filter :find_page, only: [:new, :create, :edit, :update]
  authorize_resource class: "TagsArticleList"

  def new
    @article_list = TagsArticleList.new
  end

  def create
    @article_list = TagsArticleList.new(params[:tags_article_list])
    if @article_list.valid?
      @page.tags_article_lists << @article_list
      redirect_to edit_page_path(@page)
    else
      flash.alert = t('article_lists.errors.save')
      render :action => :new
    end
  end

  def edit
    @article_list = @page.tags_article_lists.find(params[:id])
  end

  def update
    @article_list = @page.tags_article_lists.find(params[:id])
    @article_list.attributes = params[:tags_article_list]
    if @article_list.save
      redirect_to edit_page_path(@page)
    else
      flash.alert = t('article_lists.errors.save')
      render :action => :edit
    end
  end
end
