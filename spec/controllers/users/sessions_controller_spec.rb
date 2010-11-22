# encoding: utf-8

require 'spec_helper'

describe ::Users::SessionsController do
  before :each do
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "#show" do
    it "shows the user profile" do
      u = Factory(:user)
      get :show, :id => u.to_param
      response.should be_success
      assigns(:user).should_not be_nil
    end

    describe "sorting" do
      before :each do
        @u = Factory(:user)
        %w(bukse snerk åker føner samlebånd).each do |headword|
          a = Article.new(:headword => headword)
          a.authors = [@u]
          a.save
        end
      end

      it "sorts a user's articles by headword" do
        get :show, :id => @u.to_param, :sort => 'headword_sorting'
        response.should be_success
        assigns(:articles).first.headword.should == 'bukse'
        assigns(:articles).last.headword.should == 'åker'
      end

      it "sorts a user's articles by headword, descending" do
        get :show, :id => @u.to_param, :sort => 'headword_sorting', :direction => 'desc'
        response.should be_success
        assigns(:articles).first.headword.should == 'åker'
        assigns(:articles).last.headword.should == 'bukse'
      end
    end
  end

  describe "#current" do
    it "has empty username when not logged in" do
      get :current, :format => 'json'
      response.should be_success
    end
  end
end
