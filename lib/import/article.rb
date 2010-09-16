module Import
  class Article
    include SAXMachine
    attr_accessor :oldid, :id_def, :id
    element :article, :value => :oldid, :as => :oldid
    element :article, :value => :id_def, :as => :id_def
    element :field, :with => {:id => "epoch_start"}, :as => :epoch_start
    element :field, :with => {:id => "epoch_end"}, :as => :epoch_end
    element :field, :with => {:id => "subject"}, :as => :subject
    element :field, :with => {:id => "author"}, :as => :author
    element :field, :with => {:id => "headword"}, :as => :id
    element :field, :with => {:id => "clarification"}, :as => :clarification
    element :body, :as => :text
    elements :article, :as => :articles, :class => Article

    def text=(text)
      @text = text.strip
    end
  end
end
