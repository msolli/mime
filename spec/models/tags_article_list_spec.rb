require 'spec_helper'

describe TagsArticleList do
  # Missing gem mongoid-rspec (incompatible with mongoid 2.x)
  # it { should have_field(:date).of_type(Date) }
  # it { should have_field(:tags).of_type(Array) }
  #
  # it { should validate_presence_of(:date) }

  before :each do
    5.times do
      Factory.create(:article, :tags => 'foo')
    end
  end

  let(:list) do
    Factory.build(:tags_article_list, :tags => ['foo'])
  end

  describe "#current_articles" do

    it "has 5 items" do
      list.current_articles.size.should == 5
    end

    it "has today's date" do
      list.date.should == Date.today
    end

    it "has ListArticles as items" do
      list.current_articles.each do |a|
        a.class.should == ListArticle
      end
    end

    it "does not update article list the same day" do
      current = list.current_articles
      list.should_not_receive(:randomize_articles!)
      list.current_articles.should == current
    end

    it "updates the article list on the next day" do
      list.should_receive(:randomize_articles!).and_return(Array.new(5))
      list.date = Date.today - 1
      list.current_articles.size.should == 5
    end

    context "when embedded in a page" do
      let(:p) do
        Factory(:page, :article_lists => [list])
      end

      it "does not update article list the same day" do
        current = p.article_lists.first.current_articles
        p.article_lists.first.should_not_receive(:randomize_articles!)
        p.article_lists.first.current_articles.should == current
      end

      it "updates the article list on the next day" do
        p.should_receive(:save)
        p.article_lists.first.date = Date.today - 1
        p.article_lists.first.current_articles.size.should == 5
      end
    end
  end
end
