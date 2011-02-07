require 'spec_helper'

describe ManualArticleList do

  context "when articles don't have date" do
    let(:list) do
      Factory.build(:manual_article_list)
    end

    before do
      2.times { list.list_articles << Factory.build(:list_article) }
      list.valid?
    end

    it "is not valid" do
      list.should_not be_valid
    end
    
    it "has two errors" do
      list.errors[:base].size.should == 2
    end
  end

  context "when articles have date" do
    let(:list) do
      Factory.build(:manual_article_list)
    end

    before do
      list.list_articles << Factory.build(:list_article, :date => Date.today)
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
      list.current_articles.first.date.should == Date.today
      list.current_articles.last.date.should == Date.today - 3
    end
  end
end
