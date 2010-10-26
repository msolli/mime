# encoding: utf-8

module Import
  class ArticleXml
    cattr_accessor :authors
    cattr_accessor :editor

    attr_reader :headword, :text
    attr_reader :subject, :author, :user
    attr_reader :oldid, :definition, :epoch_start, :epoch_end, :clarification
    attr_reader :ambiguous

    def initialize(node)
      # TODO: subject
      # TODO: flere forfattere
      # TODO: sette timestamp til da boka ble utgitt
      if headword_node = node.at_xpath('metadata/field[@id="headword"]')
        @headword = headword_node.content
      end
      if text_node = node.at_xpath('html/body')
        @text = CGI::unescapeHTML(text_node.inner_html.strip)
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
      # Find or create the author
      @user = if ArticleXml.authors[@author].instance_of?(Hash)
        ArticleXml.get_user(ArticleXml.authors[@author]['email'],
                            ArticleXml.authors[@author]['name'])
      else
        nil
      end

      begin
        Rails.logger.debug("  MIME: Prøver å opprette artikkel med standard headword")
        Article.create!(self.attributes)
      rescue Mongoid::Errors::Validations => e
        first = Article.where(:headword => @headword).first
        Rails.logger.debug("  MIME: Artikkel '#{first.headword}' fantes fra før")
        unless first.text.blank?  # not a disambiguation page - update it and create dis'n page
          Article.without_versioning do
            first.update_attributes!(:headword => ArticleXml.extended_headword(first), :ambiguous => true)
          end
          Rails.logger.debug("  MIME: Oppdaterte artikkel, nytt headword: '#{first.headword}'")
          Rails.logger.debug("  MIME: Oppretter disambiguation page")
          Article.create!(:headword => @headword, :ambiguous => true, :author => ArticleXml.get_editor)
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
        :author => @user,
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

      def get_user(email, name)
        User.find_or_initialize_by(:email => email).tap do |user|
          if user.new_record?
            user.password = 'nothing'
            user.name = name
            user.save!
          end
        end
      end

      def get_editor
        get_user(ArticleXml.authors[ArticleXml.editor]['email'],
                 ArticleXml.authors[ArticleXml.editor]['name'])
      end
    end
  end
end
