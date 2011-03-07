# encoding: utf-8

require 'spec_helper'

describe ListArticle do

  context "with headword" do
    let(:article) { Factory :person_article }
    let(:la) { described_class.new(headword: article.headword) }

    it "finds article before validation" do
      la.should be_valid
      la.article.should == article
    end

    it "set article's presentation headword as headword" do
      la.should be_valid
      la.headword.should == article.headword_presentation
    end
  end

  context "with headword that has no corresponding article" do
    let(:la) { described_class.new(headword: 'bogus') }

    it "is not valid" do
      la.should_not be_valid
      la.article.should be_nil
      la.should have(1).error_on(:article)
    end
  end

  context "without headword" do
    it "is not valid" do
      la = described_class.new
      la.should_not be_valid
      la.errors[:headword].first.should == "Du må velge en artikkel"
    end
  end

  context "with no parent" do
    let(:la) do
      described_class.new(headword: Factory(:article).headword)
    end

    it "has listable that is nil" do
      la.listable.should be_nil
    end
  end

  context "with parent" do
    let(:la) do
      described_class.new(headword: Factory(:article).headword)
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
