require 'spec_helper'

describe TagsArticleList do

  describe "#current_articles" do

    before do
      10.times do
        Factory.create(:article, :tags => 'foo')
        Factory.create(:article, :tags => 'bar')
      end
    end

    let(:list) do
      Factory.build(:tags_article_list, :tags => ['foo'])
    end

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
      list.should_receive(:randomize_articles!)
      list.date = Date.today - 1
      list.current_articles
    end

    it "does not have duplicate elements" do
      list.current_articles.map(&:article).uniq.size.should == 5
      list.current_articles.map(&:article).uniq.should == list.current_articles.map(&:article)
      list.invalidate_articles!
    end
    
    it "has only items with the correct tags" do
      list.current_articles.each do |a|
        Article.criteria.id(a.article_id).first.tags_array.include?('foo').should be_true
      end
    end
    
    describe "#invalidate_articles!" do
      before do
        @old_current_articles = list.current_articles.dup
        list.invalidate_articles!
      end

      it "changes current_articles" do
        list.current_articles.should_not == @old_current_articles
      end
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
