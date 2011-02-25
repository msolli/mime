# encoding: utf-8

require 'spec_helper'

describe ArticlesController do
  
  describe "mobile" do
    render_views
    before :each do
      Article.create!(:headword => 'foo', :text => 'bar')
      @request.host = 'mobil.example.com'
    end
    
    it 'should have mobile format' do
      get :show, :slug => 'foo'
      @request.format.should == 'mobile'
    end
    
    it "should serve layout if the request is not xhr" do
      get :show, :slug => 'foo'
      response.body.should match /^<!DOCTYPE html>/
    end
    
    it "should not serve layout if request is xhr" do
      xhr :get, :show, :slug => 'foo'
      response.body.should match /^<div.*data-role=["']page["']/
    end
    
  end

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
        response.should redirect_to pretty_article_path(assigns(:article))
      end
      it "sets a flash[:notice] message" do
        flash[:notice].should_not be_nil
      end
      it "has IP adresse" do
        assigns(:article).authors_or_ip.should == "0.0.0.0"
      end
    end

    context "with an article with errors" do
      before :each do
        post :create, :article => { :headword => "foo" }
      end
      it "renders the #new template" do
        # Should fail on unique headword constraint
        post :create, :article => { :headword => "foo"}
        response.should render_template(:new)
      end
    end
  end

  describe "#show" do
    it "shows an article with pretty url" do
      a = Article.create!(:headword => "foo")
      get :show, :slug => 'foo'
      response.should be_success
      assigns(:article).should_not be_nil
    end

    it "redirects to canonical url when id parameter is set" do
      a = Article.create!(:headword => "Foo")
      get :show, :id => 'Foo'
      response.should redirect_to(pretty_article_path(a))
    end

    it "redirects to canonical url when slug has wrong case" do
      a = Article.create!(:headword => "Foo")
      get :show, :slug => 'foo'
      response.should redirect_to(pretty_article_path(a))
      flash[:redirected_from].should == 'foo'
    end

    it "redirects to canonical url when slug contains spaces" do
      a = Article.create!(:headword => "foo bar")
      get :show, :slug => 'foo bar'
      response.should redirect_to(pretty_article_path(a))
      flash[:redirected_from].should be_blank
    end

    it "redirects to canonical url when slug contains escaped slash" do
      a = Article.create!(:headword => "foo / bar")
      get :show, :slug => 'foo %2F bar'
      response.should redirect_to(pretty_article_path(a))
      flash[:redirected_from].should be_blank
    end

    it "does not redirect when slug contains non-escaped slash" do
      a = Article.create!(:headword => "foo/bar")
      get :show, :slug => 'foo/bar'
      response.should be_success
      assigns(:article).should_not be_nil
    end

    it "sends a 404 response if the article doesn't exist" do
      get :show, :slug => '12345'
      response.should_not be_success
      response.body.should =~ /The page you were looking for doesn't exist/
    end

    it "sends an empty 404 response if the request is JSON and the article doesn't exist" do
      get :show, :slug => '12345', :format => :json
      response.should_not be_success
      response.body.should == ""
    end

    it "redirects to canonical url if slug matches a version" do
      a = Article.create!(:headword => "foo")
      a.headword = "bar"
      a.save!
      get :show, :slug => "foo"
      response.should redirect_to(pretty_article_path(a))
    end
  end

  describe "#edit" do
    it "edits an article" do
      a = Article.create!(:headword => "foo", :text => "bar")
      get :edit, :id => a.to_param
      response.should be_success
      assigns(:article).should_not be_nil
    end
  end

  describe "#update" do
    it "updates an article" do
      a = Article.create!(:headword => "foo", :text => "bar")
      put :update, :id => a.to_param, :article => { :text => "ny bar" }
      response.should redirect_to(pretty_article_path(assigns(:article)))
      assigns(:article).text.should == "ny bar"
    end
  end

  describe "#delete" do
    it "deletes an article" do
      a = Factory(:article)
      delete :destroy, :id => a.to_param
      response.should redirect_to(root_path)
      assigns(:article).deleted_at.should_not be_nil
      assigns(:article).headword.should_not == a.headword
    end
  end

  describe "#index" do
    it "shows a list of articles for a user" do
      u = Factory(:user)
      10.times do
        a = Factory(:article)
        a.authors << u
      end
      get :index, :user_id => u.to_param
      response.should be_success
      assigns(:articles_pager).size.should == 10
    end

    it "shows 404 if the user does not exist" do
      get :index, :user_id => "does_not_exist"
      response.should_not be_success
      response.body.should =~ /The page you were looking for doesn't exist/
    end

    describe "sorting" do
      before :each do
        @u = Factory(:user)
        %w(snerk bukse åker føner samlebånd).each do |headword|
          a = Article.new(:headword => headword)
          a.authors = [@u]
          a.save
        end
      end

      it "sorts a user's articles by headword" do
        get :index, :user_id => @u.to_param, :sort => 'headword_sorting', :direction => 'asc'
        response.should be_success
        assigns(:articles_pager).first.headword.should == 'bukse'
        assigns(:articles_pager).last.headword.should == 'åker'
      end

      it "sorts a user's articles by headword, descending" do
        get :index, :user_id => @u.to_param, :sort => 'headword_sorting', :direction => 'desc'
        response.should be_success
        assigns(:articles_pager).first.headword.should == 'åker'
        assigns(:articles_pager).last.headword.should == 'bukse'
      end
    end
  end
end
