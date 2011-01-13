class PagesController < ApplicationController
  before_filter :find_page, :only => [:show, :edit, :update, :destroy]

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
    
  end

  def edit

  end

  def update
    @page.attributes = params[:page]
    if @page.save
      redirect_to @page, :notice => t('pages.saved')
    else
      flash.alert = t('pages.errors.save')
      render :action => 'edit'
    end
  end

  private

  def find_page
    @page = Page.criteria.id(params[:id]).first
  end
end
