# encoding: utf-8

require 'spec_helper'

describe "routing to alphabetic listing" do
  it "routes /a to HomeController#alphabetic" do
    { :get => "/a" }.should route_to(
      :controller => "home",
      :action => "alphabetic",
      :letter => "a")
  end

  # Does not work, bug in rails?
  # https://rails.lighthouseapp.com/projects/8994-ruby-on-rails/tickets/5805-assert_recognizes-does-not-support-constraints
  # it "does not route /aa" do
  #   { :get => "/aa" }.should_not be_routable
  # end
end

describe "routing to article versions" do
  it "routes /articles/1/versions to VersionsController#index" do
    { :get => "/articles/1/versions" }.should route_to(
      :controller => "versions",
      :action => "index",
      :article_id => "1")
  end
end