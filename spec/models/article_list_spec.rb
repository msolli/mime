require 'spec_helper'

describe ArticleList do

  context "with name" do
    let(:list) do
      described_class.new(name: 'yo')
    end

    it "is valid" do
      list.should be_valid
    end
  end

  context "with default values" do
    let(:list) do
      Factory.build(:article_list)
    end

    it "has number of articles == 5" do
      list.number_of_articles.should == 5
    end

    it "has position == 0" do
      list.position.should == 0
    end
  end

  context "when there are no embedded list_articles" do
    let(:list) { Factory.build(:article_list) }

    it "is empty" do
      list.list_articles.should be_empty
    end

    describe "#current_articles" do
      it "is empty" do
        list.current_articles.should be_empty
      end
    end
  end

  context "when there are embedded list_articles" do
    let(:list) { Factory.build(:article_list) }

    before do
      10.times do
        list.list_articles << Factory.build(:list_article)
      end
    end

    it "is not empty" do
      list.list_articles.should_not be_empty
    end

    it "has some list_articles" do
      list.list_articles.size.should == 10
    end

    describe "#current_articles" do
      it "has 5 elements" do
        list.current_articles.size.should == 5
      end

      context "with number_of_articles" do
        before do
          list.number_of_articles = 10
        end

        it "has 10 elements" do
          list.current_articles.size.should == 10
        end
      end
    end
  end
end
