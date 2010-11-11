require 'spec_helper'

describe Media do
  
  it { should be_referenced_in(:articles).as_inverse_of(:medias).stored_as(:array) }
  
  it { should have_fields(:description, :author, :file_uid).of_type(String) }
  it { should have_field(:date).of_type(DateTime) }
  it { should respond_to(:file) }

end
