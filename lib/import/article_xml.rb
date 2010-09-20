module Import
  class ArticleXml
    attr_reader :headword, :text
    attr_reader :subject, :author
    attr_reader :oldid, :definition, :epoch_start, :epoch_end
    attr_reader :ambiguous

    def initialize(node)
      if headword_node = node.at_xpath('//field[@id="headword"]')
        @headword = headword_node.content
      end
      if text_node = node.at_xpath('//html/body')
        @text = text_node.inner_html.strip
      end
      if subject_node = node.at_xpath('//field[@id="subject"]')
        @subject = subject_node.content
      end
      if author_node = node.at_xpath('//field[@id="author"]')
        @author = author_node.content
      end
      if epoch_start_node = node.at_xpath('//field[@id="epoch_start"]')
        @epoch_start = epoch_start_node.content
      end
      if epoch_end_node = node.at_xpath('//field[@id="epoch_end"]')
        @epoch_end = epoch_end_node.content
      end
      @oldid = node[:oldid]
      @definition = node[:id_def]
      @ambiguous = false
    end

    def save!
      begin
        Article.create!(self.attributes)
      rescue
        Article.where(:headword => @headword).first.update_attributes!(:ambiguous => true)
        @headword = self.extended_headword
        @ambiguous = true
        a = Article.create!(self.attributes)
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
        :ambiguous => @ambiguous
      }
    end

    def extended_headword
      "#{@headword} (#{@definition})"
    end
  end
end
