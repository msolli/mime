# encoding: utf-8

require 'spec_helper'

describe "routing to alphabetic listing" do
  it "routes /a to HomeController#alphabetic" do
    { :get => "/a" }.should route_to(
      :controller => "home",
      :action => "alphabetic",
      :letter => "a")
  end

  # Does not work, bug in rspec-rails?
  # http://github.com/rspec/rspec-rails/issues/#issue/239
  # it "does not route /aa" do
  #   { :get => "/aa" }.should_not be_routable
  # end
end
