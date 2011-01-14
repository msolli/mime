require 'spec_helper'

describe TagsArticleList do
  it { should have_field(:date).of_type(Date) }
  it { should have_field(:tags).of_type(Array) }

  it { should validate_presence_of(:date) }
end
