require 'spec_helper'

describe ArticleList do
  # Missing gem mongoid-rspec (incompatible with mongoid 2.x)
  # it { should have_field(:name).of_type(String) }
  # it { should have_field(:number_of_articles).of_type(Integer) }
  # it { should be_embedded_in(:page) }
  # it { should embed_many(:articles) }
  # 
  # it { should validate_presence_of(:name) }

  it "validates presence of name" do
    list = ArticleList.new
    list.should_not be_valid
    list.errors[:name].should_not be_blank
  end

  it "is valid with name" do
    list = Factory.build(:article_list)
    list.should be_valid
    list.errors.should be_blank
  end
end
