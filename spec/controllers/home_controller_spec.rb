require 'spec_helper'

describe HomeController do
  describe "#index" do
    it "is successful" do
      get :index
      response.should be_success
    end
  end

  describe "#alphabetic" do
    it "show a list of articles" do
      Article.create!(:headword => "Asker")
      get :alphabetic, {:letter => 'a'}
      response.should be_success
      assigns(:articles).first.headword.should == "Asker"
    end
  end
end
