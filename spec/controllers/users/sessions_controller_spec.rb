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

    it "returns 404 if user is not found" do
      get :show, :id => 'nobody'
      response.status.should == 404
      response.body.should =~ /The page you were looking for doesn't exist/
    end
  end

  describe "#current" do
    it "has empty username when not logged in" do
      get :current, :format => 'json'
      response.should be_success
    end
  end
end
