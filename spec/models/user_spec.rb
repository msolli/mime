require 'spec_helper'

describe User do
  it { should have_field(:email).of_type(String) }
  it { should have_field(:password).of_type(String) }
  it { should have_field(:name).of_type(String) }
  it { should have_field(:facebook_token).of_type(String) }

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
end
