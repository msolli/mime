require 'spec_helper'

describe Media do

  # Missing gem mongoid-rspec (incompatible with mongoid 2.x)
  # it { should be_referenced_in(:articles).as_inverse_of(:medias).stored_as(:array) }
  # 
  # it { should have_fields(:description, :author, :file_uid).of_type(String) }
  # it { should have_field(:date).of_type(DateTime) }
  # it { should respond_to(:file) }
  
  describe "Article with media" do
    it "should add async media uploads" do
      article = Article.new :headword => 'Foo'
    
      media1 = Media.create :file => open("#{Rails.root}/spec/data/gif.gif")
      media2 = Media.create :file => open("#{Rails.root}/spec/data/jpeg.jpeg")
      media3 = Media.create :file => open("#{Rails.root}/spec/data/png.png")
    
      article.media_ids_from_async_upload = "#{media1.id} #{media2.id} #{media3.id}"
    
      article.save
    
      article.medias.length.should == 3
      article.medias.first.file.mime_type.should == 'image/gif'
    end
  end
  
end
