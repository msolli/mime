class ArticlesController < ApplicationController
  before_filter :redirect_if_id, :only => [:show]
  before_filter :find_article, :only => [:show, :edit, :update]
  before_filter :add_ip_to_params, :only => [:create, :update]
  before_filter :login_teaser, :only => [:new, :edit]

  def new
    @article = Article.new
    @article.build_location
    
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
    
    unless @article.slug_is?(@slug) || request.xhr?
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
        if user_signed_in?
          @article.update_attributes!(:user_ids => [current_user.id])
          current_user.articles << @article
        else
          @article.update_attributes!(:user_ids => [])
        end
      end
      redirect_to pretty_article_path(@article), :notice => t('articles.saved')
    else
      flash.alert = t('articles.errors.save')
      @article.headword = @article.attribute_was('headword') unless @article.errors[:headword].blank?
      render :action => "edit"
    end
  end

  private

  def redirect_if_id
    if params[:id] && !request.xhr?
      redirect_to pretty_article_path(params[:id]), :status => :moved_permanently
      return false
    end
  end

  def add_ip_to_params
    params[:article][:ip] = request.remote_ip
  end

  def login_teaser
    unless user_signed_in?
      flash.notice= t('articles.login_teaser_html', :login_link => self.class.helpers.link_to(t('articles.login_link'), user_omniauth_authorize_path(:facebook)))
    end
  end
end
