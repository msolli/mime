class PagesController < ApplicationController
  before_filter :find_page, :only => [:show, :edit, :update, :destroy]
  authorize_resource

  def new
    @page = Page.new
  end

  def create
    @page = Page.new(params[:page])
    if @page.save
      redirect_to @page, :notice => t('pages.saved')
    else
      flash.alert = t('pages.errors.save')
      render :action => 'new'
    end
  end

  def show
    if @page.frontpage?
      redirect_to root_url
      return
    end
  end

  def edit
  end

  def update
    if @page.update_attributes(params[:page])
      if params[:publish]
        expire_page_cache(@page)
        redirect_to root_path, :notice => t('pages.published')
      else
        redirect_to edit_page_path(@page), :notice => t('pages.saved')
      end
    else
      flash.alert = t('pages.errors.save')
      render :action => 'edit'
    end
  end

  private

  def expire_page_cache(page)
    path = ActionController::Caching::Actions::ActionCachePath.new(self, page)
    expire_fragment path.path
    if page.frontpage?
      path = ActionController::Caching::Actions::ActionCachePath.new(self, root_url)
      expire_fragment path.path
    end
  end
end
