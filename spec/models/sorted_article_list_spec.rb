require 'spec_helper'

describe SortedArticleList do

  describe "#current_articles" do
    before do
      @articles = []
      10.times do |i|
        a = Factory.create(:article)
        timestamp = Time.parse("2011-01-%02d" % (i + 1))
        Article.collection.update({"_id" => a["_id"]}, { "$set" => { :created_at => timestamp, :updated_at => timestamp } })
        @articles << Article.find(a.id)
      end
    end

    let(:list) do
      Factory.build(:sorted_article_list)
    end

    it "has 5 items" do
      list.current_articles.size.should == 5
    end

    it "has ListArticles as items" do
      list.current_articles.each do |a|
        a.class.should == ListArticle
      end
    end
    
    it "has the last article created as first item" do
      list.current_articles.first.article.should == @articles.last
    end
    
    context "when sort_direction is asc" do
      before do
        list.sort_direction = :asc
      end
      
      it "has the first article created as first item" do
        list.current_articles.first.article.should == @articles.first
      end
    end
    
    context "when sort_field is headword and sort_direction is desc" do
      before do
        list.sort_field = :headword
      end
      
      it "has the last article created as first item" do
        list.current_articles.first.article.should == @articles.last
      end
    end

    context "when sort_field is headword and sort_direction is asc" do
      before do
        list.sort_field = :headword
        list.sort_direction = :asc
      end
      
      it "has the first article created as first item" do
        list.current_articles.first.article.should == @articles.first
      end
    end
  end
end
