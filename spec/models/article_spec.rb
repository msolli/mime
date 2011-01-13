# encoding: utf-8

require 'spec_helper'

describe Article do

  it { should be_referenced_in(:users).as_inverse_of(:articles).stored_as(:array) }
  it { should reference_many(:section_articles) }
  it { should reference_many(:list_articles) }

  it { should have_fields(:headword, :text).of_type(String) }
  it { should have_field(:headword_presentation).of_type(String) }
  it { should have_field(:definition).of_type(String) }
  it { should embed_one(:location) }
  it { should embed_many(:external_links) }
  it { should have_field(:years).of_type(Array) }
  it { should have_field(:end_year).of_type(Date) }
  it { should have_field(:disambiguation).of_type(String) }
  it { should have_field(:ip).of_type(String) }
  it { should have_field(:tags_array).of_type(Array) }

  it { should validate_presence_of(:headword) }
  it { should validate_uniqueness_of(:headword) }
  it { should validate_associated(:location) }
  it { should validate_associated(:external_links) }

  it "is valid with valid attributes" do
    article = Article.new(:headword => 'foo')
    article.should be_valid
  end

  it "validates uniqueness of :headword" do
    Article.create!(:headword => 'foo')
    lambda {
      Article.create!(:headword => 'foo')
    }.should raise_error(Mongoid::Errors::Validations)
  end

  it "uses headword when presentation headword is blank" do
    @article = Article.new(:headword => 'foo')
    @article.headword_presentation.should == 'foo'
  end

  it "has presentation headword with presentation headword" do
    @article = Article.new(:headword => 'foo', :headword_presentation => 'Foobar')
    @article.headword_presentation.should == 'Foobar'
  end

  it "does not set presentation headword when it's the same as headword" do
    @article = Article.new(:headword => 'foo')
    @article.headword_presentation = 'foo'
    @article['headword_presentation'].should be_nil
  end

  it "saves the author" do
    @article = Article.create!(:headword => 'foo')
    @user = User.create!(:email => 'yo@yo.com', :password => Devise.friendly_token)
    @article.authors << @user
    @article.save!
    @article.authors.first.email.should == 'yo@yo.com'
  end

  it "saves multiple authors" do
    @article = Article.create!(:headword => 'foo')
    @article.authors << User.create!(:email => 'yo1@yo.com', :password => Devise.friendly_token)
    @article.authors << User.create!(:email => 'yo2@yo.com', :password => Devise.friendly_token)
    @article.save!
    @article.authors.size.should == 2
    @article.authors.first.email.should == 'yo1@yo.com'
    @article.authors.last.email.should == 'yo2@yo.com'
  end

  describe "delete" do
    it "changes the headword" do
      a = Factory(:article)
      old_headword = a.headword
      a.delete
      a.headword.should_not == old_headword
      a.headword.should =~ /slettet:/
    end
  end

  describe "deleted_at" do
    it "is nil by default" do
      a = Factory(:article)
      a.deleted_at.should be_nil
    end
  end

  describe "location" do
    before :each do
      @article = Article.new :headword => 'foo', :location => Location.new(:lat => 23, :lng => 23)
    end
    
    it 'should be valid' do
      @article.should be_valid
      lambda { @article.save }.should change(Article, :count).by(1)
    end
    
    # mainly because mongodb doesn't support indices on null value fields
    it 'should be nil if it has empty lat and long' do
      @article.location = Location.new
      @article.save.should be_true
      @article.location.should be_nil
    end
  end
  
  describe "external_links" do
    before :each do
      @article = Article.new :headword => 'foo'
      @article.external_links << ExternalLink.new(:href => 'http://budstikka.no', :text => 'Budstikka')
    end
    
    it 'should be valid' do
      @article.should be_valid
      lambda { @article.save }.should change(Article, :count).by(1)
    end
  end

  describe "authors_or_ip" do
    before :each do
      @article = Article.new(:headword => 'foo')
      @article.ip = "127.0.0.1"
    end

    it "shows author name when author is present" do
      @article.authors << User.create!(:email => 'yo@yo.com', :password => Devise.friendly_token, :name => "Yoman")
      @article.authors_or_ip.should == 'Yoman'
    end

    it "shows all authors when multiple authors" do
      @article.authors << User.create!(:email => 'yo@yo.com', :password => Devise.friendly_token, :name => "Yoman Yo")
      @article.authors << User.create!(:email => 'foo@yo.com', :password => Devise.friendly_token, :name => "Fooman Foo")
      @article.authors_or_ip.should == 'Yoman Yo, Fooman Foo'
    end

    it "shows ip when no author" do
      @article.authors_or_ip.should == "127.0.0.1"
    end
  end

  describe "headword_sorting" do
    it "downcases headword" do
      @article = Article.new(:headword => 'Øy')
      @article.headword_sorting.should == '|y'
    end

    it "removes leading non-letter chars" do
      @article = Article.new(:headword => '«"Foo"»')
      @article.headword_sorting.should == 'foo'
    end

    it "truncates aa to å at the start of the headword" do
      @article = Article.new(:headword => 'Aas pilsener')
      @article.headword_sorting.should == '}spilsener'
    end

    it "truncates aa to å everywhere in the headword" do
      @article = Article.new(:headword => 'Maasepaase')
      @article.headword_sorting.should == 'm}sep}se'
    end
  end

  it "has versioning" do
    a = Article.create(:headword => 'foo')
    a.version.should == 1
    a.save
    a.version.should == 2
  end

  it "has versioning of ip attribute" do
    a = Article.new(:headword => "foo")
    a.ip = "127.0.0.1"
    a.save!
    a.text = "Yo"
    a.ip = "127.0.0.1"
    a.save!
    a.ip.should == "127.0.0.1"
    a.versions[0].ip.should == "127.0.0.1"
  end

  it "has tags" do
    a = Article.new(:headword => "foo")
    a.tags = "bar, baz, xyzzy"
    a.tags_array.sort.should == ['bar', 'baz', 'xyzzy']
    a.tags.should == "bar, baz, xyzzy"
  end

  it "has empty tags array" do
    a = Article.new(:headword => "foo")
    a.tags_array.should == []
    a.tags.should == ""
  end

  it "can append to empty tags array" do
    a = Factory(:article)
    a.tags_array << 'bar'
    a.save!
    a.tags.should == 'bar'
  end

  it "removes duplicates from tag array" do
    a = Factory(:article)
    a.tags = "bar, xyzzy, bar"
    a.save!
    a.tags_array.size.should == 2
    a.tags_array.include?('bar').should be_true
    a.tags_array.include?('xyzzy').should be_true
  end
end
