require 'spec_helper'

describe ListArticle do
  # Missing gem mongoid-rspec (incompatible with mongoid 2.x)
  # it { should have_field(:headword).of_type(String) }
  #
  # it { should be_embedded_in(:article_list) }
  # it { should be_referenced_in(:article) }
  #
  # it { should validate_presence_of(:headword) }

  describe "self.new_from_article" do
    let(:article) do
      Factory.build(:article)
    end

    context "when called with an article" do
      let(:s) do
        ListArticle.new_from_article(article)
      end

      it "creates a new ListArticle object with headword and article reference" do
        s.headword.should == article.headword_presentation
        s.article.should == article
      end
    end

    context "when called with something that's not an article" do
      let(:s) do
        ListArticle.new_from_article('bogus')
      end

      it "returns nil" do
        s.should be_nil
      end
    end
  end
end
