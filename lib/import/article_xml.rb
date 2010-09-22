module Import
  class ArticleXml
    attr_reader :headword, :text
    attr_reader :subject, :author
    attr_reader :oldid, :definition, :epoch_start, :epoch_end, :clarification
    attr_reader :ambiguous

    def initialize(node)
      # TODO: subject
      # TODO: author  obs: kan ha flere
      # TODO: sette timestamp til da boka ble utgitt
      if headword_node = node.at_xpath('metadata/field[@id="headword"]')
        @headword = headword_node.content
      end
      if text_node = node.at_xpath('html/body')
        @text = CGI.unescapeHTML(text_node.inner_html.strip)
      end
      if subject_node = node.at_xpath('metadata/field[@id="subject"]')
        @subject = subject_node.content
      end
      if author_node = node.at_xpath('metadata/field[@id="author"]')
        @author = author_node.content
      end
      if epoch_start_node = node.at_xpath('metadata/field[@id="epoch_start"]')
        @epoch_start = epoch_start_node.content
      end
      if epoch_end_node = node.at_xpath('metadata/field[@id="epoch_end"]')
        @epoch_end = epoch_end_node.content
      end
      if clarification_node = node.at_xpath('metadata/field[@id="clarification"]')
        @clarification = clarification_node.content
      end
      @oldid = node[:oldid]
      @definition = node[:id_def]
      @ambiguous = false
    end

    # Oppretter artikkel. Dersom headword fins fra før skjer følgende:
    # * Artikkelen får et nytt headword et følgende mønster:
    #    - Foo (something)
    #    - Foo (something else)
    #    - Foo (something else - 2)
    #    - Foo (something else - 3)
    # * En 'disambiguation page' uten tekst opprettes.
    # * Alle disse får ambiguous-flagget satt.
    def save!
      begin
        Rails.logger.debug("  MIME: Prøver å opprette artikkel med standard headword")
        Article.create!(self.attributes)
      rescue Mongoid::Errors::Validations => e
        first = Article.where(:headword => @headword).first
        Rails.logger.debug("  MIME: Artikkel '#{first.headword}' fantes fra før")
        unless first.text.blank?  # not a disambiguation page - update it and create dis'n page
          first.update_attributes!(:headword => ArticleXml.extended_headword(first), :ambiguous => true)
          Rails.logger.debug("  MIME: Oppdaterte artikkel, nytt headword: '#{first.headword}'")
          Rails.logger.debug("  MIME: Oppretter disambiguation page")
          Article.create!(:headword => @headword, :ambiguous => true)
        end
        this_article = Article.new(self.attributes)
        this_article.ambiguous = true
        this_article.headword = ArticleXml.extended_headword(this_article)
        Rails.logger.debug("  MIME: Oppretter endelig artikkel med headword '#{this_article.headword}'")
        this_article.save!
      end
    end

    def attributes
      {
        :headword => @headword,
        :text => @text,
        :subject => @subject,
        :author => @author,
        :epoch_start => @epoch_start,
        :epoch_end => @epoch_end,
        :oldid => @oldid,
        :definition => @definition,
        :ambiguous => @ambiguous
      }
    end

    class << self
      def extended_headword(article)
        candidate = "#{article.headword} (#{article.definition})"
        while Article.where(:headword => candidate).first do
          pattern = /(\d+)\)$/
          if candidate =~ pattern
            # 'Foo (something - 2)' -> 'Foo (something - 3)'
            candidate = candidate.sub(pattern) {|s| "#{$1.to_i + 1})"}
          else
            # 'Foo (something)' -> 'Foo (something - 2)'
            candidate = "#{article.headword} (#{article.definition} - 2)"
          end
        end
        candidate
      end
    end
  end
end
