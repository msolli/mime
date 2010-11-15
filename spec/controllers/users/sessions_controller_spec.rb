require 'spec_helper'

describe ::Users::SessionsController do

  describe "#show" do
    it "should show the user profile" do
      request.env["devise.mapping"] = Devise.mappings[:user]
      u = User.create(:name => "Navn Navnesen", :email => 'nn@example.com')
      get :show, :id => u._id
      response.should be_success
    end
  end

  describe "#current" do
    it "should have empty username when not logged in" do
      request.env["devise.mapping"] = Devise.mappings[:user]
      get :current, :format => 'json'
      response.should be_success
    end
  end
end
