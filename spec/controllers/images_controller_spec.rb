require 'spec_helper'

describe ImagesController do

  let(:article) { Factory(:article) }

  describe "#index" do
    context "with article parameter" do

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
  end

  describe "#create" do
    before do
      post :create, file: ActionDispatch::Http::UploadedFile.new({
        filename: 'png.png',
        content_type: 'image/png',
        tempfile: File.new(Rails.root + 'spec/data/png.png')
      }), article_id: article.to_param
    end

    it "is successful" do
      response.should be_success
    end

    it "returns an image form" do
      response.should render_template("edit")
    end

    it "does not assign a user" do
      assigns(:image).user.should be_nil
    end

    it "does not assign an author" do
      assigns(:image).author.should be_nil
    end
  end

  context "as a user" do
    login_user

    describe "#create" do
      before do
        post :create, file: ActionDispatch::Http::UploadedFile.new({
          filename: 'png.png',
          content_type: 'image/png',
          tempfile: File.new(Rails.root + 'spec/data/png.png')
        }), article_id: article.to_param
      end

      it "sets the user" do
        assigns(:image).user.should_not be_nil
      end

      it "sets the user's name as author" do
        assigns(:image).author.should == assigns(:image).user.name
      end

      it "renders the edit template" do
        response.should render_template('edit')
      end
    end
  end

  context "as an editor" do
    login_editor

    describe "#update" do
      let(:image) { Factory(:image) }

      before do
        image.license = :copyright
        put :update, id: image.to_param, image: image.attributes, article_id: article.to_param, format: :js
      end

      it "sets the license to :copyright" do
        assigns(:image).license.should == :copyright
      end
    end
  end

  describe "#update" do
    let(:image) { Factory(:image) }

    before do
      image.license = :copyright
      put :update, id: image.to_param, image: image.attributes, article_id: article.to_param, format: :js
    end

    it "adds the image to the article" do
      assigns(:image).articles.include?(article).should be_true
    end

    it "sets the license to :cc_by_sa" do
      assigns(:image).license.should == :cc_by_sa
    end

    it "renders the update template" do
      response.should render_template('update')
    end
  end
end
