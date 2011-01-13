require 'spec_helper'

describe ListArticle do
  it { should have_field(:headword).of_type(String) }

  it { should be_embedded_in(:article_list) }
  it { should be_referenced_in(:article) }

  it { should validate_presence_of(:headword) }
end
