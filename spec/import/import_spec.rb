# encoding: utf-8

require 'spec_helper'

describe "Import::ArticleXml" do
  describe "when parsing the xml" do
    before :each do
      xml = %[
        <lex-import>
          <article oldid="oldid **" id_def="id_def **">
            <metadata>
              <field id="epoch_start">1910</field>
              <field id="epoch_end">1940</field>
              <field id="subject">7413-92</field>
              <field id="author">FHvU</field>
              <field id="headword">Headword</field>
              <field id="clarification">Clarification **</field>
            </metadata>
            <html><head><meta http-equiv="content-type" content="text/html; charset=utf-8" /></head><body>
            <p>tidligere husmannsplass på Ostøya i Bærum, lå under <a class="crossref" href="sl14012479">Oust</a>.</p>
            </body></html>
          </article>
          <article>
          </article>
        </lex-import>
      ]
      @import = Import::Main.parse(Nokogiri::XML(xml, nil, "utf-8"))
    end

    it "has two article elements" do
      @import.articles.size.should == 2
    end

    it "has some attributes" do
      @import.articles.first.oldid.should == "oldid **"
      @import.articles.first.definition.should == "id_def **"
    end

    it "has metadata" do
      @import.articles.first.headword.should == "Headword"

      @import.articles.first.subject.should == "7413-92"
      @import.articles.first.authors.first.should == "FHvU"

      @import.articles.first.epoch_start.should == "1910"
      @import.articles.first.epoch_end.should == "1940"

      @import.articles.first.clarification == "Clarification **"
    end

    it "has body text" do
      @import.articles.first.text.should =~ /^<p><strong>Headword<\/strong>, tidligere husmannsplass på Ostøya/
      @import.articles.first.text.should =~ /under <a class="crossref" href="sl14012479">Oust<\/a>.<\/p>$/
    end

    it "has attributes hash" do
      @import.articles.first.attributes.class.should == Hash
    end
  end
end

describe "Import::Main" do
  before :each do
    xml = <<-EOXML
      <lex-import>
        <article id_def="gård i Asker"><metadata><field id="author">Forfatter1</field><field id="headword">Foo</field></metadata><html><body>Artikkeltekst **</body></html></article>
        <article id_def="gård i Bærum"><metadata><field id="author">Forfatter2</field><field id="headword">Foo</field></metadata><html><body>Artikkeltekst **</body></html></article>
        <article id_def="gård i Bærum"><metadata><field id="author">Forfatter1</field><field id="headword">Foo</field></metadata><html><body>Artikkeltekst **</body></html></article>
        <article><metadata><field id="author">UkjentForfatter</field><field id="headword">Bar</field></metadata><html><body>Artikkeltekst **</body></html></article>
        <article><metadata><field id="author">Forfatter1</field><field id="author">Forfatter2</field><field id="headword">Baz</field></metadata><html><body>Artikkeltekst **</body></html></article>
      </lex-import>
    EOXML
    @author_conf = YAML::load(%[
      editor: Red
      authors:
        Forfatter1:
          name: Forfatter1 Etternavn
          email: f1@ableksikon.no
        Forfatter2:
          name: Forfatter2 Etternavn
          email: f2@ableksikon.no
        Red:
          name: Redaksjonen
          email: redaksjonen@ableksikon.no
    ])
    @doc = Nokogiri::XML(xml, nil, "utf-8") do |config|
      config.noent
    end
  end

  it "throws no exceptions when importing" do
    lambda {
      Import::ArticleXml.all_authors = @author_conf['authors']
      Import::ArticleXml.editor = @author_conf['editor']
      Import::Main.run(@doc)
    }.should_not raise_error
  end

  describe "when importing" do
    before :each do
      Import::ArticleXml.all_authors = @author_conf['authors']
      Import::ArticleXml.editor = @author_conf['editor']
      Import::Main.run(@doc)
    end

    it "saves articles" do
      Article.all.count.should == 6
    end

    it "saves authors" do
      User.all.count.should == 3
    end

    it "checks for duplicates" do
      Article.where(:headword => 'Foo').first.text.should be_blank
      Article.where(:headword => 'Foo').first.ambiguous.should be_true
      Article.where(:headword => 'Foo (gård i Asker)').first.ambiguous.should be_true
      Article.where(:headword => 'Foo (gård i Bærum)').first.ambiguous.should be_true
      Article.where(:headword => 'Foo (gård i Bærum - 2)').first.ambiguous.should be_true
    end

    it "associates articles with users as authors" do
      Article.where(:headword => 'Foo (gård i Asker)').first.authors.first.should == User.where(:email => 'f1@ableksikon.no').first
      Article.where(:headword => 'Foo (gård i Bærum)').first.authors.first.should == User.where(:email => 'f2@ableksikon.no').first
      Article.where(:headword => 'Foo (gård i Bærum - 2)').first.authors.first.should == User.where(:email => 'f1@ableksikon.no').first
    end

    it "associates disambiguation articles to an author" do
      Article.where(:headword => 'Foo').first.authors.first.name.should == "Redaksjonen"
    end

    it "handles articles with unknown author" do
      Article.where(:headword => 'Bar').first.authors.first.should be_nil
    end

    it "handles multiple authors" do
      a = Article.where(:headword => 'Baz').first
      a.authors.size.should == 2
      a.authors.first.should == User.where(:email => 'f1@ableksikon.no').first
      a.authors.last.should == User.where(:email => 'f2@ableksikon.no').first
    end
  end
