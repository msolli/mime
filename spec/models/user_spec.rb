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

  describe "roles" do
    before :all do
      @u = Factory(:user)
    end

    describe "no role" do
      it "is nil by default" do
        @u.role.should == nil
      end

      it "is not a user" do
        @u.role?('user').should be_false
      end

      it "is not an editor" do
        @u.role?('editor').should be_false
      end

      it "is not an admin" do
        @u.role?('admin').should be_false
      end
    end

    describe "user" do
      before :all do
        @u.role = 'user'
      end

      it "is a user" do
        @u.role?('user').should be_true
      end

      it "is not an editor" do
        @u.role?('editor').should be_false
      end

      it "is not an editor" do
        @u.role?('admin').should be_false
      end
    end

    describe "editor" do
      before :all do
        @u.role = 'editor'
      end

      it "has the role of 'user'" do
        @u.role?('user').should be_true
      end

      it "is an editor" do
        @u.role?('editor').should be_true
      end

      it "is not an editor" do
        @u.role?('admin').should be_false
      end
    end

    describe "admin" do
      before :all do
        @u.role = 'admin'
      end

      it "has the role of 'user'" do
        @u.role?('user').should be_true
      end

      it "is has the role of 'editor'" do
        @u.role?('editor').should be_true
      end

      it "is an editor" do
        @u.role?('admin').should be_true
      end
    end
  end
end
