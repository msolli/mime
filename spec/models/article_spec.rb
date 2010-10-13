require 'spec_helper'

describe Article do

  it { should have_fields(:headword, :text).of_type(String) }
  it { should have_field(:headword_presentation).of_type(String) }
  it { should have_field(:definition).of_type(String) }
  it { should have_field(:location).of_type(Array) }
  it { should have_field(:years).of_type(Array) }
  it { should have_field(:end_year).of_type(Date) }
  it { should have_field(:ambiguous).of_type(Boolean) }

  it { should validate_presence_of(:headword) }
  it { should validate_uniqueness_of(:headword) }

  it "is valid with valid attributes" do
    article = Article.new(:headword => 'foo')
    article.should be_valid
  end

  it "validates uniqueness of :headword" do
    Article.create!(:headword => 'foo')
    lambda {
      Article.create!(:headword => 'foo')
    }.should raise_error(Mongoid::Errors::Validations)
  end

  it "uses headword when presentation headword is blank" do
    @article = Article.new(:headword => 'foo')
    @article.headword_presentation.should == 'foo'
  end

  it "has presentation headword with presentation headword" do
    @article = Article.new(:headword => 'foo', :headword_presentation => 'Foobar')
    @article.headword_presentation.should == 'Foobar'
  end

  context "with location" do
    before(:each) do
      @article = Article.new(:headword => 'foo')
    end

    it "has location when it has lng and lat" do
      @article.lat = 60
      @article.lng = 10
      @article.location.should == [60, 10]
      @article.should be_valid
    end

    it "has location when location array is set" do
      @article.location = [60, 10]
      @article.location.should == [60, 10]
      @article.should be_valid
    end

    it "is not valid without lng" do
      @article.lat = 60
      @article.should_not be_valid
    end

    it "is not valid without lat" do
      @article.lng = 10
      @article.should_not be_valid
    end

    it "is valid without both lng and lat" do
      @article.lat = nil
      @article.lng = nil
      @article.should be_valid
    end

    it "is valid with empty location array" do
      @article.location = []
      @article.should be_valid
    end

    it "is valid with lng and lat as empty strings" do
      @article.lat = ""
      @article.lng = ""
      @article.should be_valid
    end
  end
end
