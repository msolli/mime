require 'spec_helper'

describe ArticlesController do

  describe "#new" do
    before :each do
      get :new
    end
    it "is successful" do
      response.should be_success
    end
    it "creates an article object" do
      assigns(:article).should_not be_nil
    end
  end
  
  describe "#create" do
    context "with a valid article" do
      before :each do
        post :create, :article => { :headword => "foo", :text => "bar" }
      end
      it "creates a new article" do
        assigns(:article).should_not be_nil
        assigns(:article).headword.should == "foo"
      end
      it "redirects to the article page" do
        response.should redirect_to article_path(assigns(:article))
      end
      it "sets a flash[:notice] message" do
        flash[:notice].should_not be_nil
      end
    end

    context "with an article with errors" do
      it "renders the #new template" do
        post :create, :article => { :headword => "foo", :text => "bar", :lng => "60", :lat => "10" }
        response.should render_template(:new)
      end
    end
  end
  
  describe "#show" do
    it "shows an article" do
      a = Article.create!(:headword => "foo", :text => "bar")
      get :show, :id => a.id
      response.should be_success
      assigns(:article).should_not be_nil
    end
  end

  describe "#edit" do
    it "edits an article" do
      a = Article.create!(:headword => "foo", :text => "bar")
      get :edit, :id => a.id
      response.should be_success
      assigns(:article).should_not be_nil
    end
  end

  describe "#update" do
    it "updates an article" do
      a = Article.create!(:headword => "foo", :text => "bar")
      put :update, :id => a.id, :article => { :text => "ny bar" }
      response.should redirect_to(a)
      assigns(:article).text.should == "ny bar"
    end
  end
end
