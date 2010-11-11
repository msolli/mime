require 'spec_helper'

describe ::Users::SessionsController do
  describe "#current" do
    it "should have empty username when not logged in" do
      request.env["devise.mapping"] = Devise.mappings[:user]
      get :current, :format => 'json'
      response.should be_success
    end
  end
end
