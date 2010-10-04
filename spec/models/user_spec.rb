require 'spec_helper'

describe User do
  it { should have_field(:email).of_type(String) }
  it { should have_field(:password).of_type(String) }
  it { should have_field(:name).of_type(String) }
  it { should have_field(:facebook_token).of_type(String) }

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
end
