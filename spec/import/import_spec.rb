require 'spec_helper'

describe "Import" do
  describe "::Article" do
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
              <html><head><meta http-equiv="content-type" content="text/html; charset=utf-8" /></head><body><![CDATA[
              <p>tidligere husmannsplass i på Ostøya i Bærum, lå under <a class="crossref" href="sl14012479">Oust</a>.</p>
              ]]></body></html>
            </article>
            <article>
            </article>
          </lex-import>
        ]
        @import = Import::Article.parse(xml)
        # @import = Import::Article.parse(open("#{Rails.root}/tmp/import/abl-p.xml"))
      end

      it "has two article elements" do
        @import.articles.size.should == 2
      end

      it "has some attributes" do
        @import.articles.first.oldid.should == "oldid **"
        @import.articles.first.id_def.should == "id_def **"
      end

      it "has metadata" do
        @import.articles.first.epoch_start.should == "1910"
        @import.articles.first.epoch_end.should == "1940"
        @import.articles.first.subject.should == "7413-92"
        @import.articles.first.author.should == "FHvU"
        @import.articles.first.id.should == "Headword"
        @import.articles.first.clarification.should == "Clarification **"
      end

      it "has body text" do
        @import.articles.first.text.should =~ /^<p>tidligere husmannsplass/
      end
    end
  end
end
