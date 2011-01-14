require 'spec_helper'

describe SortedArticleList do
  it { should have_field(:sort_direction).of_type(Symbol) }
  it { should have_field(:sort_field).of_type(Symbol) }
end
