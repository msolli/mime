# encoding: utf-8

require 'spec_helper'
require 'cancan/matchers'

describe Ability do
  describe "user" do
    let :user do
      Factory(:user)
    end

    let :ability do
      Ability.new(user)
    end
    
    it "can not manage pages" do
      ability.should be_able_to(:read, Factory(:page))
      ability.should_not be_able_to(:manage, Factory(:page))
    end
    
    it "can not manage manual article lists" do
      ability.should be_able_to(:read, Factory(:manual_article_list))
      ability.should_not be_able_to(:manage, Factory(:manual_article_list))
    end
  end
  
  describe "editor" do
    let :editor do
      Factory(:editor)
    end
    
    let :ability do
      Ability.new(editor)
    end

    it "can manage pages" do
      ability.should be_able_to(:read, Factory(:page))
      ability.should be_able_to(:manage, Factory(:page))
    end

    it "can manage manual article lists" do
      ability.should be_able_to(:read, Factory(:manual_article_list))
      ability.should be_able_to(:manage, Factory(:manual_article_list))
    end
  end
end
