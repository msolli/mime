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
      get :alphabetic, {:slug => 'a'}
      response.should be_success
      assigns(:articles).first.headword.should == "Asker"
    end

    it "shows articles where first char of headword is not a letter" do
      Article.create!(:headword => "«Hartmann»")
      get :alphabetic, {:slug => 'h'}
      response.should be_success
      assigns(:articles).first.headword.should == "«Hartmann»"
    end

    it "shows articles where the several first chars of headword are not letters" do
      Article.create!(:headword => "«'Hartmann'»")
      get :alphabetic, {:slug => 'h'}
      response.should be_success
      assigns(:articles).first.headword.should == "«'Hartmann'»"
    end

    it "handles norwegian characters i url" do
      Article.create!(:headword => "Åh")
      get :alphabetic, {:slug => 'å'}
      response.should be_success
      assigns(:articles).first.headword.should == "Åh"
    end

    it "sorts articles alphabetically" do
      Article.create!(:headword => "Ax")
      Article.create!(:headword => "Ab")
      get :alphabetic, {:slug => 'a'}
      assigns(:articles).first.headword.should == "Ab"
    end

    it "sorts articles with norwegian letters alphabetically" do
      Article.create!(:headword => "Arø")
      Article.create!(:headword => "Arå")
      Article.create!(:headword => "Aræ")
      get :alphabetic, {:slug => 'a'}
      assigns(:articles).first.headword.should == "Aræ"
      assigns(:articles)[1].headword.should == "Arø"
      assigns(:articles)[2].headword.should == "Arå"
    end

    it "sorts articles with different case" do
      Article.create!(:headword => "Ax")
      Article.create!(:headword => "ab")
      get :alphabetic, {:slug => 'a'}
      assigns(:articles).first.headword.should == "ab"
    end

    it "sorts articles where first char is not a letter" do
      Article.create!(:headword => "«Ab»")
      Article.create!(:headword => "Ax")
      get :alphabetic, {:slug => 'a'}
      assigns(:articles).first.headword.should == "«Ab»"
      assigns(:articles).last.headword.should == "Ax"
    end

    it "sorts articles where several first chars are not letters" do
      Article.create!(:headword => "«'Ab'»")
      Article.create!(:headword => "Ax")
      get :alphabetic, {:slug => 'a'}
      assigns(:articles).first.headword.should == "«'Ab'»"
      assigns(:articles).last.headword.should == "Ax"
    end
  end
end
