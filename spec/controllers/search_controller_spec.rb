require 'spec_helper'

describe SearchController do
  describe "#solr_error" do
    it "shows an error page" do
      Article.stub!(:search).and_raise(RSolr::Error::Http.new(nil, nil))
      get :new, :q => 'foo'
      response.should be_success
      response.should render_template("solr_error")
    end
  end
end
