require 'spec_helper'

describe SortedArticleList do
  # Missing gem mongoid-rspec (incompatible with mongoid 2.x)
  # it { should have_field(:sort_direction).of_type(Symbol) }
  # it { should have_field(:sort_field).of_type(Symbol) }

  describe "#current_articles" do
    before :each do
      5.times do
        Factory.create(:article)
      end
      @list = Factory.create(:sorted_article_list)
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