end

describe "Import::Crossref" do
  before :each do
    xml = <<-EOXML
      <lex-import>
        <article oldid="sl101"><metadata><field id="headword">Foo</field></metadata><html><body>Artikkeltekst **Lenke til <a class="crossref" href="sl102">Bar</a></body></html></article>
        <article oldid="sl102"><metadata><field id="headword">Bar</field></metadata><html><body>Artikkeltekst ** Lenke til <a class="crossref" href="sl">Baz</a></body></html></article>
        <article oldid="sl103"><metadata><field id="headword">Baz</field></metadata><html><body>Artikkeltekst **</body></html></article>
      </lex-import>
    EOXML
    @doc = Nokogiri::XML(xml, nil, "utf-8")
    Import::Main.run(@doc)
  end

  it "finds the referenced article when the crossref id is present" do
    crossref = Import::Crossref.new(Article.where(:oldid => "sl101").first)
    crossref.find_ref(crossref.refs.first).headword.should == 'Bar'
  end

  it "finds the referenced article when the crossref id is missing" do
    crossref = Import::Crossref.new(Article.where(:oldid => "sl102").first)
    crossref.find_ref(crossref.refs.first).headword.should == 'Baz'
  end

  it "raises exception when referenced article is not found" do
    xml = <<-EOXML
      <lex-import>
        <article oldid="sl200"><metadata><field id="headword">Xyzzy</field></metadata><html><body>Artikkeltekst **<a class="crossref" href="sl666">Ukjent</a></body></html></article>
      </lex-import>
    EOXML
    doc = Nokogiri::XML(xml, nil, "utf-8")
    Import::Main.run(doc)
    expect {
      crossref = Import::Crossref.new(Article.where(:oldid => "sl200").first)
      crossref.find_ref(crossref.refs.first)
    }.to raise_error(NoRefError)
  end

  it "updates crossrefs when the crossref id is present" do
    Import::Crossref.run
    foo = Article.where(:headword => 'Foo').first
    bar = Article.where(:headword => 'Bar').first
    foo.text.should =~ /#{bar.to_param}/
  end

  it "updates crossrefs when the crossref id is missing" do
    Import::Crossref.run
    bar = Article.where(:headword => 'Bar').first
    baz = Article.where(:headword => 'Baz').first
    bar.text.should =~ /#{baz.to_param}/
  end
end
