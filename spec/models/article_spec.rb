require 'spec_helper'

describe Article do
  before(:each) do
    @article = Article.new(:headword => 'foo', :text => 'bar')
  end

  it "is valid with valid attributes" do
    @article.should be_valid
  end

  it "is not valid without a headword" do
    @article.headword = nil
    @article.should_not be_valid
  end

  it "is not valid without text" do
    @article.text = nil
    @article.should_not be_valid
  end

  it { should validate_presence_of(:headword) }
  it { should validate_presence_of(:text) }
end
