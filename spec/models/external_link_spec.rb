require 'spec_helper'

describe ExternalLink do
  before(:each) do
    @link = ExternalLink.new :href => 'http://ableksikon.no', :text => 'Ableksikon'
  end
  
  it 'should be valid' do
    @link.should be_valid
  end
  
  it "should validate that links are external" do
    @link.href = '/zippo'
    @link.should_not be_valid
  end
end
