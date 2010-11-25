# encoding: utf-8

module Import
  class ArticleXml
    include Rails.application.routes.url_helpers
    include ActionView::Helpers::UrlHelper

    cattr_accessor :all_authors
    cattr_accessor :editor

    attr_reader :headword, :text
    attr_reader :subject, :authors, :user
    attr_reader :oldid, :definition, :epoch_start, :epoch_end, :clarification
    attr_reader :disambiguation

    def initialize(node)
      if headword_node = node.at_xpath('metadata/field[@id="headword"]')
        @headword = headword_node.content
      end
      if text_node = node.at_xpath('html/body')
        @text = CGI::unescapeHTML(text_node.inner_html.strip)
        @text.sub! /(<p>)/i do  # Sett inn oppslagsord først i artikkelteksten
          "#{$1}<strong>#{@headword}</strong>, "
        end
      end
      if subject_node = node.at_xpath('metadata/field[@id="subject"]')
        @subject = subject_node.content
      end
      @authors = []
      node.xpath('metadata/field[@id="author"]').each do |author_node|
        @authors << author_node.content
      end
      if epoch_start_node = node.at_xpath('metadata/field[@id="epoch_start"]')
        @epoch_start = epoch_start_node.content
      end
      if epoch_end_node = node.at_xpath('metadata/field[@id="epoch_end"]')
        @epoch_end = epoch_end_node.content
      end
      if clarification_node = node.at_xpath('metadata/field[@id="clarification"]')
        @clarification = clarification_node.content unless clarification_node.content =~ /^\d+$/
      end
      @oldid = node[:oldid]
      @definition = node[:id_def]
    end

    # Oppretter artikkel. Dersom headword fins fra før skjer følgende:
    # * Artikkelen får et nytt headword etter følgende mønster:
    #    - Foo (something)
    #    - Foo (something else)
    #    - Foo (something else - 2)
    #    - Foo (something else - 3)
    # * En 'disambiguation page' med lenke til artikkel opprettes.
    def save!
      @users = @authors.map { |a| ArticleXml.get_user(a) }.compact
      begin
        Rails.logger.debug("  MIME: Prøver å opprette artikkel med standard headword")
        a = Article.new(self.attributes)
        a.authors = @users
        a.save!
      rescue Mongoid::Errors::Validations => e
        first = Article.where(:headword => @headword).first
        Rails.logger.debug("  MIME: Artikkel '#{first.headword}' fantes fra før")
        unless first.text.blank?  # not a disambiguation page - create dis'n page and update it
          Rails.logger.debug("  MIME: Oppretter disambiguation page")
          Rails.logger.debug("  MIME: Oppdaterte artikkel, nytt headword: '#{first.headword}'")
          Article.without_versioning do
            first.update_attributes!(:headword => ArticleXml.extended_headword(first))
            first.update_attributes!(:disambiguation => disambiguation_text(create_or_update_disambiguation_for(first)))
          end
        end
        this_article = Article.new(self.attributes)
        this_article.headword = ArticleXml.extended_headword(this_article)
        this_article.authors = @users
        Rails.logger.debug("  MIME: Oppretter endelig artikkel med headword '#{this_article.headword}'")
        this_article.save!
        disamb_article = create_or_update_disambiguation_for(this_article)
        Article.without_versioning do
          this_article.update_attributes!(:disambiguation => disambiguation_text(disamb_article))
        end
      end
    end

    def attributes
      {
        :headword => @headword,
        :text => @text,
        :subject => @subject,
        :epoch_start => @epoch_start,
        :epoch_end => @epoch_end,
        :oldid => @oldid,
        :definition => @clarification || @definition
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

      def get_user(author)
        if ArticleXml.all_authors[author].instance_of?(Hash)
          email = ArticleXml.all_authors[author]['email']
          name = ArticleXml.all_authors[author]['name']
          User.find_or_initialize_by(:email => email).tap do |user|
            if user.new_record?
              user.password = Devise.friendly_token
              user.name = name
              begin
                user.save!
              rescue => e
                puts user.to_json
                raise e
              end
            end
          end
        end
      end

      def get_editor
        get_user(ArticleXml.editor)
      end
    end

    private

    def disambiguation_text(dis)
      I18n.t('import.disambiguation.link_back_to', :headword => @headword, :headword_link => link_to(@headword, pretty_article_path(dis)))
    end

    def create_or_update_disambiguation_for(article)
      a = Article.find_or_initialize_by(:headword => @headword)
      if a.new_record?
        a.authors << ArticleXml.get_editor
      end
      a.disambiguation = add_disambiguation_link(a.disambiguation, article)
      Article.without_versioning do
        a.save!
      end
      a
    end

    def add_disambiguation_link(text, article)
      if text.blank?
        "<p>" + I18n.t('import.disambiguation.multiple_articles_for', :headword => @headword) + '</p>' +
          "<ul>\n<li>" + link_to(article.headword_presentation, pretty_article_path(article)) + "</li>\n</ul>"
      else
        text.sub(/<\/ul>/, "<li>" + link_to(article.headword_presentation, pretty_article_path(article)) + "</li>\n</ul>")
      end
    end

    def controller
      'articles'
    end
  end
end
