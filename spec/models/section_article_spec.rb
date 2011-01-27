require 'spec_helper'

describe SectionArticle do

  # Missing gem mongoid-rspec (incompatible with mongoid 2.x)
  # it { should have_field(:headword).of_type(String) }
  # it { should have_field(:date).of_type(Date) }
  #
  # it { should be_embedded_in(:section) }
  # it { should be_referenced_in(:article) }
  #
  # it { should validate_presence_of(:headword) }
  # it { should validate_presence_of(:date) }

  describe "self.new_from_article" do
    let(:article) do
      Factory.build(:article)
    end

    context "when called with an article" do
      let(:s) do
        SectionArticle.new_from_article(article)
      end

      it "creates a new SectionArticle object with headword and article reference" do
        s.headword.should == article.headword_presentation
        s.article.should == article
      end

      it "has today's date" do
        s.date.should == Date.today
      end
    end

    context "when called with something that's not an article" do
      let(:s) do
        SectionArticle.new_from_article('bogus')
      end

      it "returns nil" do
        s.should be_nil
      end
    end

    context "when called with a date" do
      let(:s) do
        SectionArticle.new_from_article(article, Date.parse('2011-01-01'))
      end

      it "has the correct date" do
        s.date.should == Date.parse('2011-01-01')
      end
    end
  end
end
