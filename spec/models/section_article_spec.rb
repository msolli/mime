require 'spec_helper'

describe SectionArticle do
  it { should have_field(:headword).of_type(String) }
  it { should have_field(:date).of_type(Date) }
  it { should reference_one(:article) }

  it { should validate_presence_of(:headword) }
  it { should validate_presence_of(:date) }
end
