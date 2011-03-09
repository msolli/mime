require 'spec_helper'

describe PagesController do

  describe "#show" do
    context "front page as anonymous" do
      let(:page) { Factory :front_page }

      before do
        get :show, :id => page.to_param
      end

      it "redirects to root url" do
        response.should redirect_to(root_url)
      end

      it "has articles in first section" do
        assigns(:page).article_lists.first.current_articles.length.should == 4
      end

      it "has articles in last section" do
        assigns(:page).article_lists.last.current_articles.length.should == 4
      end
    end
  end

  describe "#edit" do
    context "as a user" do
      user_redirects_to_home
    end

    context "as an editor" do
      login_editor

      let(:page) { Factory :page }

      it "shows the edit form" do
        get :edit, :id => page.to_param
        response.should be_success
        assigns(:page).should == page
      end
    end
    
  end

  describe "#new" do
    context "as a user" do
      user_redirects_to_home
    end

    context "as an editor" do
      login_editor

      it "shows the new form" do
        get :new
        response.should be_success
        assigns(:page).should_not be_nil
      end
    end
  end

  describe "#update" do
    context "as a user" do
      user_redirects_to_home
    end

    context "as an editor" do
      login_editor

      it "updates a page" do
        @page = Factory(:page)
        put :update, :id => @page.to_param, :page => {:name => 'Foo'}
        response.should redirect_to(edit_page_path(assigns(:page)))
        assigns(:page).name.should == 'Foo'
      end
    end
  end
end
