module Import
  class Crossref
    include Rails.application.routes.url_helpers

    attr_reader :article, :xml, :refs
    def initialize(article)
      @article = article
      @html = Nokogiri::HTML.fragment(article.text)
      @refs = @html.css('a.crossref').select do |node|
        node['href'] =~ /^sl/
      end
    end

    def update!
      unless @refs.blank?
        @refs.each do |node|
          old_href = node['href']
          begin
            ref = find_ref(node)
          rescue NoRefError => e
            puts e.message
            next
          end
          Rails.logger.debug("  MIME: Oppdaterer artikkel '#{@article.headword}' med ny referanse ('#{old_href}' -> '#{article_path(ref)}')")
          node['href'] = pretty_article_path(ref)
        end
        @article.text = @html.to_s
        Article.without_versioning do
          @article.save
        end
      end
    end

    def find_ref(node)
      unless ref = Article.where(:oldid => node['href']).first
        unless ref = Article.where(:headword => node.content.strip).first
          raise NoRefError, "Fant ikke referert artikkel (href => '#{node['href']}', headword => '#{node.content.strip}'), referert fra #{@article.headword}"
        end
      end
      ref
    end

    class << self
      def run
        Article.all.each do |article|
          crossref = self.new(article)
          crossref.update!
        end
      end
    end
  end
end

class NoRefError < StandardError
end
