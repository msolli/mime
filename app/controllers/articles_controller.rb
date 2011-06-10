class ArticlesController < ApplicationController
  include Mongoid::Observing::Sweeping

  before_filter :redirect_if_id, :only => [:show]
  before_filter :find_article, :only => [:show, :edit, :update, :destroy]
  before_filter :article_not_found, :only => [:show, :edit, :update, :destroy]
  before_filter :redirect_to_canonical_url, :only => [:show]
  before_filter :add_ip_to_params, :only => [:create, :update]
  after_filter :login_teaser, :only => [:new, :edit]
  helper_method :sort_column, :sort_direction

  cache_sweeper :article_sweeper

  # Mobil kan spørre om artikkel både over xhr(uten layout), og via vanlig request(med layout). Derfor må vi skille i cache-stien også
  caches_action :show, :cache_path => Proc.new{ |c| # Må defineres _etter_ :before_filter
    opts = {:host => 'ableksikon.no'};
    opts[:format] = 'xhr' if is_mobile_view? && request.xhr?
    opts
  }

  def new
    @article = Article.new(headword: params[:headword])
    set_user_return_to new_article_path
  end

  def create
    @article = Article.new(params[:article])
    if @article.save
      add_author!
      redirect_to edit_article_path(@article), :notice => t('articles.created')
    else
      if @article.errors['headword'].first == t('mongoid.errors.models.article.attributes.headword.taken')
        @existing_article = Article.where(:headword => /^#{Regexp.escape(deparameterize(params[:article][:headword]))}$/i).first
      end
      flash.alert = t('articles.errors.create')
      render :action => "new"
    end
  end

  def show
    set_user_return_to pretty_article_path(@article)

    respond_to do |format|
      format.html
      format.json { render :json => {:url => pretty_article_path(@article)}}
      format.mobile { render :layout => !request.xhr? }
    end
  end

  def edit
    set_user_return_to edit_article_path(@article)
  end

  def update
    @article.add_async_uploads(params[:article].delete(:media_ids_from_async_upload))
    @article.attributes = params[:article]
    if @article.save
      add_author!
      redirect_to pretty_article_path(@article), :notice => t('articles.saved')
    else
      flash.alert = t('articles.errors.save')
      @article.headword = @article.attribute_was('headword') unless @article.errors[:headword].blank?
      render :action => "edit"
    end
  end

  def destroy
    old_headword = @article.headword_presentation
    @article.delete
    flash.notice = t('articles.deleted_html', :headword => old_headword)
    redirect_to root_path
  end

  def index
    @user = User.where(:email => params[:user_id]).first
    if @user.nil?
      respond_to do |format|
        format.html { render :file => "#{Rails.public_path}/404.html" , :status => :not_found, :layout => false }
        format.json { render :status => :not_found, :text => ''}
      end
      return
    end

    articles = @user.articles.sort_by {|a| a.send(sort_column)}
    articles.reverse! if sort_direction == "desc"

    current_page = params[:page].blank? ? 1 : params[:page].to_i
    per_page = 10
    @articles_pager = WillPaginate::Collection.create(current_page, per_page, articles.size) do |pager|
      start = (current_page - 1) * per_page
      pager.replace(articles[start, per_page])
    end
  end
  
  def random
    redirect_to pretty_article_url( Article.skip( rand(Article.count) ).limit(1).first )
  end

  private

  def redirect_if_id
    if params[:id] && !request.xhr?
      redirect_to pretty_article_path(params[:id]), :status => :moved_permanently
      log "REDIRECT ID: #{params[:id] }"
      return false
    end
  end

  def redirect_to_canonical_url
    unless @article.slug_is?(@slug)
      from = @article.headword == deparameterize(@slug) ? '' : @slug
      redirect_to pretty_article_path(@article), :status => :moved_permanently, :flash => { :redirected_from => from }
      log "REDIRECT #{@slug} -> #{pretty_article_path(@article)}"
      return false
    end
  end

  def add_ip_to_params
    params[:article][:ip] = request.remote_ip
  end

  def login_teaser
    unless user_signed_in?
      flash.notice = t('articles.login_teaser_html', :login_link => self.class.helpers.link_to(t('articles.login_link'), user_omniauth_authorize_path(:facebook)))
    end
  end

  def clear_flash
    flash.clear
  end

  def sort_column
    %w[headword_sorting updated_at].include?(params[:sort]) ? params[:sort] : "updated_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

  def add_author!
    Article.without_versioning do
      if user_signed_in?
        # TODO - sjonglering av id-er er et hack for å unngå at alle brukerens artikler
        # også blir oppdatert. Ideelt skulle vi kunne gjøre:
        # @article.users.clear
        # @article.users << current_user
        @article.update_attributes!(:user_ids => [current_user.id])
        current_user.update_attributes!(:article_ids => current_user.article_ids << @article.id)
      else
        @article.update_attributes!(:user_ids => [])
      end
    end
  end

  def add_medias!(medias_attributes)
    medias_attributes && medias_attributes.each_value do |m_attr|
      m = Media.find(m_attr[:id])
      m.update_attributes!(m_attr)
      @article.medias << m unless @article.medias.include?(m)
    end
  end
end
