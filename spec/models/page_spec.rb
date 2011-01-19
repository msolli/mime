require 'spec_helper'

describe Page do
  it "has sections" do
    @page = Factory.build(:page)
    @page.sections << Factory.build(:section)
    @page.sections << Factory.build(:section)
    @page.save!
    @page.sections.length.should == 2
  end

  it "has article lists" do
    @page = Factory.build(:page)
    @page.article_lists.build(Factory.attributes_for(:article_list))
    @page.save!
    @page.article_lists.length.should == 1
  end
end
