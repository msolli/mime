require 'spec_helper'

describe VersionsController do
  before :each do
    @a = Article.create!(:headword => 'foo')
    @a.update_attributes!(:text => "foo-tekst")
  end

  describe "#index" do
    it "shows article versions" do
      get :index, :article_id => @a.id
      response.should be_success
      assigns(:versions).size.should == 1
    end
  end
end
