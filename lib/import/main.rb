module Import
  class Main
    attr_reader :articles

    def initialize(doc)
      @articles = []
      # populate @articles from XML
      Rails.logger.debug("  MIME: Leser XML")
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

        Rails.logger.debug("  MIME: Sletter alle brukere")
        User.delete_all

        Rails.logger.debug("  MIME: Sletter alle artikler")
        Article.delete_all
        Rails.logger.debug("  MIME: Lagrer artikler")
        import.articles.each do |article|
          article.save!
        end

        Rails.logger.debug("Opprettet #{Article.count} artikler, hvorav #{Article.where(:ambiguous => true, :text => nil).count} flertydighetsartikler.")
        Rails.logger.debug("Opprettet #{User.count} brukere.")
      end
    end
  end
end
