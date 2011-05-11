require 'spec_helper'

describe Image do
  context "with valid attributes" do
    let(:image) { Factory(:image) }
    
    it "is valid" do
      image.should be_valid
    end
  end

  context "without author" do
    let(:image) { Factory.build(:image, author: nil) }
    before do
      image.valid?
    end
    
    it "is not valid" do
      image.should_not be_valid
    end
    
    it "has error message" do
      image.errors[:author].should_not be_empty
    end
  end

  context "with user" do
    let(:user) { Factory(:user) }
    let(:image) { Factory(:image) }
    before do
      image.user = user
      image.save
    end

    it "has user" do
      image.user.should == user
    end

    it "is referenced in the user" do
      user.images.first.should == image
    end
  end
end
