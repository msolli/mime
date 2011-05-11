require 'spec_helper'

describe ImagesController do

  describe "#index" do
    context "with article parameter" do
      let(:article) { Factory(:article) }

      before do
        get :index, article_id: article.to_param
      end

      it "finds the article" do
        assigns(:article).should_not be_nil
      end

      it "is successful" do
        response.should be_success
      end

      it "shows a list of images to be added to an article" do
        assigns(:images).should_not be_nil
      end
    end

    context "with article that doesn't exist" do
      before do
        get :index, article_id: 'bogus'
      end

      it "returns 404" do
        response.should_not be_success
      end
    end

    context "without article parameter" do
      before do
        get :index
      end

      it "returns 404" do
        response.should_not be_success
      end
    end
  end

  describe "#create" do
    context "with article parameter" do
      
    end
    
  end
end
