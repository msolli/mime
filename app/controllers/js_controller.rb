# encoding: utf-8

class JsController < ApplicationController
  layout :false
  before_filter :never_expire
  
  def show
    render :js => "var mime = mime || {}; mime.translations = #{t('javascript').to_json}"
  end
  
  private
  def never_expire
    expires_in 1.year, :public => true
  end
  
end
