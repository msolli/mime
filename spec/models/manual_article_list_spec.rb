require 'spec_helper'

describe ManualArticleList do

  context "when articles don't have a date" do
    let(:list) do
      Factory.build(:manual_article_list)
    end

    before do
      2.times do
        a = Factory(:article)
        list.list_articles << Factory.build(:list_article, headword: a.headword)
      end
      list.valid?
    end

    it "is not valid" do
      list.should_not be_valid
    end
    
    it "has one error" do
      list.errors[:base].size.should == 1
    end
  end

  context "when articles have a date" do
    let(:list) do
      Factory.build(:manual_article_list)
    end

    before do
      a = Factory(:article)
      list.list_articles << Factory.build(:list_article, published_on: Date.today, headword: a.headword)
      list.valid?
    end

    it "is valid" do
      list.should be_valid
    end
    
    it "has no errors" do
      list.errors[:base].should be_blank
    end
  end

  describe "#current_articles" do
    let(:list) do
      Factory.build(:todays_articles)
    end

    it "has articles sorted by date" do
      list.current_articles.first.published_on.should == Date.today
      list.current_articles.last.published_on.should == Date.today - 3
    end
  end
end
