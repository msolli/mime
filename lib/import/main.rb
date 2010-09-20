module Import
  class Main
    attr_reader :articles

    def initialize(doc)
      @articles = []
      # populate @articles from XML
      doc.xpath("//article").map do |node|
        @articles << Import::ArticleXml.new(node)
      end
    end

    class << self
      def parse(doc)
        self.new(doc)
      end
      
      def run(doc)
        import = self.new(doc)
        import.articles.map do |article|
          article.save!
        end
      end
    end
  end
end
