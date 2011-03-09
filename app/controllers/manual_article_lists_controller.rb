class ManualArticleListsController < ArticleListsController
  before_filter :find_page, only: [:new, :create, :edit, :update]
  authorize_resource class: "ManualArticleList"

  def new
    @article_list = ManualArticleList.new
    @article_list.list_articles.build
  end

  def create
    @article_list = ManualArticleList.new(params[:manual_article_list])
    if @article_list.valid?
      @page.manual_article_lists << @article_list
      redirect_to edit_page_path(@page)
    else
      flash.alert = t('article_lists.errors.save')
      @article_list.list_articles.build if @article_list.list_articles.empty?
      render :action => :new
    end
  end
  
  def edit
    @article_list = @page.manual_article_lists.find(params[:id])
  end

  def update
    @article_list = @page.manual_article_lists.find(params[:id])
    @article_list.attributes = params[:manual_article_list]
    if @article_list.save
      redirect_to edit_page_path(@page)
    else
      flash.alert = t('article_lists.errors.save')
      @article_list.list_articles.build if @article_list.list_articles.empty?
      render :action => :edit
    end      
  end
end
