require 'spec_helper'

describe TagsArticleList do

  it "is valid with valid attributes" do
    list = Factory.build(:tags_article_list)
    list.should be_valid
  end

  it "has today's date as default" do
    list = Factory.build(:tags_article_list)
    list.date.should == Date.today
  end

  it "has tags" do
    list = Factory.build(:tags_article_list)
    list.tags = "bar, baz, xyzzy"
    list.tags_array.sort.should == ['bar', 'baz', 'xyzzy']
    list.tags.should == "bar, baz, xyzzy"
  end

  it "has empty tags array" do
    list = Factory.build(:tags_article_list)
    list.tags_array.should == []
    list.tags.should == ""
  end

  it "can append to empty tags array" do
    list = Factory.build(:tags_article_list)
    list.tags_array << 'bar'
    list.tags.should == 'bar'
  end

  it "removes duplicates from tag array" do
    list = Factory.build(:tags_article_list)
    list.tags = "bar, xyzzy, bar"
    list.valid?
    list.tags_array.size.should == 2
    list.tags_array.include?('bar').should be_true
    list.tags_array.include?('xyzzy').should be_true
  end

  describe "#current_articles" do

    before do
      10.times do
        Factory.create(:article, :tags => 'foo')
        Factory.create(:article, :tags => 'bar')
      end
    end

    describe "when tags is empty" do
      let(:list) do
        Factory.build(:tags_article_list)
      end

      it "has no items" do
        list.current_articles.size.should == 0
      end
    end

    describe "when it has tags" do

      let(:list) do
        Factory.build(:tags_article_list, :tags => 'foo')
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

      it "has article reference in ListArticle items" do
        list.current_articles.each do |a|
          a.article.class.should == Article
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

      it "has the right number of articles on the next day" do
        list.current_articles
        list.date = Date.today - 1
        list.current_articles.size.should == 5
      end

      it "does not have duplicate elements" do
        list.current_articles.map(&:article).uniq.size.should == 5
        list.current_articles.map(&:article).uniq.should == list.current_articles.map(&:article)
        list.invalidate_articles!
      end

      it "has only items with the correct tags" do
        list.current_articles.each do |a|
          Article.find(a.article_id).tags_array.include?('foo').should be_true
        end
      end

      it "does not try forever to find articles with the correct tags" do
        list.number_of_articles = 11
        list.current_articles.size.should == 10
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
        let(:p) { Factory :page }

        before do
          p.tags_article_lists << list
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
end
