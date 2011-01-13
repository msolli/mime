require 'spec_helper'

describe Page do
  it "has sections" do
    @page = Factory.build(:page)
    @page.sections << Factory.build(:section)
    @page.sections << Factory.build(:section)
    @page.save
    @page.sections.length.should == 2
  end
end
