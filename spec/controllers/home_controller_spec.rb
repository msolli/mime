# coding: utf-8

require 'spec_helper'

describe HomeController do
  describe "#index" do
    it "is successful" do
      get :index
      response.should be_success
    end
  end

  describe "#alphabetic" do
    it "shows a list of articles" do
      Article.create!(:headword => "Asker")
      get :alphabetic, {:letter => 'a'}
      response.should be_success
      assigns(:articles).first.headword.should == "Asker"
    end

    it "shows articles where first char of headword is not a letter" do
      Article.create!(:headword => "«Hartmann»")
      get :alphabetic, {:letter => 'h'}
      response.should be_success
      assigns(:articles).first.headword.should == "«Hartmann»"
    end

    it "handles norwegian characters i url" do
      Article.create!(:headword => "Åh")
      get :alphabetic, {:letter => 'å'}
      response.should be_success
      assigns(:articles).first.headword.should == "Åh"
    end
  end
end
