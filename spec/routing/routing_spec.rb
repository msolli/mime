# encoding: utf-8

require 'spec_helper'

describe "routing to article versions" do
  it "routes /articles/1/versions to VersionsController#index" do
    { :get => "/articles/1/versions" }.should route_to(
      :controller => "versions",
      :action => "index",
      :article_id => "1")
  end
end
