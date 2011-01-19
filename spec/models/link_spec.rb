require 'spec_helper'

class TestLink < Link; end # Since Link is abstract

describe Link do
  
  # Missing gem mongoid-rspec (incompatible with mongoid 2.x)
  # it { TestLink.should have_fields(:href, :text).of_type(String) }
  
  it 'should be valid' do
    link = TestLink.new :href => 'http://ableksikon.no', :text => 'Ableksikon'
    link.should be_valid
  end
  
  it 'should use href as text if text is missing' do
    link = TestLink.new :href => 'http://ableksikon.no'
    link.text.should == 'http://ableksikon.no'
    link.text?.should be_false    
  end
end
