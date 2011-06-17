class ImagesController < ApplicationController
  include Mongoid::Observing::Sweeping

  before_filter :find_article, only: [:index, :create, :update]
  before_filter :article_not_found, only: [:index]

  cache_sweeper :article_sweeper, only: [:update]

  respond_to :js, only: [:update]

  def index
    @images = Image.order_by(:updated_at).limit(12)
    @image = Image.new
  end

  def create
    @image = Image.new
    @image.file = params[:file].tempfile
    if user_signed_in?
      @image.user = current_user
      @image.author = current_user.name
    end
    if @image.save
      render action: "edit", layout: false, status: :created
    else
      render :json => @image.errors, :status => :unprocessable_entity
    end
  end

  def update
    @image = Image.find(params[:id])
    @image.attributes = params[:image]
    @image.license = :cc_by_sa unless can? :manage, Image
    if @image.save
      @image.articles << @article
    else
      render :json => @image.errors, :status => :unprocessable_entity
    end
  end
end
