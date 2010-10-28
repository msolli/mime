# encoding: utf-8

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

    it "shows articles where the several first chars of headword are not letters" do
      Article.create!(:headword => "«'Hartmann'»")
      get :alphabetic, {:letter => 'h'}
      response.should be_success
      assigns(:articles).first.headword.should == "«'Hartmann'»"
    end

    it "handles norwegian characters i url" do
      Article.create!(:headword => "Åh")
      get :alphabetic, {:letter => 'å'}
      response.should be_success
      assigns(:articles).first.headword.should == "Åh"
    end

    it "sorts articles alphabetically" do
      Article.create!(:headword => "Ax")
      Article.create!(:headword => "Ab")
      get :alphabetic, {:letter => 'a'}
      assigns(:articles).first.headword.should == "Ab"
    end

    it "sorts articles with different case" do
      Article.create!(:headword => "Ax")
      Article.create!(:headword => "ab")
      get :alphabetic, {:letter => 'a'}
      assigns(:articles).first.headword.should == "ab"
    end

    it "sorts articles where first char is not a letter" do
      Article.create!(:headword => "«Ab»")
      Article.create!(:headword => "Ax")
      get :alphabetic, {:letter => 'a'}
      assigns(:articles).first.headword.should == "«Ab»"
      assigns(:articles).last.headword.should == "Ax"
    end

    it "sorts articles where several first chars are not letters" do
      Article.create!(:headword => "«'Ab'»")
      Article.create!(:headword => "Ax")
      get :alphabetic, {:letter => 'a'}
      assigns(:articles).first.headword.should == "«'Ab'»"
      assigns(:articles).last.headword.should == "Ax"
    end
  end
end
