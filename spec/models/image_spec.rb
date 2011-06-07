require 'spec_helper'

describe Image do
  context "with valid attributes" do
    let(:image) { Factory(:image) }

    it "is valid" do
      image.should be_valid
    end
  end

  describe "license attribute" do
    let(:image) { Factory(:image) }

    it "has :cc_by_sa as default value" do
      image.license.should == :cc_by_sa
    end

    it "is required" do
      image.license = nil
      image.should_not be_valid
    end

    it "can have :copyright as value" do
      image.license = :copyright
      image.should be_valid
    end

    it "can have no other value than :cc_by_sa or :copyright" do
      image.license = :foo
      image.should_not be_valid
    end
  end

  context "without author" do
    let(:image) { Factory(:image, author: nil) }
    before do
      image.valid?
    end

    it "is valid when it is created" do
      image.should be_persisted
    end

    it "is not valid when it is updated" do
      image.save
      image.should_not be_valid
    end

    it "has error message" do
      image.save
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
