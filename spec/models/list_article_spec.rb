require 'spec_helper'

describe ListArticle do

  context "without headword" do
    it "is not valid" do
      la = described_class.new
      la.should_not be_valid
    end
  end

  describe "self.new_from_article" do
    let(:article) do
      Factory.build(:article)
    end

    context "with an article" do
      let(:la) do
        described_class.new_from_article(article)
      end

      it "creates a new ListArticle object with headword and article reference" do
        la.headword.should == article.headword_presentation
        la.article.should == article
      end

      it "has today's date" do
        la.date.should == Date.today
      end

      it "is valid" do
        la.should be_valid
      end
    end

    context "with date" do
      let(:la) do
        described_class.new_from_article(article, Date.today - 1)
      end

      it "has the correct date" do
        la.date.should == (Date.today - 1)
      end
    end
  end

  context "with no parent" do
    let(:la) do
      described_class.new_from_article(Factory.build(:article))
    end

    it "has listable that is nil" do
      la.listable.should be_nil
    end
  end

  context "with parent" do
    let(:la) do
      described_class.new_from_article(Factory.build(:article))
    end

    let(:list) do
      Factory.build(:article_list)
    end

    before do
      list.list_articles << la
    end

    it "has listable" do
      la.listable.should_not be_nil
      la.listable.list_articles.first.should == la
    end
  end
end
