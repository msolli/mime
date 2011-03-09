# encoding: utf-8

require 'spec_helper'

describe "routing to alphabetic listing" do
  it "routes /a to HomeController#alphabetic" do
    get '/a'
    response.should be_success
    response.body.should match(/Artikler på A/)
  end

  it "does not route /aa" do
    get '/aa'
    response.code.should == "404"
  end
end

# describe "routing to article versions" do
#   it "routes /articles/1/versions to VersionsController#index" do
#     { :get => "/articles/1/versions" }.should route_to(
#       :controller => "versions",
#       :action => "index",
#       :article_id => "1")
#   end
# end
