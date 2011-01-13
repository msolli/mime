require 'spec_helper'

describe ArticleList do
  it { should have_field(:name).of_type(String) }
  it { should have_field(:date).of_type(Date) }
  it { should have_field(:tags).of_type(Array) }
  it { should have_field(:number_of_articles).of_type(Integer) }
  it { should be_embedded_in(:page) }
  it { should embed_many(:articles) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:date) }

end
