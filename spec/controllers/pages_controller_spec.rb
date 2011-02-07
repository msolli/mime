require 'spec_helper'

describe PagesController do

  describe "#show" do
    before :each do
      @page = Factory.build(:front_page)
      # 2.times do |i|
      #   @page.sections << Factory.build(:section)
      # end
      # @page.sections.each do |s|
      #   4.times do |i|
      #     s.articles << Factory.build(:section_article, :date => Date.today + i)
      #   end
      # end
      @page.save
      get :show, :id => @page.to_param
    end

    it "shows a page" do
      response.should be_success
    end

    it "has articles in first section" do
      response.should be_success
      assigns(:page).article_lists.where(:_type => "ManualArticleList").first.current_articles.length.should == 4
    end

    it "has articles in last section" do
      response.should be_success
      assigns(:page).article_lists.where(:_type => "ManualArticleList").last.current_articles.length.should == 4
    end
  end

  describe "#edit" do
    it "shows the edit form" do
      @page = Factory(:page)
      get :edit, :id => @page.to_param
      response.should be_success
      assigns(:page).should == @page
    end
  end

  describe "#new" do
    it "shows the new form" do
      get :new
      response.should be_success
      assigns(:page).should_not be_nil
    end
  end

  describe "#update" do
    it "updates a page" do
      @page = Factory(:page)
      put :update, :id => @page.to_param, :page => {:name => 'Foo'}
      response.should redirect_to(page_path(assigns(:page)))
      assigns(:page).name.should == 'Foo'
    end
  end
end
