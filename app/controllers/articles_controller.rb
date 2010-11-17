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
    @article.authors << current_user if user_signed_in?
    if @article.save
      redirect_to pretty_article_path(@article), :notice => t('articles.saved')
    else
      flash.alert = t('articles.errors.save')
      render :action => "new"
    end
  end

  def show
    if @article.nil?
      respond_to do |format|
        format.html { render :file => "#{Rails.public_path}/404.html" , :status => :not_found, :layout => false }
        format.json { render :status => :not_found, :text => ''}
      end
      return
    end
    set_user_return_to pretty_article_path(@article)
    
    unless @article.slug_is?(@slug)
      from = @article.headword == deparameterize(@slug) ? '' : @slug
      redirect_to pretty_article_path(@article), :status => :moved_permanently, :flash => { :redirected_from => from }
      return
    end
    
    respond_to do |format|
      format.html
      format.json { render :json => {:url => pretty_article_path(@article)}}
    end
  end

  def edit
    set_user_return_to edit_article_path(@article)
  end

  def update
    @article.attributes = params[:article]
    if @article.save
      Article.without_versioning do
        @article.update_attributes!(:user_ids => user_signed_in? ? [current_user.id] : [])
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
      return false
    end
  end

  def add_ip_to_params
    params[:article][:ip] = request.remote_ip
  end
end
