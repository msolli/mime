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
    it "creates a new article" do
      post :create, :article => { :headword => "foo" }
      assigns(:article).should_not be_nil
      assigns(:article).headword.should == "foo"
    end
    it "redirects to the article page" do
      post :create, :article => { :headword => "foo" }
      response.should redirect_to article_path(assigns(:article))
    end
  end
  
  describe "#show" do
    it "shows an article" do
      a = Article.create!(:headword => "foo")
      get :show, :id => a.id
      response.should be_success
      assigns(:article).should_not be_nil
    end
  end
end
