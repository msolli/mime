require 'spec_helper'

describe Article do
  it "is valid with valid attributes" do
    article = Article.new(:headword => 'foo')
    article.should be_valid
  end

  it "is not valid without a headword" do
    article = Article.new
    article.should_not be_valid
  end

  it { should validate_presence_of(:headword) }
end
