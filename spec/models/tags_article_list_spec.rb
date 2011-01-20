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
    @list = Factory.create(:tags_article_list, :tags => ['foo'])
  end

  describe "#current_articles" do

    it "has 5 items" do
      @list.current_articles.size.should == 5
    end

    it "has ListArticles as items" do
      @list.current_articles.each do |a|
        a.class.should == ListArticle
      end
    end
  end

  describe "#invalidate_articles!" do
    it "updates the article list on the next day" do
      @list.date = Date.today - 1
      @list.save!
      @list.invalidate_articles!
      @list.current_articles.size.should == 5
    end
  end
end
