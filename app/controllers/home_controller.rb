# encoding: utf-8

class HomeController < ApplicationController
  def index
    flash.keep

    @page = Page.first(:conditions => {:name => ENV['FRONTPAGE'] || 'Forside'})
    return unless @page

    # @article_lists = [
    #   { :title => "Veier",
    #     :articles => Article.where(:tags_array.in => ['gate', 'vei', 'plass']).limit(5)
    #   },
    #   { :title => "Steder",
    #     :articles => Article.where(:tags_array.in => ['sted']).limit(5)
    #   },
    #   { :title => "Organisasjoner",
    #     :articles => Article.where(:tags_array.in => ['organisasjon']).limit(5)
    #   },
    #   { :title => "Sist oppdatert",
    #     :articles => Article.desc(:updated_at).limit(5)
    #   }
    # ]

    render :template => 'pages/show'
    expires_in 5.minutes, :public => true
  end

  def alphabetic
    @letter = params[:slug]
    # Handle Norwegian letter 'aa' -> 'å'
    headword_re = case @letter
      when 'å' then /^(\p{P})*(å|aa)/i
      when 'a' then /^(\p{P})*a[^a]/i
      else /^(\p{P})*#{@letter}/i
    end
    @articles = Article.where(:headword => headword_re).all.sort
    expires_in 5.minutes, :public => true
    flash.keep
  end
end
