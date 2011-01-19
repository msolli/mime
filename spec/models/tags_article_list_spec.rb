require 'spec_helper'

describe TagsArticleList do
  # Missing gem mongoid-rspec (incompatible with mongoid 2.x)
  # it { should have_field(:date).of_type(Date) }
  # it { should have_field(:tags).of_type(Array) }
  # 
  # it { should validate_presence_of(:date) }

  describe "#current_articles" do
    before :each do
      5.times do
        Factory.create(:article, :tags => 'foo')
      end
      @list = Factory.create(:tags_article_list, :tags => ['foo'])
    end

    it "has 5 items" do
      @list.current_articles.size.should == 5
    end

    it "has ListArticles as items" do
      @list.current_articles.each do |a|
        a.class.should == ListArticle
      end
    end
  end
end
