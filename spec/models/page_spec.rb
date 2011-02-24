require 'spec_helper'

describe Page do
  let :page do
    Factory.build(:page)
  end

  context "with different article lists" do
    before do
      page.manual_article_lists.build(Factory.attributes_for(:manual_article_list))
      page.sorted_article_lists.build(Factory.attributes_for(:sorted_article_list))
      page.tags_article_lists.build(Factory.attributes_for(:tags_article_list))
    end

    it "has manual article lists" do
      page.manual_article_lists.length.should == 1
    end
    it "has sorted article lists" do
      page.sorted_article_lists.length.should == 1
    end
    it "has tags article lists" do
      page.tags_article_lists.length.should == 1
    end
    it "has article lists" do
      page.article_lists.length.should == 3
    end
    it "should have the manual list among the article lists" do
      page.article_lists.include?(page.manual_article_lists.first).should be_true
    end
    it "should have the sorted list among the article lists" do
      page.article_lists.include?(page.sorted_article_lists.first).should be_true
    end
    it "should have the tags list among the article lists" do
      page.article_lists.include?(page.tags_article_lists.first).should be_true
    end
  end

  context "with article lists with position" do
    before do
      page.manual_article_lists.build(Factory.attributes_for(:manual_article_list, position: 1))
      page.sorted_article_lists.build(Factory.attributes_for(:manual_article_list, position: 0))
      page.tags_article_lists.build(Factory.attributes_for(:manual_article_list, position: 2))
    end
    
    it "has article lists in the right positions" do
      page.article_lists[0].should == page.sorted_article_lists.first
      page.article_lists[1].should == page.manual_article_lists.first
      page.article_lists[2].should == page.tags_article_lists.first
    end
  end
end
