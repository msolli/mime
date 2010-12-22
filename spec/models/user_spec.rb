require 'spec_helper'

describe User do
  it { should have_field(:email).of_type(String) }
  it { should have_field(:password).of_type(String) }
  it { should have_field(:name).of_type(String) }
  it { should have_field(:facebook_token).of_type(String) }
  it { should have_field(:editor).of_type(Boolean) }

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }

  it { should be_referenced_in(:articles).as_inverse_of(:users).stored_as(:array) }

  it "has name_or_email with email" do
    u = User.new(:email => 'yo@yo.com')
    u.name_or_email.should == 'yo@yo.com'
  end

  it "has name_or_email with name" do
    u = User.new(:email => 'yo@yo.com', :name => "Yoman")
    u.name_or_email.should == 'Yoman'
  end

  it "has json format" do
    u = User.new(:email => 'yo@yo.com', :name => "Yoman")
    u.to_json.should =~ /"_id":/
    u.to_json.should =~ /"email":"yo@yo.com"/
    u.to_json.should =~ /"name":"Yoman"/
    u.to_json.should =~ /"name_or_email":"Yoman"/
    u.to_json.should_not =~ /encrypted_password/
    u.to_json.should_not =~ /facebook_token/
    u.to_json.should_not =~ /password/
  end

  describe "editor" do
    it "is false by default" do
      u = Factory(:user)
      u.editor?.should be_false
    end
  end
end
